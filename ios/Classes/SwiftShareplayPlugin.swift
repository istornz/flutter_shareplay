import Flutter
import UIKit
import GroupActivities
import Combine

@available(iOS 15, *)
public class SwiftShareplayPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var messageSink: FlutterEventSink?
  
  var session: GroupSession<SharePlayActivity>?
  var messenger: GroupSessionMessenger?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "shareplay", binaryMessenger: registrar.messenger())
    let dataChannel = FlutterEventChannel(name: "shareplay/data", binaryMessenger: registrar.messenger())
    
    let instance = SwiftShareplayPlugin()
    
    dataChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    messageSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    messageSink = nil
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
    case "join":
      join(result: result)
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
  func join(result: @escaping FlutterResult) {
    Task {
      for await session in SharePlayActivity.sessions() {
        self.configureGroupSession(session)
      }
    }
    result(nil)
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
      let resultData = try await activity.activate()
      join(result: result)
      result(resultData)
    }
  }
  
  
  func configureGroupSession(_ session: GroupSession<SharePlayActivity>) {
    self.session = session
    
    let messenger = GroupSessionMessenger(session: session)
    self.messenger = messenger
    
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
}
