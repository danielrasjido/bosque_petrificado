import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/models/UsuariosDTO.dart';
import 'package:bosque_petrificado/services/usuariosService.dart';
import 'package:bosque_petrificado/exceptions/authException.dart';

class AuthenticationService {
  final Account _account;
  final UsuariosService _usuariosService;

  AuthenticationService(Client client, Databases databases)
      : _account = Account(client),
        _usuariosService = UsuariosService(databases: databases);

  ///Iniciar sesión con email y contraseña
  Future<UsuariosDTO?> login(String email, String password) async {
    try {
      //Crear la sesión de usuario en Appwrite
      await _account.createEmailPasswordSession(email: email, password: password);

      //Obtener la cuenta autenticada desde Appwrite
      final user = await _account.get();

      //Buscar si existe en la colección "Usuarios"
      final usuario = await _usuariosService.obtenerUsuarioPorEmail(user.email ?? '');

      // 4️⃣ Si no existe en la colección, crear uno temporal (no guardado aún)
      if (usuario == null) {
        return UsuariosDTO(
          id: '',
          nombre: user.name,
          correoElectronico: user.email ?? '',
          fechaNacimiento: DateTime(2000, 1, 1),
          contrasena: '',
          esAdmin: false,
        );
      }

      return usuario;
    } on AppwriteException catch (e) {
      throw AuthException('Error al iniciar sesión: correo o contraseña inválidos', code: e.code);
    }
  }

  ///errar sesión
  Future<void> logout() async {
    try {
      await _account.deleteSessions();
    } on AppwriteException catch (e) {
      throw Exception('Error al cerrar sesión: ${e.message}');
    }
  }

  ///erificar si hay sesión activa
  Future<UsuariosDTO?> obtenerUsuarioActual() async {
    try {
      final user = await _account.get();
      final usuarios = await _usuariosService.listarUsuarios();

      final usuario = usuarios.firstWhere(
            (u) => u.correoElectronico == user.email,
        orElse: () => UsuariosDTO(
          id: '',
          nombre: user.name,
          correoElectronico: user.email ?? '',
          fechaNacimiento: DateTime(2000, 1, 1),
          contrasena: '',
          esAdmin: false,
        ),
      );

      return usuario;
    } catch (_) {
      //este catch es para que appwrite lancé null en vez de una excepción cuando no haya sesión
      return null;
    }
  }

  UsuariosService get usuariosService => _usuariosService;

}
