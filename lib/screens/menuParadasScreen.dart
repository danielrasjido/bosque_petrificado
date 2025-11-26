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
  final _desbloqueaService = ServiceLocator().desbloqueaService;
  final _authService = ServiceLocator().authService;

  List<ParadasDTO> _paradas = [];
  List<String> _paradasDesbloqueadas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final usuario = await _authService.obtenerUsuarioActual();
      if (usuario == null) {
        print("No se encontró usuario logueado");
        return;
      }

      final desbloqueos =
      await _desbloqueaService.listarParadasDesbloqueadas(usuario.id);

      _paradasDesbloqueadas =
          desbloqueos.map((d) => d.paradaId).toList();

      final paradas = await _paradasService.listarParadasOrdenadas();

      setState(() {
        _paradas = paradas;
        _cargando = false;
      });
    } catch (e) {
      print("Error cargando datos: $e");
      setState(() => _cargando = false);
    }
  }

  String _buildImageUrl(String fileId) {
    return "${AppConfig.endpoint}/storage/buckets/${AppConfig.idBucketMultimedia}/files/$fileId/view?project=${AppConfig.idProject}";
  }

  void _mostrarBloqueado() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Parada bloqueada",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Paradas"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _paradas.length,
        itemBuilder: (context, index) {
          final parada = _paradas[index];
          final desbloqueada =
          _paradasDesbloqueadas.contains(parada.id);

          return GestureDetector(
            onTap: () {
              if (desbloqueada) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParadaScreen(parada: parada),
                  ),
                );
              } else {
                _mostrarBloqueado();
              }
            },

            child: Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------------
                  // Imagen con candado
                  // --------------------------
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: parada.imagen.isNotEmpty
                        ? Stack(
                      children: [
                        Opacity(
                          opacity: desbloqueada ? 1.0 : 0.4,
                          child: Image.network(
                            _buildImageUrl(parada.imagen),
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!desbloqueada)
                          const Center(
                            child: Icon(
                              Icons.lock,
                              size: 40,
                              color: Colors.black87,
                            ),
                          ),
                      ],
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_outlined),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // --------------------------
                  // Textos
                  // --------------------------
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            parada.nombreParada,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: desbloqueada
                                  ? Colors.black
                                  : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            parada.descripcionParada,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: desbloqueada
                                  ? Colors.black87
                                  : Colors.black45,
                            ),
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
