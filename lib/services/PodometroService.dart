import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PodometroService {
  late Stream<StepCount> _stepCountStream;
  int _pasos = 0;
  Function(int)? onPasosActualizados;

  // Inicializar podómetro
  Future<void> inicializarPodometro() async {
    // Solicitar permisos
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      await Permission.activityRecognition.request();
    }

    // Configurar stream de pasos
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepError);
  }

  //  Manejar conteo de pasos
  void _onStepCount(StepCount event) {
    _pasos = event.steps;
    onPasosActualizados?.call(_pasos);
  }

  // Manejar errores
  void _onStepError(error) {
    print("Error en podómetro: $error");
  }

  // Obtener pasos actuales
  int get pasosActuales => _pasos;

  // Reiniciar contador
  void reiniciarContador() {
    _pasos = 0;
  }
}