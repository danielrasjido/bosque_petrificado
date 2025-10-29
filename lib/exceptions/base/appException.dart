class AppException implements Exception {
  final String message;
  final int? code; // código de error HTTP que puede venir de appWrite :b

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}