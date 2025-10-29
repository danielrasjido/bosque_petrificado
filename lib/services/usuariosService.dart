//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appwrite/appwrite.dart';
class UsuarioService {
  final Databases _databases;

  // Recibir databases por constructor
  UsuarioService({required Databases databases}) : _databases = databases;


  Future<String> traerNombres() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: '68f6cb32001b9d6b8649',
        collectionId: 'Usuarios', // nombre de la colección
      );

      if (response.documents.isEmpty) {
        return 'No hay usuarios registrados.';
      }

      // Mapear los nombres
      final nombres = response.documents.map((doc) {
        final data = doc.data;
        return data['nombre'] ?? 'Sin nombre';
      }).join(', ');

      print('Nombres obtenidos: $nombres');
      return nombres;
    } catch (e) {
      print('Error trayendo nombres: $e');
      return 'Error: $e';
    }
  }




  Future<String> traerNombreUsuario(String userId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: '68f6cb32001b9d6b8649',
        collectionId: 'Usuarios',
        documentId: userId,
      ); //hacemos el fetch al backend

      final data = doc.data; //mapeamos los datos
      print('###########Usuario obtenido: $data');
      return data['nombre'] ?? 'Sin nombre';
    } catch (e) {
      print('###########Error trayendo usuario: $e');
      return 'Error: $e';
    }
  }

}

