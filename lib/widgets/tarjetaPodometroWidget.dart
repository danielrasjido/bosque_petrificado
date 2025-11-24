import 'package:flutter/material.dart';
import '../config/appConfig.dart';

class TarjetaPodometroWidget extends StatelessWidget {
  final bool podometroCargando;
  final bool podometroInicializado;
  final int pasos;
  final VoidCallback onReiniciar;
  final int? minutosRecorrido;


  const TarjetaPodometroWidget({
    super.key,
    required this.podometroCargando,
    required this.podometroInicializado,
    required this.pasos,
    required this.onReiniciar,
    this.minutosRecorrido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppConfig.colorPrincipal,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tu recorrido: ', style: Theme.of(context).textTheme.titleLarge),
            //const SizedBox(height: 20),

            // Si el podómetro está cargando
            if (podometroCargando)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  // Indicador circular del progreso
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [


                            //Icon(Icons.directions_walk, color: AppConfig.colorPrincipal),
                            //SizedBox(width: 8),

                        Positioned(
                            child: Text(
                              '$pasos pasos',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),


                            //ESTO ES PARA MOSTRAR EL TIEMPO
                            if (minutosRecorrido != null)
                              Positioned(
                                bottom: 10,
                                child: Text(
                                  "$minutosRecorrido min"
                                ),
                              ),


                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    podometroInicializado
                        ? 'Podómetro activo'
                        : 'Podómetro no disponible',
                    style: TextStyle(
                      color: podometroInicializado ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: onReiniciar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar Podómetro'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
