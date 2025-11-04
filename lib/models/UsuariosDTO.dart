import 'dart:convert';

class UsuariosDTO {
  final String id; // $id (generado por Appwrite)
  final String nombre;
  final String correoElectronico;
  final DateTime fechaNacimiento;
  final String contrasena;
  final bool esAdmin;

  UsuariosDTO({
    required this.id,
    required this.nombre,
    required this.correoElectronico,
    required this.fechaNacimiento,
    required this.contrasena,
    required this.esAdmin,
  });

  ///Convierte un documento Appwrite en un objeto DTO
  factory UsuariosDTO.fromDocument(Map<String, dynamic> data, String id) {
    return UsuariosDTO(
      id: id,
      nombre: data['nombre'] ?? '',
      correoElectronico: data['correoElectronico'] ?? '',
      fechaNacimiento: DateTime.tryParse(data['fechaNacimiento'] ?? '') ?? DateTime(2000, 1, 1),
      contrasena: data['contrasena'] ?? '',
      esAdmin: data['esAdmin'] ?? false,
    );
  }

  ///Convierte el DTO a Map para crear/actualizar en Appwrite
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correoElectronico': correoElectronico,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'contrasena': contrasena,
      'esAdmin': esAdmin,
    };
  }

  ///Copia modificando algunos campos (útil para updates parciales)
  UsuariosDTO copyWith({
    String? nombre,
    String? correoElectronico,
    DateTime? fechaNacimiento,
    String? contrasena,
    bool? esAdmin,
  }) {
    return UsuariosDTO(
      id: id,
      nombre: nombre ?? this.nombre,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      contrasena: contrasena ?? this.contrasena,
      esAdmin: esAdmin ?? this.esAdmin,
    );
  }

  ///Convierte el objeto a JSON (texto plano)
  String toJson() => jsonEncode(toMap());

  ///Convierte un JSON (texto plano) a un UsuariosDTO
  factory UsuariosDTO.fromJson(String s) {
    final Map<String, dynamic> data = jsonDecode(s);
    return UsuariosDTO(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      correoElectronico: data['correoElectronico'] ?? '',
      fechaNacimiento: DateTime.tryParse(data['fechaNacimiento'] ?? '') ?? DateTime(2000, 1, 1),
      contrasena: data['contrasena'] ?? '',
      esAdmin: data['esAdmin'] ?? false,
    );
  }
}
