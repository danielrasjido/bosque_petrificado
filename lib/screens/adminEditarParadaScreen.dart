import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/paradasService.dart';
import 'package:bosque_petrificado/services/authenthicationService.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';
import 'package:appwrite/appwrite.dart';

class AdminEditarParadaScreen extends StatefulWidget {
  final ParadasDTO parada;

  const AdminEditarParadaScreen({super.key, required this.parada});

  @override
  State<AdminEditarParadaScreen> createState() =>
      _AdminEditarParadaScreenState();
}

class _AdminEditarParadaScreenState extends State<AdminEditarParadaScreen> {
  final _formKey = GlobalKey<FormState>();

  late ParadasService _paradasService;
  late AuthenticationService _authService;
  late Storage _storage;

  bool _cargando = false;

  late TextEditingController _nombreController;
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenController;
  late TextEditingController _audioController;
  late TextEditingController _imagenAudioguiaController;

  @override
  void initState() {
    super.initState();
    _paradasService = ServiceLocator().paradasService;
    _authService = ServiceLocator().authService;

    _storage = Storage(ServiceLocator().client);

    _nombreController =
        TextEditingController(text: widget.parada.nombreParada);
    _tituloController =
        TextEditingController(text: widget.parada.tituloParada);
    _descripcionController =
        TextEditingController(text: widget.parada.descripcionParada);
    _imagenController = TextEditingController(text: widget.parada.imagen);
    _audioController = TextEditingController(text: widget.parada.audio);
    _imagenAudioguiaController =
        TextEditingController(text: widget.parada.imagenAudioguia);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SUBIR ARCHIVO A APPWRITE
  // ─────────────────────────────────────────────────────────────────────────────

  Future<String?> _subirArchivo() async {
    final resultado = await FilePicker.platform.pickFiles();

    if (resultado == null || resultado.files.isEmpty) return null;

    final path = resultado.files.single.path!;
    final fileName = resultado.files.single.name;

    try {
      final respuesta = await _storage.createFile(
        bucketId: AppConfig.idBucketMultimedia,
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: path,
          filename: fileName,
        ),
      );

      return respuesta.$id;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al subir archivo: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GUARDAR CAMBIOS
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final paradaActualizada = widget.parada.copyWith(
        nombreParada: _nombreController.text.trim(),
        tituloParada: _tituloController.text.trim(),
        descripcionParada: _descripcionController.text.trim(),
        imagen: _imagenController.text.trim(),
        audio: _audioController.text.trim(),
        imagenAudioguia: _imagenAudioguiaController.text.trim(),
      );

      await _paradasService.actualizarParada(paradaActualizada);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Parada actualizada correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar parada: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Parada"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Datos básicos",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre (es)"),
                validator: (value) =>
                value!.trim().isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título (es)"),
                validator: (value) =>
                value!.trim().isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descripcionController,
                maxLines: 5,
                decoration:
                const InputDecoration(labelText: "Descripción (es)"),
                validator: (value) =>
                value!.trim().isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 20),

              Text("Multimedia",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              _archivoConBoton(
                label: "Imagen (ID)",
                controller: _imagenController,
              ),

              const SizedBox(height: 12),

              _archivoConBoton(
                label: "Audio (ID)",
                controller: _audioController,
              ),

              const SizedBox(height: 12),

              _archivoConBoton(
                label: "Imagen Audioguía (ID)",
                controller: _imagenAudioguiaController,
              ),

              const SizedBox(height: 20),

              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text("Guardar cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // WIDGET: CAMPO + BOTÓN PARA SUBIR ARCHIVO
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _archivoConBoton({
    required String label,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: "ID del archivo",
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final id = await _subirArchivo();
            if (id != null) {
              controller.text = id;
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: AppConfig.colorPrincipal,
          ),
          child: const Icon(Icons.upload_file),
        ),
      ],
    );
  }
}
