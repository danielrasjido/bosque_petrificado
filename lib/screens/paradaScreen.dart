import 'package:flutter/material.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/config/appConfig.dart';

class ParadaScreen extends StatelessWidget {
  final ParadasDTO parada;

  const ParadaScreen({super.key, required this.parada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parada.nombreParada),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            parada.imagen.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image_not_supported)),
            ),
            const SizedBox(height: 20),
            Text(
              parada.tituloParada,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              parada.descripcionParada,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}