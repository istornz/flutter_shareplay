import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<bool> isSharePlayAvailable() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
