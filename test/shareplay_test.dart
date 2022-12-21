import 'package:flutter_test/flutter_test.dart';
import 'package:shareplay/models/session_state_enum.dart';
import 'package:shareplay/models/session_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/shareplay.dart';
import 'package:shareplay/shareplay_platform_interface.dart';
import 'package:shareplay/shareplay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockShareplayPlatform
    with MockPlatformInterfaceMixin
    implements ShareplayPlatform {
  @override
  Future<SPSession?> currentSession() {
    return Future.value(
      SPSession(id: '123', title: 'test'),
    );
  }

  @override
  Stream<SPDataModel> dataStream() {
    return Stream.value(
      SPDataModel(
        participant: SPParticipant(id: '1234'),
        message: 'A message',
      ),
    );
  }

  @override
  Future end() => Future.value();

  @override
  Future join() => Future.value();

  @override
  Future leave() => Future.value();

  @override
  Future<SPParticipant> localParticipant() {
    return Future.value(SPParticipant(id: '1234'));
  }

  @override
  Stream<SPSession> newSessionStream() {
    return Stream.value(SPSession(id: '123', title: 'test'));
  }

  @override
  Future send(String data) => Future.value();

  @override
  Stream<SPSessionState> sessionStateStream() {
    return Stream.value(SPSessionState.joined);
  }

  @override
  Future<bool> start({required String title}) => Future.value(true);
  
  @override
  Stream<List<SPParticipant>> participantsStream() {
    return Stream.value([
      SPParticipant(id: '1234'),
      SPParticipant(id: '12345'),
      SPParticipant(id: '123456'),
    ]);
  }
}

void main() {
  final ShareplayPlatform initialPlatform = ShareplayPlatform.instance;

  Shareplay shareplayPlugin = Shareplay();
  MockShareplayPlatform fakePlatform = MockShareplayPlatform();
  ShareplayPlatform.instance = fakePlatform;

  test('$MethodChannelShareplay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShareplay>());
  });

  test('join', () async {
    expect(await shareplayPlugin.join(), null);
  });

  test('leave', () async {
    expect(await shareplayPlugin.leave(), null);
  });

  test('end', () async {
    expect(await shareplayPlugin.end(), null);
  });

  test('start', () async {
    expect(await shareplayPlugin.start(title: 'A title'), true);
  });

  test('currentSession', () async {
    final session = await shareplayPlugin.currentSession();
    expect(session!.id, '123');
    expect(session.title, 'test');
  });

  test('localParticipant', () async {
    final participant = await shareplayPlugin.localParticipant();
    expect(participant!.id, '1234');
  });

  test('send', () async {
    expect(await shareplayPlugin.send('A message'), null);
  });

  test('dataStream', () async {
    final dataModel = await shareplayPlugin.dataStream().first;
    expect(dataModel.message, 'A message');
    expect(dataModel.participant.id, '1234');
  });

  test('newSessionStream', () async {
    final sessionModel = await shareplayPlugin.newSessionStream().first;
    expect(sessionModel.id, '123');
    expect(sessionModel.title, 'test');
  });

  test('sessionStateStream', () async {
    final sessionState = await shareplayPlugin.sessionStateStream().first;
    expect(sessionState, SPSessionState.joined);
  });

  test('participantsStream', () async {
    final participants = await shareplayPlugin.participantsStream().first;
    expect(participants.length, 3);
    expect(participants.first.id, '1234');
    expect(participants[1].id, '12345');
    expect(participants.last.id, '123456');
  });
}
