abstract class CustomException implements Exception {
  String? get message;
}

class GameRepositoryException implements CustomException {
  GameRepositoryException([this.message]);

  final String? message;

  String toString() {
    if (message == null) return 'GameRepositoryException';
    return 'GameRepositoryException: $message';
  }
}

class NoCurrentGameException extends GameRepositoryException {
  NoCurrentGameException() : super('No ongoing game');
}

class UserResourcesRepositoryException implements CustomException {
  UserResourcesRepositoryException([this.message]);

  final String? message;

  String toString() {
    if (message == null) return 'UserResourcesRepositoryException';
    return 'UserResourcesRepositoryException: $message';
  }
}
