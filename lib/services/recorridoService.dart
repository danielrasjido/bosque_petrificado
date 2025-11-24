import 'package:shared_preferences/shared_preferences.dart';

class RecorridoService {
  static const String _inicioKey = "recorridoInicio";         // timestamp del inicio
  static const String _pasosInicioKey = "recorridoPasosInicio"; // pasos al iniciar

  /// Guarda inicio del recorrido: hora y pasos actuales
  Future<void> iniciarRecorrido(int pasosActuales) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_inicioKey, DateTime.now().millisecondsSinceEpoch);
    await prefs.setInt(_pasosInicioKey, pasosActuales);
  }

  /// Devuelve el timestamp del inicio o null
  Future<int?> getInicio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_inicioKey);
  }

  /// Devuelve los pasos iniciales o null
  Future<int?> getPasosInicio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pasosInicioKey);
  }

  /// Limpia el recorrido al finalizar (o reiniciar)
  Future<void> limpiarRecorrido() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inicioKey);
    await prefs.remove(_pasosInicioKey);
  }

  /// Saber si hay un recorrido activo
  Future<bool> hayRecorridoActivo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_inicioKey) && prefs.containsKey(_pasosInicioKey);
  }
}
