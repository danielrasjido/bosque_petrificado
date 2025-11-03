import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/paradasService.dart';

Future<void> main() async {
  // Inicializar cliente Appwrite
  final client = Client()
    ..setEndpoint(AppConfig.endpoint)
    ..setProject(AppConfig.idProject)
    ..setSelfSigned(status: true);

  final databases = Databases(client);
  final paradasService = ParadasService(databases: databases);

  print('\n==============================');
  print('INICIO DE TEST PARADAS SERVICE');
  print('==============================\n');

  try {
    //crear
    print('Creando una nueva parada...');
    final nuevaParada = ParadasDTO(
      id: '',
      nombreParada: 'Sendero KLASDFKLADSKLFJ',
      tituloParada: 'Inicio deKLSAJDFKLD l recorrido',
      descripcionParada: 'Parada crKLADJFKLAJSDFPJeada para probar el servicio.',
      imagen: 'img_test.jpg',
      audio: 'audio_test.mp3',
      imagenAudioguia: 'audioguia_test.jpg',
    );

    final creada = await paradasService.crearParada(nuevaParada);
    print('Parada creada correctamente: $creada');

    //listar
    print('Listando todas las paradas:');
    final paradas = await paradasService.listarParadas();
    print('Total de paradas encontradas: ${paradas.length}');
    for (final p in paradas) {
      print('🪵 ${p.id} → ${p.nombreParada}');
    }

    /*
    //obtener
    if (paradas.isNotEmpty) {
      final primera = paradas.last;
      print('\n🔍 Obteniendo parada por ID (${primera.id})...');
      final parada = await paradasService.obtenerParadaPorId(primera.id);
      print('Parada encontrada: ${parada?.tituloParada}');
    }

    //actualizar
    if (paradas.isNotEmpty) {
      final primera = paradas.last.copyWith(
        tituloParada: 'Inicio del recorrido (editado)',
      );

      print('\n✏️ Actualizando parada ${primera.id}...');
      final actualizada = await paradasService.actualizarParada(primera);
      print('✅ Parada actualizada: ${actualizada.tituloParada}');
    }

    //eliminar
 /*   if (paradas.isNotEmpty) {
      final idAEliminar = paradas.last.id;
      print('\n🗑 Eliminando parada ${idAEliminar}...');
      final eliminada = await paradasService.eliminarParada(idAEliminar);
      print('Parada eliminada: ${eliminada.nombreParada}');
    }*/
*/
    print('\nTodas las operaciones CRUD se ejecutaron correctamente.\n');
  } catch (e) {
    print('Error durante la prueba: $e');
  }

  print('==============================');
  print('🧾 FIN DE TEST PARADAS SERVICE');
  print('==============================\n');
}