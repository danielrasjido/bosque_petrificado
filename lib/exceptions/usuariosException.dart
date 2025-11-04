import 'base/appException.dart';

class UsuariosException extends AppException {
  UsuariosException(String message, {int? code}) : super(message, code: code);

  @override
  String toString() => 'UsuariosException: $message (code: $code)';
}
