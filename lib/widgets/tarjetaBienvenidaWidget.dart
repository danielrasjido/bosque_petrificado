import 'package:flutter/material.dart';
import '../config/appConfig.dart';

class TarjetaBienvenidaWidget extends StatelessWidget {
  final bool isLoading;
  final String nombreUsuario;

  const TarjetaBienvenidaWidget({
    super.key,
    required this.isLoading,
    required this.nombreUsuario,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            isLoading
                ? const CircularProgressIndicator()
                : Text(
              '¡Bienvenido, $nombreUsuario!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tu recorrido comienza aquí 🌲\nCada paso cuenta.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
