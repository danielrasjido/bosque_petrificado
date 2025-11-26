import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';

class CargarParadasScript {
  static Future<void> ejecutar() async {
    final paradasService = ServiceLocator().paradasService;

    final List<ParadasDTO> paradas = [

      ParadasDTO(
        id: "",
        nombreParada: "Parada 3",
        tituloParada: "Huellas del Pasado (Comienzo del Sendero)",
        descripcionParada:
        "El sendero nos espera. Nos tomará entre 1 y 2 hs transitar los 2000 metros...",
        imagen: "p3_imagen",
        audio: "p3_audio",
        imagenAudioguia: "p3_Audioguia",
        orden: 3,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 4",
        tituloParada: "Un ambiente inesperado",
        descripcionParada:
        "Estamos en el período Jurásico. El clima era húmedo y templado...",
        imagen: "p4_imagen",
        audio: "p4_audio",
        imagenAudioguia: "p4_Audioguia",
        orden: 4,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 5",
        tituloParada: "Los maravillosos colosos del bosque",
        descripcionParada:
        "Este tronco mide casi 30 metros. Sus piñas estaban maduras...",
        imagen: "p5_imagen",
        audio: "p5_audio",
        imagenAudioguia: "p5_Audioguia",
        orden: 5,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 6",
        tituloParada: "Línea del tiempo",
        descripcionParada:
        "En este bosque jurásico se avecinaban cambios profundos...",
        imagen: "p6_imagen",
        audio: "p6_audio",
        imagenAudioguia: "p6_Audioguia",
        orden: 6,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 7",
        tituloParada: "Un bosque debajo del mar",
        descripcionParada:
        "Movimientos epirogénicos elevaron y hundieron el continente...",
        imagen: "p7_imagen",
        audio: "p7_audio",
        imagenAudioguia: "p7_Audioguia",
        orden: 7,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 8",
        tituloParada: "Renacer entre las cenizas",
        descripcionParada:
        "La Cordillera modeló el paisaje y cambió el clima regional...",
        imagen: "p8_imagen",
        audio: "p8_audio",
        imagenAudioguia: "p8_Audioguia",
        orden: 8,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 9",
        tituloParada: "Las huellas de los primeros hombres",
        descripcionParada:
        "Aquí descubrimos petroglifos y herramientas prehistóricas...",
        imagen: "p9_imagen",
        audio: "p9_audio",
        imagenAudioguia: "p9_Audioguia",
        orden: 9,
      ),

      ParadasDTO(
        id: "",
        nombreParada: "Parada 10",
        tituloParada: "Somos parte del paisaje",
        descripcionParada:
        "Última parada. Reflexión sobre la conservación del bosque petrificado.",
        imagen: "p10_imagen",
        audio: "p10_audio",
        imagenAudioguia: "p10_Audioguia",
        orden: 10,
      ),
    ];

    print("==== CARGANDO PARADAS 3 A 10 ====");

    for (final parada in paradas) {
      await paradasService.crearParada(parada);
      print("✔ Parada ${parada.orden} cargada correctamente");
    }

    print("==== TODO COMPLETO ====");
  }
}
