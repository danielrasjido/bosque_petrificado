import 'package:bosque_petrificado/widgets/navagadorDrawer.dart';
import 'package:bosque_petrificado/widgets/tarjetaBienvenidaWidget.dart';
import 'package:bosque_petrificado/widgets/tarjetaPodometroWidget.dart';

import 'package:flutter/material.dart';

import '../services/usuariosService.dart';
import '../services/PodometroService.dart';

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
      // este es literalmente el id del usuario
      final usuario = await widget.usuarioService.obtenerUsuarioPorId('68f6d5440018f89441ed');

      setState(() {
        nombreUsuario = usuario.nombre;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        nombreUsuario = 'Error al cargar';
        isLoading = false;
      });
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


  //interfaz de la app
  @override
  Widget build(BuildContext context){
    return Scaffold(

        appBar: AppBar(
          title: const Text("Bosque petrificado")
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