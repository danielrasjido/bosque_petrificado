import 'package:flutter/material.dart';
import 'services/usuariosService.dart';
import 'services/appWriteService.dart';
import 'config/appConfig.dart';
import 'config/bosquePetrificadoTheme.dart';


import 'screens/homeScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appwriteService = AppwriteService();
  appwriteService.init();


  final usuarioService = UsuarioService(databases: appwriteService.databases);

  runApp(MyApp(usuarioService: usuarioService));
}

class MyApp extends StatefulWidget{
  final UsuarioService usuarioService;
  const MyApp({super.key, required this.usuarioService});

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{


  //interfaz de la app
  @override
  Widget build(BuildContext context){
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: BosquePetrificadoTheme.lightTheme,

      home: HomeScreen(usuarioService: widget.usuarioService),

    );
  }


}