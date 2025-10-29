import 'base/appException.dart';

class ParadasException extends AppException{
  ParadasException(String message, {int? code}) : super(message, code: code);

  @override
  String toString() => 'ParadasException: $message (code: $code)';
}