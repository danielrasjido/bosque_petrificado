import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/models/DesbloqueaDTO.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/paradasService.dart';
import 'package:bosque_petrificado/exceptions/desbloqueaException.dart';

class DesbloqueaService {
  final Databases _databases;

  static const String idDB = AppConfig.idDatabase;
  static const String idCollection = 'Desbloquea';

  DesbloqueaService({required Databases databases})
      : _databases = databases;

  /// Registrar desbloqueo con ID compuesto, usario + parada
  Future<bool> registrarDesbloqueo(String usuarioId, String paradaId) async {
    try {
      await _databases.createDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: ID.unique(), // ID automático
        data: {
          'usuarioId': usuarioId,
          'paradaId': paradaId,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      throw DesbloqueaException(
        'Error al registrar desbloqueo: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw DesbloqueaException(
        'Error desconocido al registrar desbloqueo: $e',
      );
    }
  }


  /// Listar las paradas que el usuario desbloqueó
  Future<List<DesbloqueaDTO>> obtenerDesbloqueosPorUsuario(
      String usuarioId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: idDB,
        collectionId: idCollection,
        queries: [
          Query.equal('usuarioId', usuarioId),
        ],
      );

      return result.documents
          .map((doc) => DesbloqueaDTO.fromDocument(doc.data, doc.$id))
          .toList();
    } on AppwriteException catch (e) {
      throw DesbloqueaException(
        'Error al listar desbloqueos del usuario: ${e.message}',
        code: e.code,
      );
    }
  }

  /// Listar los usuarios que desbloquearon una parada
  Future<List<DesbloqueaDTO>> obtenerDesbloqueosPorParada(
      String paradaId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: idDB,
        collectionId: idCollection,
        queries: [
          Query.equal('paradaId', paradaId),
        ],
      );

      return result.documents
          .map((doc) => DesbloqueaDTO.fromDocument(doc.data, doc.$id))
          .toList();
    } on AppwriteException catch (e) {
      throw DesbloqueaException(
        'Error al listar usuarios por parada: ${e.message}',
        code: e.code,
      );
    }
  }

  /// Eliminar la relación usuario–parada
  Future<bool> eliminarDesbloqueo(
      String usuarioId, String paradaId) async {
    final idCompuesto = '${usuarioId}_$paradaId';

    try {
      await _databases.deleteDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: idCompuesto,
      );
      return true;
    } on AppwriteException catch (e) {
      throw DesbloqueaException(
        'Error al eliminar desbloqueo: ${e.message}',
        code: e.code,
      );
    }
  }

  Future<ParadasDTO?> desbloquearSiguienteParada(String usuarioId) async {
    try {
      final paradasService = ParadasService(databases: _databases);

      // 1) Obtener todas las paradas
      final todas = await paradasService.listarParadas();

      // 2) Obtener las ya desbloqueadas
      final desbloqueos = await obtenerDesbloqueosPorUsuario(usuarioId);

      final idsDesbloqueados = desbloqueos.map((d) => d.paradaId).toList();

      // 3) Ordenar por "orden"
      final ordenadas = [...todas]..sort((a, b) => a.orden.compareTo(b.orden));

      // 4) Buscar la primera no desbloqueada
      ParadasDTO? siguiente;
      for (var p in ordenadas) {
        if (!idsDesbloqueados.contains(p.id)) {
          siguiente = p;
          break;
        }
      }

      if (siguiente == null) return null;

      // 5) Registrar desbloqueo
      await registrarDesbloqueo(usuarioId, siguiente.id);

      return siguiente;
    } catch (e) {
      print("Error en desbloquearSiguienteParada: $e");
      rethrow;
    }
  }

  Future<List<DesbloqueaDTO>> listarParadasDesbloqueadas(String usuarioId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConfig.idDatabase,
        collectionId: AppConfig.idCollectionDesbloquea,
        queries: [
          Query.equal("usuarioId", usuarioId),
        ],
      );

      return response.documents.map((doc) {
        return DesbloqueaDTO.fromDocument(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      throw DesbloqueaException("Error listando paradas desbloqueadas: $e");
    }
  }


}
