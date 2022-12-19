import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/session_state_enum.dart';

import 'shareplay_platform_interface.dart';

class Shareplay {
  Future<bool> start({required String title}) {
    return ShareplayPlatform.instance.start(title: title);
  }

  Future join() {
    return ShareplayPlatform.instance.join();
  }

  Future<SPParticipant> localParticipant() {
    return ShareplayPlatform.instance.localParticipant();
  }

  Future end() {
    return ShareplayPlatform.instance.end();
  }

  Future leave() {
    return ShareplayPlatform.instance.leave();
  }

  Future send(String data) {
    return ShareplayPlatform.instance.send(data);
  }

  Future<SPSessionState> sessionState() {
    return ShareplayPlatform.instance.sessionState();
  }

  Stream<SPDataModel> dataStream() {
    return ShareplayPlatform.instance.dataStream();
  }
}
