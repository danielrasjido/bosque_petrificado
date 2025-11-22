import 'dart:convert'; //esto es para usar json

class ParadasDTO{
  final String id;
  final String nombreParada;
  final String tituloParada;
  final String descripcionParada;
  final String imagen;          // ID del archivo
  final String audio;           // ID del archivo
  final String imagenAudioguia;  // ID del archivo
  final int orden;

  ParadasDTO({
    required this.id,
    required this.nombreParada,
    required this.tituloParada,
    required this.descripcionParada,
    required this.imagen,
    required this.audio,
    required this.imagenAudioguia,
    required this.orden
  });


  ///para pasar un documento appWrite a un objeto dto
  factory ParadasDTO.fromDocument(Map<String, dynamic> data, String id) {
    return ParadasDTO(
      id: id,
      nombreParada: data['nombreParada_es'] ?? '',
      tituloParada: data['tituloParada_es'] ?? '',
      descripcionParada: data['descripcionParada_es'] ?? '',
      imagen: data['imagen'] ?? '',
      audio: data['audioParada_es'] ?? '',
      imagenAudioguia: data['imagenAudioguia'] ?? '',
      orden: data['orden'] ?? 0,
    );
  }

  /// Convierte el DTO a Map para create/update en Appwrite
  Map<String, dynamic> toMap() {
    return {
      'nombreParada_es': nombreParada,
      'tituloParada_es': tituloParada,
      'descripcionParada_es': descripcionParada,
      'imagen': imagen,
      'audioParada_es': audio,
      'imagenAudioguia': imagenAudioguia,
      'orden': orden,
    };
  }

  ///para updates parciales
  ParadasDTO copyWith({
    String? nombreParada,
    String? tituloParada,
    String? descripcionParada,
    String? imagen,
    String? audio,
    String? imagenAudioguia,
    int? orden,
  }) {
    return ParadasDTO(
      id: id,
      nombreParada: nombreParada ?? this.nombreParada,
      tituloParada: tituloParada ?? this.tituloParada,
      descripcionParada: descripcionParada ?? this.descripcionParada,
      imagen: imagen ?? this.imagen,
      audio: audio ?? this.audio,
      imagenAudioguia: imagenAudioguia ?? this.imagenAudioguia,
      orden: orden ?? this.orden,
    );
  }

  ///Convierte el objeto a JSON (texto plano)
  String toJson() => jsonEncode(toMap());

  ///Convierte un JSON (texto plano) en un ParadasDTO
  factory ParadasDTO.fromJson(String s) {
    final Map<String, dynamic> data = jsonDecode(s);
    return ParadasDTO(
      id: data['id'] ?? '',
      nombreParada: data['nombreParada_es'] ?? '',
      tituloParada: data['tituloParada_es'] ?? '',
      descripcionParada: data['descripcionParada_es'] ?? '',
      imagen: data['imagen'] ?? '',
      audio: data['audioParada_es'] ?? '',
      imagenAudioguia: data['imagenAudioguia'] ?? '',
      orden: data['orden'] ?? 0,
    );
  }

}