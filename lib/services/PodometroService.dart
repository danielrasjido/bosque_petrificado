import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PodometroService {
  int _pasos = 0;
  Function(int)? onPasosActualizados;

  // --- Parámetros del detector de pasos ---
  final List<double> _magnitudes = [];
  final int _maxMagnitudes = 25;

  double _thresholdOffset = 0.7;
  int _minStepIntervalMs = 250; // evita pasos falsos
  DateTime? _lastStepTime;

  StreamSubscription? _accelSubscription;

  Future<void> inicializarPodometro() async {
    // Permiso opcional (Android 10+)
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      await Permission.activityRecognition.request();
    }

    // Escuchar acelerómetro
    _accelSubscription = accelerometerEvents.listen((event) {
      final double magnitude =
      sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      _magnitudes.add(magnitude);
      if (_magnitudes.length > _maxMagnitudes) {
        _magnitudes.removeAt(0);
      }

      if (_esPaso()) {
        _pasos++;
        onPasosActualizados?.call(_pasos);
      }
    });
  }

  bool _esPaso() {
    if (_magnitudes.length < 5) return false;

    final avg = _magnitudes.reduce((a, b) => a + b) / _magnitudes.length;
    final latest = _magnitudes.last;

    // Variancia para calcular estabilidad
    final variance = _magnitudes
        .map((v) => pow(v - avg, 2))
        .reduce((a, b) => a + b) /
        _magnitudes.length;
    final stabilityFactor = variance < 1.0 ? 0.6 : 0.8;

    // Umbral dinámico
    final dynamicThreshold = avg + _thresholdOffset * stabilityFactor;

    // ¿Superó el umbral?
    if (latest <= dynamicThreshold) return false;

    // Evita doble detección
    final now = DateTime.now();
    if (_lastStepTime != null) {
      final diff = now.difference(_lastStepTime!).inMilliseconds;
      if (diff < _minStepIntervalMs) return false;
    }

    _lastStepTime = now;
    return true;
  }

  int get pasosActuales => _pasos;

  void reiniciarContador() {
    _pasos = 0;
    onPasosActualizados?.call(_pasos);
  }

  void detener() {
    _accelSubscription?.cancel();
  }
}
