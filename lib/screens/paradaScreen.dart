import 'package:flutter/material.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/widgets/widgetAudio.dart';

class ParadaScreen extends StatelessWidget {
  final ParadasDTO parada;

  const ParadaScreen({super.key, required this.parada});

  String _buildImageUrl(String fileId) {
    return "${AppConfig.endpoint}/storage/buckets/${AppConfig.idBucketMultimedia}/files/$fileId/view?project=${AppConfig.idProject}";
  }

  void _abrirAudio(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return WidgetAudio(
          audioId: parada.audio,
          imagenAudioguiaId: parada.imagenAudioguia,
        );
      },
    );
  }

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
            //   IMAGEN REAL DE LA PARADA
            parada.imagen.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _buildImageUrl(parada.imagen),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) {
                  return Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 80,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            )
                : Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 80,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //  BOTÓN PARA ESCUCHAR AUDIO
            if (parada.audio.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirAudio(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Escuchar audio"),

                ),
              ),

            const SizedBox(height: 20),


            //   TÍTULO DE LA PARADA

            Text(
              parada.tituloParada,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),


            //   DESCRIPCIÓN

            Text(
              parada.descripcionParada,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
