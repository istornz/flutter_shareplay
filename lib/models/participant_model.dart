class SPParticipant {
  /// A globally unique identifier for the session participant.
  final String id;

  SPParticipant({
    required this.id,
  });

  factory SPParticipant.fromMap(Map<String, dynamic> map) {
    return SPParticipant(
      id: map['id'],
    );
  }
}
