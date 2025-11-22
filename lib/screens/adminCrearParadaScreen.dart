import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:appwrite/appwrite.dart';

import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';
import 'package:bosque_petrificado/services/paradasService.dart';

class AdminCrearParadaScreen extends StatefulWidget {
  const AdminCrearParadaScreen({super.key});

  @override
  State<AdminCrearParadaScreen> createState() => _AdminCrearParadaScreenState();
}

class _AdminCrearParadaScreenState extends State<AdminCrearParadaScreen> {
  final _formKey = GlobalKey<FormState>();

  late ParadasService _paradasService;
  late Storage _storage;

  bool _cargando = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _audioController = TextEditingController();
  final TextEditingController _imagenAudioguiaController = TextEditingController();
  final TextEditingController _ordenController = TextEditingController();


  @override
  void initState() {
    super.initState();

    _paradasService = ServiceLocator().paradasService;
    _storage = Storage(ServiceLocator().client);
  }

  // ─────────────────────────────────────────────────────────────
  // SUBIR ARCHIVO A APPWRITE
  // ─────────────────────────────────────────────────────────────
  Future<String?> _subirArchivo() async {
    final resultado = await FilePicker.platform.pickFiles();

    if (resultado == null || resultado.files.isEmpty) return null;

    final path = resultado.files.single.path!;
    final filename = resultado.files.single.name;

    try {
      final respuesta = await _storage.createFile(
        bucketId: AppConfig.idBucketMultimedia,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: path, filename: filename),
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

  
  Future<void> _crearParada() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final nuevaParada = ParadasDTO(
        id: "", // Appwrite lo ignorará porque usaremos ID.unique()
        nombreParada: _nombreController.text.trim(),
        tituloParada: _tituloController.text.trim(),
        descripcionParada: _descripcionController.text.trim(),
        imagen: _imagenController.text.trim(),
        audio: _audioController.text.trim(),
        imagenAudioguia: _imagenAudioguiaController.text.trim(),
        orden: int.parse(_ordenController.text.trim()),
      );

      await _paradasService.crearParada(nuevaParada);

      if (!mounted) return;

      //para limpiar los campos
      _nombreController.clear();
      _tituloController.clear();
      _descripcionController.clear();
      _imagenController.clear();
      _audioController.clear();
      _imagenAudioguiaController.clear();
      _ordenController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Parada creada correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al crear la parada: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // CAMPOS DE ARCHIVO
  // ─────────────────────────────────────────────────────────────
  Widget _campoArchivo({
    required String label,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              hintText: "Archivo seleccionado",
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final idArchivo = await _subirArchivo();
            if (idArchivo != null) controller.text = idArchivo;
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(14),
            backgroundColor: AppConfig.colorPrincipal,
          ),
          child: const Icon(Icons.upload_file),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Parada"),
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
                decoration: const InputDecoration(labelText: "Descripción (es)"),
                validator: (value) =>
                value!.trim().isEmpty ? "Campo obligatorio" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _ordenController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Orden de la parada (1–10)"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Campo obligatorio";
                  }

                  final n = int.tryParse(value);
                  if (n == null || n <= 0) {
                    return "Debe ser un número entero mayor a 0";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              Text("Multimedia",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              _campoArchivo(
                label: "Imagen",
                controller: _imagenController,
              ),
              const SizedBox(height: 12),

              _campoArchivo(
                label: "Audio",
                controller: _audioController,
              ),
              const SizedBox(height: 12),

              _campoArchivo(
                label: "Imagen Audioguía",
                controller: _imagenAudioguiaController,
              ),

              const SizedBox(height: 24),

              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _crearParada,
                child: const Text("Crear parada"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
