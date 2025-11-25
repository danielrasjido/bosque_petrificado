import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bosque_petrificado/config/appConfig.dart';

class WidgetAudio extends StatefulWidget {
  final String audioId;
  final String imagenAudioguiaId;

  const WidgetAudio({
    super.key,
    required this.audioId,
    required this.imagenAudioguiaId,
  });

  @override
  State<WidgetAudio> createState() => _WidgetAudioState();
}

class _WidgetAudioState extends State<WidgetAudio> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duracion = Duration.zero;
  Duration _posicion = Duration.zero;

  /// Construye la URL del archivo desde el bucket
  String _buildUrl(String fileId) {
    return "${AppConfig.endpoint}/storage/buckets/${AppConfig.idBucketMultimedia}/files/$fileId/view?project=${AppConfig.idProject}";
  }

  @override
  void initState() {
    super.initState();
    _inicializarAudio();
  }

  Future<void> _inicializarAudio() async {
    try {
      final url = _buildUrl(widget.audioId);

      await _player.setUrl(url);

      // Escuchar duración total
      _player.durationStream.listen((d) {
        setState(() {
          _duracion = d ?? Duration.zero;
        });
      });

      // Escuchar posición actual
      _player.positionStream.listen((p) {
        setState(() {
          _posicion = p;
        });
      });

    } catch (e) {
      print("Error cargando audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = widget.imagenAudioguiaId.isNotEmpty
        ? _buildUrl(widget.imagenAudioguiaId)
        : null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // --------------------------
          // IMAGEN DE LA AUDIOGUÍA
          // --------------------------
          if (imagenUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagenUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 20),
          /*

          // --------------------------
          // SLIDER DE PROGRESO
          // --------------------------
          Slider(
            min: 0,
            max: _duracion.inSeconds.toDouble(),
            value: _posicion.inSeconds.toDouble().clamp(0, _duracion.inSeconds.toDouble()),
            onChanged: (value) {
              final nuevaPos = Duration(seconds: value.toInt());
              _player.seek(nuevaPos);
            },
          ),

          // Tiempos

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_format(_posicion)),
              Text(_format(_duracion)),
            ],
          ),

          const SizedBox(height: 20),
*/
          // --------------------------
          // BOTÓN PLAY / PAUSE
          // --------------------------
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;

              final playing = state?.playing ?? false;

              return ElevatedButton.icon(
                onPressed: () {
                  if (playing) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                },
                icon: Icon(
                  playing ? Icons.pause : Icons.play_arrow,
                  size: 28,
                ),
                label: Text(
                  playing ? "Pausar" : "Reproducir",
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
