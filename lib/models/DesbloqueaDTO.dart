import 'dart:convert';

class DesbloqueaDTO {
  final String id;
  final String usuarioId;
  final String paradaId;

  DesbloqueaDTO({
    required this.id,
    required this.usuarioId,
    required this.paradaId,
  });

  factory DesbloqueaDTO.fromDocument(Map<String, dynamic> data, String id) {
    return DesbloqueaDTO(
      id: id,
      usuarioId: data['usuarioId'] ?? '',
      paradaId: data['paradaId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'paradaId': paradaId,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory DesbloqueaDTO.fromJson(String source) {
    final data = jsonDecode(source);
    return DesbloqueaDTO(
      id: data['id'],
      usuarioId: data['usuarioId'],
      paradaId: data['paradaId'],
    );
  }

  DesbloqueaDTO copyWith({
    String? usuarioId,
    String? paradaId,
  }) {
    return DesbloqueaDTO(
      id: id,
      usuarioId: usuarioId ?? this.usuarioId,
      paradaId: paradaId ?? this.paradaId,
    );
  }
}
