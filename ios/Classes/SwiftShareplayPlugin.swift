import Flutter
import UIKit
import GroupActivities
import Combine

@available(iOS 15, *)
public class SwiftShareplayPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var messageSink: FlutterEventSink?
  private var newSessionSink: FlutterEventSink?
  
  var session: GroupSession<SharePlayActivity>?
  var messenger: GroupSessionMessenger?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "shareplay", binaryMessenger: registrar.messenger())
    let dataChannel = FlutterEventChannel(name: "shareplay/data", binaryMessenger: registrar.messenger())
    let newSessionChannel = FlutterEventChannel(name: "shareplay/new_session", binaryMessenger: registrar.messenger())
    
    let instance = SwiftShareplayPlugin()
    
    dataChannel.setStreamHandler(instance)
    newSessionChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    if arguments as? String == "dataStream" {
      messageSink = events
    }
    
    if arguments as? String == "newSessionStream" {
      newSessionSink = events
    }
    
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if arguments as? String == "dataStream" {
      messageSink = nil
    }
    
    if arguments as? String == "newSessionStream" {
      newSessionSink = nil
    }
    return nil
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "start":
      guard let args = call.arguments  as? [String: Any] else {
        return
      }
      if let activityName = args["title"] as? String {
        start(title: activityName, result: result)
      } else {
        result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if \"title\" is valid", details: nil))
      }
    case "end":
      end(result: result)
    case "localParticipant":
      if let localParticipantId = session?.localParticipant.id.uuidString {
        var spParticipant: Dictionary<String, Any> = Dictionary()
        spParticipant["id"] = localParticipantId
        result(spParticipant);
      } else {
        result(FlutterError(code: "SESSION_NOT_SET", message: "no session are set, check if you are joined the activity!", details: nil))
      }
    case "currentSession":
      result(currentSession())
    case "join":
      join()
      result(nil)
    case "sessionState":
      sessionState(result: result)
    case "leave":
      leave(result: result)
    case "send":
      guard let args = call.arguments  as? [String: Any] else {
        return
      }
      if let data = args["data"] as? String {
        send(data: data, result: result)
      } else {
        result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if \"data\" is valid", details: nil))
      }
    default:
      break
    }
  }
  
  @available(iOS 15, *)
  func send(data: String, result: @escaping FlutterResult) {
    if let messenger = messenger {
      Task {
        do {
          try await messenger.send(data)
          result(nil)
        } catch {
          result(FlutterError(code: "SENDING_FAIL", message: "impossible to send message", details: error.localizedDescription))
        }
      }
    }
  }
  
  @available(iOS 15, *)
  func sessionState(result: @escaping FlutterResult) {
    switch(self.session?.state) {
    case .joined:
        result("joined")
    case .waiting:
        result("joined")
    default:
        result("invalidated")
    }
  }
  
  @available(iOS 15, *)
  func leave(result: @escaping FlutterResult) {
    session?.leave()
    session = nil
    result(nil)
  }
  
  
  @available(iOS 15, *)
  func end(result: @escaping FlutterResult) {
    session?.end()
    session = nil
    result(nil)
  }
  
  @available(iOS 15, *)
  func start(title: String, result: @escaping FlutterResult) {
    let activity = SharePlayActivity(
      title: title
    )
    
    Task {
      do {
        let resultData = try await activity.activate()
        result(resultData)
      } catch {
        result(FlutterError(code: "ACTIVATION_FAIL", message: "impossible start activity", details: error.localizedDescription))
      }
    }
  }
  
  func join() {
    Task {[weak self] in
      for await session in SharePlayActivity.sessions() {
        self?.configureGroupSession(session)
                }
            }
//    Task {
//      for await session in SharePlayActivity.sessions() {
//        self.configureGroupSession(session)
//      }
//    }
  }
  
  
  func configureGroupSession(_ session: GroupSession<SharePlayActivity>) {
    self.session = session
    
    let messenger = GroupSessionMessenger(session: session)
    self.messenger = messenger
    
    self.newSessionSink?.self(currentSession())
    
    Task.detached { [weak self] in
      for await (message, data) in messenger.messages(of: String.self) {
        var spParticipant: Dictionary<String, Any> = Dictionary()
        spParticipant["id"] = data.source.id.uuidString
        
        var spResult: Dictionary<String, Any> = Dictionary()
        spResult["message"] = message;
        spResult["participant"] = spParticipant;
        
        self?.messageSink?.self(spResult)
      }
    }
    
    session.join()
  }
  
  func currentSession() -> Dictionary<String, Any>? {
    if (self.session == nil) {
      return nil
    }
    
    var spSession: Dictionary<String, Any> = Dictionary()
    spSession["id"] = self.session?.id.uuidString
    spSession["title"] = self.session?.activity.title
    return spSession
  }
}
