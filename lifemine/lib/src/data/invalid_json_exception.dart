class InvalidJsonException implements Exception {
  InvalidJsonException({this.message = 'Invalid Json'});

  final String message;

  @override
  String toString() => message;
}
