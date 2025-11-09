import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/models/ParadasDTO.dart';
import 'package:bosque_petrificado/services/paradasService.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/screens/adminCrearParadaScreen.dart';
import 'package:bosque_petrificado/screens/adminEditarParadaScreen.dart';

class AdminParadasScreen extends StatefulWidget {
  const AdminParadasScreen({super.key});

  @override
  State<AdminParadasScreen> createState() => _AdminParadasScreenState();
}

class _AdminParadasScreenState extends State<AdminParadasScreen> {
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
      setState(() => _cargando = false);
    }
  }

  Future<void> _eliminarParada(ParadasDTO parada) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text(
            "¿Estás seguro de que deseas eliminar la parada '${parada.nombreParada}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Borrar"),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Operación cancelada"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    try {
      await _paradasService.eliminarParada(parada.id);
      setState(() {
        _paradas.removeWhere((p) => p.id == parada.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Parada eliminada exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al eliminar la parada: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrar Paradas"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _cargarParadas,
        child: ListView.builder(
          itemCount: _paradas.length + 1,
          itemBuilder: (context, index) {
            // Botón "Crear parada"
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const AdminCrearParadaScreen()),
                    ).then((_) => _cargarParadas());
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppConfig.colorSecundario,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConfig.colorPrincipal,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Crear Parada",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            final parada = _paradas[index - 1];

            return Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConfig.colorSecundario, // para que las tarjetas tengan el color de fondo principal
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConfig.colorPrincipal,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder de imagen
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

                    // Info de la parada
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
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
                              style: const TextStyle(
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 10),

                            // Botones Editar  Eliminar
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminEditarParadaScreen(
                                                parada: parada),
                                      ),
                                    ).then((_) => _cargarParadas());
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Editar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _eliminarParada(parada),
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Eliminar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
