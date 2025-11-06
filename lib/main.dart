import 'package:flutter/material.dart';
import 'services/usuariosService.dart';
import 'package:appwrite/appwrite.dart';
import 'services/appWriteService.dart';
import 'services/authenthicationService.dart';
import 'config/appConfig.dart';
import 'config/bosquePetrificadoTheme.dart';
import 'screens/homeScreen.dart';
import 'screens/loginScreen.dart';
import 'screens/homeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appwriteService = AppwriteService();
  appwriteService.init();


  final usuarioService = UsuariosService(databases: appwriteService.databases);

  runApp(MyApp(usuarioService: usuarioService));
}

class MyApp extends StatefulWidget{
  final UsuariosService usuarioService;
  const MyApp({super.key, required this.usuarioService});

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  bool _verificandoSesion = true;
  bool _haySesion = false;
  late AuthenticationService _authService;

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final client = Client()
      ..setEndpoint(AppConfig.endpoint)
      ..setProject(AppConfig.idProject)
      ..setSelfSigned(status: true);

    final databases = Databases(client);
    _authService = AuthenticationService(client, databases);

    final usuario = await _authService.obtenerUsuarioActual();

    setState(() {
      _haySesion = usuario != null;
      _verificandoSesion = false;
    });
  }


  //interfaz de la app
  @override
  Widget build(BuildContext context){

    if (_verificandoSesion) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: BosquePetrificadoTheme.lightTheme,

      home: _haySesion
          ? HomeScreen(usuarioService: widget.usuarioService)
          : const LoginScreen(),

    );
  }


}