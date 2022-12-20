enum SPSessionState {
  /// An idle state that indicates the session is waiting for the app to join the activity.
  waiting,

  /// An active state that indicates the session allows data synchronization between devices.
  joined,

  /// A state that indicates the session is no longer valid and can't be used
  /// for shared activities.
  invalidated,
}
