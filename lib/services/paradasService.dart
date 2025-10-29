import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/exceptions/paradasException.dart';

class ParadasService{
  final Databases _databases;

  static const String idDB = AppConfig.idDatabase;
  static const String idCollection = AppConfig.idCollectionParadas;

  ParadasService({required Databases databases}) : _databases = databases;



  //metdos CRUD

  Future<List<ParadasDTO>> listarParadas() async {
    try{
      final result = await _databases.listDocuments(databaseId: idDB, collectionId: idCollection);
      final paradas = result.documents
          .map( (doc) => ParadasDTO.fromDocument(doc.data, doc.$id) )
          .toList();

      return paradas;
    }catch(e){
      print('Error en el listado: $e');
      return [];
    }

  }

  Future<ParadasDTO?> obtenerParadaPorId(String id) async {
    try{
      final result = await _databases.getDocument(databaseId: idDB, collectionId: idCollection, documentId: id);
      final parada = ParadasDTO.fromDocument(result.data, result.$id);
      return parada;
    }catch(e){
      print(' Error al obtener parada con ID $id: $e');
      return null;
    }


  }

  Future<bool> crearParada(ParadasDTO parada) async {
    try{
      //para que appwrite maneje los id uso ID.unique() que es una utilida que viene con el packete de appwrite sxd
      await _databases.createDocument(databaseId: idDB, collectionId: idCollection, documentId: ID.unique(), data: parada.toMap());
      return true;
    }on AppwriteException catch (e) {
      throw ParadasException('Error al crear la parada: ${e.message}', code: e.code);
    } catch (e) {
      throw ParadasException('Error desconocido al crear la parada: $e');
    }
  }


  Future<ParadasDTO> actualizarParada(ParadasDTO parada) async {
    try {
      if (parada.id == null) {
        throw ParadasException('No se puede actualizar una parada sin ID');
      }

      final result = await _databases.updateDocument(
        databaseId: idDB,
        collectionId: idCollection,
        documentId: parada.id!,
        data: parada.toMap(),
      );

      // reconstruimos el DTO con los datos actualizados
      final paradaActualizada = ParadasDTO.fromDocument(result.data, result.$id);

      return paradaActualizada;
    } on ParadasException catch (e) {
      // Si es una excepción personalizad
      throw ParadasException('Error al actualizar la parada: ${e.message}', code: e.code);
    } on AppwriteException catch (e) {
      // Si es un error propio del SDK
      throw ParadasException('Error al actualizar la parada: ${e.message}', code: e.code);
    } catch (e) {
      // Cualquier otro error ¿
      throw ParadasException('Error desconocido al actualizar la parada: $e');
    }
  }

 Future<ParadasDTO> eliminarParada(String id) async {
   try {
     // Obtener la parada antes de eliminarla
     final paradaEliminada = await obtenerParadaPorId(id);
     if (paradaEliminada == null) {
       throw ParadasException('No se encontró la parada con ID $id');
     }

     // Eliminar el documento
     await _databases.deleteDocument(
       databaseId: idDB,
       collectionId: idCollection,
       documentId: id,
     );

     // Devolver la parada que fue eliminada
     return paradaEliminada;
   } on AppwriteException catch (e) {
     throw ParadasException('Error al eliminar la parada: ${e.message}', code: e.code);
   } catch (e) {
     throw ParadasException('Error desconocido al eliminar la parada: $e');
   }
 }
}