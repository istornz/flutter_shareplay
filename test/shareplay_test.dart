import 'package:flutter_test/flutter_test.dart';
import 'package:shareplay/shareplay.dart';
import 'package:shareplay/shareplay_platform_interface.dart';
import 'package:shareplay/shareplay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockShareplayPlatform
    with MockPlatformInterfaceMixin
    implements ShareplayPlatform {

  @override
  Future<bool> isSharePlayAvailable() => Future.value(true);
}

void main() {
  final ShareplayPlatform initialPlatform = ShareplayPlatform.instance;

  test('$MethodChannelShareplay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShareplay>());
  });

  test('getPlatformVersion', () async {
    Shareplay shareplayPlugin = Shareplay();
    MockShareplayPlatform fakePlatform = MockShareplayPlatform();
    ShareplayPlatform.instance = fakePlatform;

    expect(await shareplayPlugin.isSharePlayAvailable(), true);
  });
}
