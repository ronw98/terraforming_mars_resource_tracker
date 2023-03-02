abstract class UserRepository {
  /// Clears all user data from remote server
  Future<bool> clearUserData();

  /// Whether the user is an active connected user or not
  Future<bool> isConnected();
}