import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/services/authenthicationService.dart';
import 'package:bosque_petrificado/models/UsuariosDTO.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/screens/homeScreen.dart';
import 'package:bosque_petrificado/screens/adminHomeScreen.dart'; //

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _cargando = false;
  String? _error;

  late AuthenticationService _authService;

  @override
  void initState() {
    super.initState();
    final client = Client()
      ..setEndpoint(AppConfig.endpoint)
      ..setProject(AppConfig.idProject)
      ..setSelfSigned(status: true);
    final databases = Databases(client);
    _authService = AuthenticationService(client, databases);
  }

  Future<void> _iniciarSesion() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final usuario = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (usuario == null) {
        setState(() {
          _error = 'Usuario no encontrado';
        });
      } else {
        if (mounted) {
          // Si es admin -> redirigir a la pantalla de administración
          if (usuario.esAdmin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(usuarioService: _authService.usuariosService)),
            );
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _iniciarSesion,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
