import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'shareplay_platform_interface.dart';

/// An implementation of [ShareplayPlatform] that uses method channels.
class MethodChannelShareplay extends ShareplayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shareplay');

  @override
  Future<bool> isSharePlayAvailable() async {
    final result =
        await methodChannel.invokeMethod<bool>('isSharePlayAvailable');
    return result ?? false;
  }
}
