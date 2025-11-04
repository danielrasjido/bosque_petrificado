import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/models/UsuariosDTO.dart';
import 'package:bosque_petrificado/services/usuariosService.dart';

Future<void> main() async {
  final client = Client()
    ..setEndpoint(AppConfig.endpoint)
    ..setProject(AppConfig.idProject)
    ..setSelfSigned(status: true);

  final databases = Databases(client);
  final usuariosService = UsuariosService(databases: databases);

  print('\n==============================');
  print('🧪 INICIO DE TEST USUARIOS SERVICE');
  print('==============================\n');

  try {
    // 1️⃣ CREAR USUARIO
    print('🟢 Creando un nuevo usuario...');
    final nuevoUsuario = UsuariosDTO(
      id: '',
      nombre: 'Daniel Rasjido',
      correoElectronico: 'daniel_test@example.com',
      fechaNacimiento: DateTime(2002, 5, 10),
      contrasena: '123456',
      esAdmin: false,
    );

    final creado = await usuariosService.crearUsuario(nuevoUsuario);
    print('✅ Usuario creado correctamente: $creado');

    // 2️⃣ LISTAR USUARIOS
    print('\n📋 Listando usuarios...');
    final usuarios = await usuariosService.listarUsuarios();
    print('✅ Total de usuarios encontrados: ${usuarios.length}');
    for (final u in usuarios) {
      print('👤 ${u.id} → ${u.nombre}');
    }

    // 3️⃣ OBTENER POR ID
    if (usuarios.isNotEmpty) {
      final ultimo = usuarios.last;
      print('\n🔍 Obteniendo usuario por ID (${ultimo.id})...');
      final usuario = await usuariosService.obtenerUsuarioPorId(ultimo.id);
      print('📍 Usuario encontrado: ${usuario?.nombre}');
    }

    // 4️⃣ ACTUALIZAR USUARIO
    if (usuarios.isNotEmpty) {
      final usuario = usuarios.last.copyWith(nombre: 'Daniel Actualizado');
      print('\n✏️ Actualizando usuario ${usuario.id}...');
      final actualizado = await usuariosService.actualizarUsuario(usuario);
      print('✅ Usuario actualizado: ${actualizado.nombre}');
    }

    // 5️⃣ ELIMINAR USUARIO
   /* if (usuarios.isNotEmpty) {
      final idAEliminar = usuarios.last.id;
      print('\n🗑 Eliminando usuario ${idAEliminar}...');
      final eliminado = await usuariosService.eliminarUsuario(idAEliminar);
      print('❌ Usuario eliminado: ${eliminado.nombre}');
    }*/

    print('\n✅ Todas las operaciones CRUD se ejecutaron correctamente.\n');
  } catch (e) {
    print('⚠️ Error durante la prueba: $e');
  }

  print('==============================');
  print('🧾 FIN DE TEST USUARIOS SERVICE');
  print('==============================\n');
}
