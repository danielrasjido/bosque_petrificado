import 'package:flutter/material.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';
import 'package:bosque_petrificado/screens/paradaScreen.dart';
import 'package:bosque_petrificado/config/appConfig.dart';

class MenuParadasScreen extends StatefulWidget {
  const MenuParadasScreen({super.key});

  @override
  State<MenuParadasScreen> createState() => _MenuParadasScreenState();
}

class _MenuParadasScreenState extends State<MenuParadasScreen> {
  final _paradasService = ServiceLocator().paradasService;

  List<ParadasDTO> _paradas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarParadas();
  }

  Future<void> _cargarParadas() async {
    try {
      final paradas = await _paradasService.listarParadas();
      setState(() {
        _paradas = paradas;
        _cargando = false;
      });
    } catch (e) {
      print('Error al cargar paradas: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  String _buildImageUrl(String fileId) {
    return "${AppConfig.endpoint}/storage/buckets/${AppConfig.idBucketMultimedia}/files/$fileId/view?project=${AppConfig.idProject}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Paradas"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _paradas.isEmpty
          ? const Center(child: Text("No hay paradas disponibles"))
          : ListView.builder(
        itemCount: _paradas.length,
        itemBuilder: (context, index) {
          final parada = _paradas[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParadaScreen(parada: parada),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen real desde Appwrite
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: parada.imagen.isEmpty
                        ? Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Colors.black54,
                        ),
                      ),
                    )
                        : Image.network(
                      _buildImageUrl(parada.imagen),
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 40,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            parada.nombreParada,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            parada.descripcionParada,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
