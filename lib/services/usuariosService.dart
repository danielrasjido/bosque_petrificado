import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/models/UsuariosDTO.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/exceptions/usuariosException.dart';

class UsuariosService {
  final Databases _databases;

  static const String idDB = AppConfig.idDatabase;
  static const String idCollection = AppConfig.idCollectionUsuarios; //

  UsuariosService({required Databases databases}) : _databases = databases;

  ///LISTAR USUARIOS
  Future<List<UsuariosDTO>> listarUsuarios() async {
    try {
      final result = await _databases.listDocuments(
        databaseId: idDB,
        collectionId: idCollection,
      );

      final usuarios = result.documents
          .map((doc) => UsuariosDTO.fromDocument(doc.data, doc.$id))
          .toList();

      return usuarios;
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al listar usuarios: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al listar usuarios: $e');
    }
  }

  ///OBTENER USUARIO POR ID
  Future<UsuariosDTO?> obtenerUsuarioPorId(String id) async {
    try {
      final result = await _databases.getDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: id,
      );

      final usuario = UsuariosDTO.fromDocument(result.data, result.$id);
      return usuario;
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al obtener usuario: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al obtener usuario: $e');
    }
  }

  ///OBTENER USUARIO POR EMAIL
  Future<UsuariosDTO?> obtenerUsuarioPorEmail(String email) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: idDB,
        collectionId: idCollection,
        queries: [
          Query.equal('correoElectronico', email),
        ],
      );

      if (result.documents.isEmpty) return null;

      final doc = result.documents.first;
      return UsuariosDTO.fromDocument(doc.data, doc.$id);
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al buscar usuario: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al buscar usuario: $e');
    }
  }

  ///CREAR USUARIO
  Future<bool> crearUsuario(UsuariosDTO usuario) async {
    try {
      await _databases.createDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: ID.unique(),
        data: usuario.toMap(),
      );
      return true;
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al crear el usuario: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al crear usuario: $e');
    }
  }

  ///ACTUALIZAR USUARIO
  Future<UsuariosDTO> actualizarUsuario(UsuariosDTO usuario) async {
    try {
      if (usuario.id.isEmpty) {
        throw UsuariosException('No se puede actualizar un usuario sin ID');
      }

      final result = await _databases.updateDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: usuario.id,
        data: usuario.toMap(),
      );

      return UsuariosDTO.fromDocument(result.data, result.$id);
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al actualizar el usuario: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al actualizar usuario: $e');
    }
  }

  ///ELIMINAR USUARIO
  Future<UsuariosDTO> eliminarUsuario(String id) async {
    try {
      final usuarioEliminado = await obtenerUsuarioPorId(id);
      if (usuarioEliminado == null) {
        throw UsuariosException('No se encontró el usuario con ID $id');
      }

      await _databases.deleteDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: id,
      );

      return usuarioEliminado;
    } on AppwriteException catch (e) {
      throw UsuariosException('Error al eliminar el usuario: ${e.message}', code: e.code);
    } catch (e) {
      throw UsuariosException('Error desconocido al eliminar usuario: $e');
    }
  }

  Future<void> crearUsuarioEnBD({
    required String nombre,
    required String email,
    required String telefono,
    required String contrasena,
  }) async {
    await _databases.createDocument(
      databaseId: AppConfig.idDatabase,
      collectionId: AppConfig.idCollectionUsuarios,
      documentId: ID.unique(),
      data: {
        'nombre': nombre,
        'correoElectronico': email,
        'telefono': telefono,
        'contrasena': contrasena,
        'fechaNacimiento': null,
        'esAdmin': false,
      },
    );
  }



}


