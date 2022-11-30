import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplay/shareplay_method_channel.dart';

void main() {
  MethodChannelShareplay platform = MethodChannelShareplay();
  const MethodChannel channel = MethodChannel('shareplay');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.isSharePlayAvailable(), true);
  });
}
