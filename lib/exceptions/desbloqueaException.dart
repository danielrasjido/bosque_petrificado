import 'base/appException.dart';

class DesbloqueaException extends AppException {
  DesbloqueaException(String message, {int? code})
      : super(message, code: code);

  @override
  String toString() => 'DesbloqueaException: $message (code: $code)';
}