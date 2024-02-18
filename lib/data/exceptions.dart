class DocumentNotFoundException implements Exception {
  const DocumentNotFoundException(this.message);

  final String message;

  @override
  String toString() => 'DocumentNotFoundException: $message';
}

class TooManyResultsException implements Exception {
  const TooManyResultsException(this.message);

  final String message;

  @override
  String toString() => 'TooManyResultsException: $message';
}
