import 'base/appException.dart';

class AuthException extends AppException {
  AuthException(String message, {int? code}) : super(message, code: code);

  @override
  String toString() => message; // esto es para que el usuario no vea el exception
}
