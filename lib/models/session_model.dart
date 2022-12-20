class SPSession {
  /// The unique identifier of the current session
  String id;

  /// The title of the current activity
  String title;

  SPSession({
    required this.id,
    required this.title,
  });

  factory SPSession.fromMap(Map<String, dynamic> map) {
    return SPSession(
      id: map['id'],
      title: map['title'],
    );
  }
}
