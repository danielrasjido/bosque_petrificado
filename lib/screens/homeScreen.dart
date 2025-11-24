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

  //para iniciar el recorrido
  bool recorridoActivo = false;
  int pasosInicio = 0;
  int pasosRecorridos = 0;
  DateTime? inicioRecorrido;


  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _configurarListenersPodometro();
    _verificarEstadoRecorrido();
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

          if (recorridoActivo) {
            pasosRecorridos = pasos - pasosInicio;

            // Si llega a 5000, procesar paso se desbloquea una parada
            if (pasosRecorridos >= 5000) {
              _procesarDesbloqueo();
            }

            //esto es para ver si funciona el calculo del recorrido
            if (pasosRecorridos.toInt() >= 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("TEST OK: Llegaste a 10 pasos"),
                  backgroundColor: Colors.blue,
                ),
              );
            }

          }//segundo if


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

  Future<void> _verificarEstadoRecorrido() async {
    final recorridoService = ServiceLocator().recorridoService;

    final inicio = await recorridoService.getInicio();
    final pasos = await recorridoService.getPasosInicio();

    if (inicio != null && pasos != null) {
      setState(() {
        recorridoActivo = true;
        inicioRecorrido = DateTime.fromMillisecondsSinceEpoch(inicio);
        pasosInicio = pasos;
      });
    }
  }

  Future<void> _iniciarRecorrido() async {
    final recorridoService = ServiceLocator().recorridoService;

    // Guardamos los pasos del momento inicial
    await recorridoService.iniciarRecorrido(pasos);

    setState(() {
      recorridoActivo = true;
      pasosInicio = pasos;
      inicioRecorrido = DateTime.now();
    });
  }

    Future<void> _procesarDesbloqueo() async {
      print("desbloquear parada");

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

              if (!recorridoActivo)
                ElevatedButton(
                  onPressed: _iniciarRecorrido,
                  child: const Text("Iniciar recorrido"),
                ),

              if (recorridoActivo)
                Column(
                  children: [
                    Text("Pasos recorridos: $pasosRecorridos",
                        style: const TextStyle(fontSize: 18)),

                    const SizedBox(height: 10),

                    if (inicioRecorrido != null)
                      Text(
                        "Tiempo transcurrido: ${DateTime.now().difference(inicioRecorrido!).inMinutes} min",
                        style: const TextStyle(fontSize: 18),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),

              TarjetaPodometroWidget(
                podometroCargando: podometroCargando,
                podometroInicializado: podometroInicializado,
                pasos: pasos,
                onReiniciar: _reiniciarPodometro,
                minutosRecorrido: recorridoActivo && inicioRecorrido != null
                    ? DateTime.now().difference(inicioRecorrido!).inMinutes
                    : null,
              ),
            ],
          ),
        ),

      );
  }


}