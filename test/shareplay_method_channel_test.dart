import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplay/shareplay_method_channel.dart';

void main() {
  MethodChannelShareplay platform = MethodChannelShareplay();
  const MethodChannel channel = MethodChannel('shareplay');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'start':
          return true;
        case 'currentSession':
          return {
            'id': '123',
            'title': 'test',
          };
        case 'localParticipant':
          return {
            'id': '1234',
          };
        case 'sessionState':
          return 'joined';
        default:
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('join', () async {
    expect(await platform.join(), null);
  });

  test('leave', () async {
    expect(await platform.leave(), null);
  });

  test('end', () async {
    expect(await platform.end(), null);
  });

  test('start', () async {
    expect(await platform.start(title: 'A title'), true);
  });

  test('currentSession', () async {
    final session = await platform.currentSession();
    expect(session!.id, '123');
    expect(session.title, 'test');
  });

  test('localParticipant', () async {
    final participant = await platform.localParticipant();
    expect(participant!.id, '1234');
  });

  test('send', () async {
    expect(await platform.send('A message'), null);
  });
}
