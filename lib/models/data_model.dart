import 'package:shareplay/models/participant_model.dart';

class SPDataModel {
  final SPParticipant participant;
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
