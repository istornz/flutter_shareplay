import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/session_model.dart';
import 'package:shareplay/models/session_state_enum.dart';

import 'shareplay_platform_interface.dart';

class SharePlay {
  /// Create an activity when a FaceTime call is active.
  /// The system also invites other participants to join the activity.
  ///
  /// [title] is the activity name (this will be visible by all other participants).
  Future<bool> start({required String title}) {
    return ShareplayPlatform.instance.start(title: title);
  }

  /// Starts the shared activity on the current device.
  ///
  /// If join is successful, ```currentSession()``` will return ```SPSession.joined```.
  Future join() {
    return ShareplayPlatform.instance.join();
  }

  /// The participant on the current device.
  ///
  /// Use this property to differentiate the participant on the current device from
  /// participants on other devices.
  Future<SPParticipant?> localParticipant() {
    return ShareplayPlatform.instance.localParticipant();
  }

  /// Ends the activity for the entire group and stops the transfer
  /// of synchronized data.
  ///
  /// If end is successful, ```currentSession()``` will return ```SPSession.invalidated```.
  Future end() {
    return ShareplayPlatform.instance.end();
  }

  /// Leaves the current activity and stops receiving synchronized data.
  ///
  /// If leave is successful, ```currentSession()``` will return ```SPSession.invalidated```.
  Future leave() {
    return ShareplayPlatform.instance.leave();
  }

  /// Send a message to all other participants.
  Future send(String data) {
    return ShareplayPlatform.instance.send(data);
  }

  /// The current session.
  Future<SPSession?> currentSession() {
    return ShareplayPlatform.instance.currentSession();
  }

  /// The stream of messages received from other participants.
  Stream<SPDataModel> dataStream() {
    return ShareplayPlatform.instance.dataStream();
  }

  /// A stream when a new session was created.
  Stream<SPSession> newSessionStream() {
    return ShareplayPlatform.instance.newSessionStream();
  }

  /// A stream of all active participants in the current session.
  /// 
  /// This property reflects the set of people invited to a group session and currently engaged in the shared activity on their device.
  /// 
  /// Members who share in the conversation over FaceTime but don’t join the shared activity aren’t active participants.
  /// 
  /// It will update when a new participant join or leave the session.
  Stream<List<SPParticipant>> participantsStream() {
    return ShareplayPlatform.instance.participantsStream();
  }

  /// A stream of the current session state.
  /// 
  /// Use this property to get the current state value, or configure a subscriber to detect changes to the value.
  Stream<SPSessionState> sessionStateStream() {
    return ShareplayPlatform.instance.sessionStateStream();
  }
}
