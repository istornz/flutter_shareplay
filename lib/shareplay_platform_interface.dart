import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/session_model.dart';
import 'package:shareplay/models/session_state_enum.dart';

import 'shareplay_method_channel.dart';

abstract class ShareplayPlatform extends PlatformInterface {
  /// Constructs a ShareplayPlatform.
  ShareplayPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShareplayPlatform _instance = MethodChannelShareplay();

  /// The default instance of [ShareplayPlatform] to use.
  ///
  /// Defaults to [MethodChannelShareplay].
  static ShareplayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShareplayPlatform] when
  /// they register themselves.
  static set instance(ShareplayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> start({required String title}) {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future join() {
    throw UnimplementedError('join() has not been implemented.');
  }

  Future end() {
    throw UnimplementedError('end() has not been implemented.');
  }

  Future leave() {
    throw UnimplementedError('leave() has not been implemented.');
  }

  Future send(String data) {
    throw UnimplementedError('send() has not been implemented.');
  }

  Future<SPParticipant?> localParticipant() {
    throw UnimplementedError('localParticipant() has not been implemented.');
  }

  Stream<SPSessionState> sessionStateStream() {
    throw UnimplementedError('sessionStateStream() has not been implemented.');
  }

  Future<SPSession?> currentSession() {
    throw UnimplementedError('currentSession() has not been implemented.');
  }

  Stream<SPDataModel> dataStream() {
    throw UnimplementedError('dataStream() has not been implemented.');
  }

  Stream<SPSession> newSessionStream() {
    throw UnimplementedError('newSessionStream() has not been implemented.');
  }

  Stream<List<SPParticipant>> participantsStream() {
    throw UnimplementedError('participantsStream() has not been implemented.');
  }
}
