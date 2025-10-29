import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/paradasService.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/screens/paradaScreen.dart';

class MenuParadasScreen extends StatefulWidget {
  const MenuParadasScreen({super.key});

  @override
  State<MenuParadasScreen> createState() => _MenuParadasScreenState();
}

class _MenuParadasScreenState extends State<MenuParadasScreen> {
  late ParadasService _paradasService;
  late Databases _databases;
  List<ParadasDTO> _paradas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _inicializarService();
  }

  void _inicializarService() async {
    // Configurar Appwrite Client
    final client = Client()
      ..setEndpoint(AppConfig.endpoint)
      ..setProject(AppConfig.idProject)
      ..setSelfSigned(status: true);

    _databases = Databases(client);
    _paradasService = ParadasService(databases: _databases);

    await _cargarParadas();
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
                    builder: (context) =>
                        ParadaScreen(parada: parada),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  //Textos dentro de Expanded para que no se desborde
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: const TextStyle(color: Colors.black87),
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
