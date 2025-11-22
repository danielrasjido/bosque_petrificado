import 'package:bosque_petrificado/widgets/navagadorDrawer.dart';
import 'package:bosque_petrificado/widgets/tarjetaBienvenidaWidget.dart';
import 'package:bosque_petrificado/widgets/tarjetaPodometroWidget.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import '../services/usuariosService.dart';
import '../services/PodometroService.dart';
import '../services/serviceLocator.dart';

import '../screens/loginScreen.dart';

import '../config/appConfig.dart';

class HomeScreen extends StatefulWidget{
  final UsuariosService usuarioService;
  const HomeScreen({super.key, required this.usuarioService});

  State<HomeScreen> createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreen>{
  final PodometroService _podometroService = PodometroService();

  //para cargar datos del usuario
  String nombreUsuario = 'Cargando...';
  bool isLoading = true;

  //para podometro
  int pasos = 0;
  bool podometroInicializado = false;
  bool podometroCargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _configurarListenersPodometro();
    _iniciarPodometro();
  }

  Future<void> _cargarUsuario() async {
    try {
      // Crear cliente temporal para obtener el usuario autenticado
      final client = Client()
        ..setEndpoint(AppConfig.endpoint)
        ..setProject(AppConfig.idProject)
        ..setSelfSigned(status: true);

      final account = Account(client);
      final sesionActiva = await account.get(); // obtiene la sesión actual de Appwrite

      // Buscar datos del usuario autenticado por email en tu colección Usuarios
      final usuario = await widget.usuarioService
          .obtenerUsuarioPorEmail(sesionActiva.email ?? '');

      setState(() {
        if (usuario != null) {
          nombreUsuario = usuario.nombre;
        } else {
          nombreUsuario = 'Usuario no encontrado';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        nombreUsuario = 'Error al cargar';
        isLoading = false;
      });
      print('Error al cargar usuario: $e');
    }
  }

  void _configurarListenersPodometro() {
    _podometroService.onPasosActualizados = (nuevosPasos) {
      print("🔄 Pasos actualizados: $nuevosPasos");
      if (mounted) {
        setState(() {
          pasos = nuevosPasos;
        });
      }
    };
  }

  Future<void> _iniciarPodometro() async {
    try{
      await _podometroService.inicializarPodometro();

      setState(() {
        podometroInicializado = true;
        podometroCargando = false;
      });


    }catch(e){
      setState(() {
        podometroInicializado = false;
        podometroCargando = false;
      });
      print('Error iniciando podómetro: $e');
    }
  }

  void _reiniciarPodometro(){
    _podometroService.reiniciarContador();
    setState(() {
      pasos = 0;
    });
  }

  Future<void> _cerrarSesion() async {
    try {
      final authService = ServiceLocator().authService;

      await authService.logout();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }


  //interfaz de la app
  @override
  Widget build(BuildContext context){
    return Scaffold(

        appBar: AppBar(
          title: const Text("Bosque petrificado"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _cerrarSesion,
            )
          ],
        ),

        drawer: NavegadorDrawer(),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // si isLoading es true, se cargó el usuario correctamente
              TarjetaBienvenidaWidget(
                isLoading: isLoading,
                nombreUsuario: nombreUsuario,
              ),

              const SizedBox(height: 30),

              TarjetaPodometroWidget(
                podometroCargando: podometroCargando,
                podometroInicializado: podometroInicializado,
                pasos: pasos,
                onReiniciar: _reiniciarPodometro,
              ),
            ],
          ),
        ),

      );
  }


}