import 'package:shareplay/models/participant_model.dart';

class SPDataModel {
  /// The participant that sent the message.
  final SPParticipant participant;

  /// The message sent by the participant.
  final String message;

  SPDataModel({
    required this.participant,
    required this.message,
  });

  factory SPDataModel.fromMap(Map<String, dynamic> map) {
    return SPDataModel(
      message: map['message'],
      participant: SPParticipant.fromMap(
        Map<String, dynamic>.from(
          map['participant'],
        ),
      ),
    );
  }
}
