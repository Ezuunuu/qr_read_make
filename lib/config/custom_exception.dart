class CustomException implements Exception {
  CustomException({required this.errorCode, required this.where, this.errorBody});

  final int errorCode;
  final String where;

  final Object? errorBody;

  @override
  String toString() => '$where Error: $errorCode';
}