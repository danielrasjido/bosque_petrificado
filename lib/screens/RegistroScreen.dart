import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';
import 'package:bosque_petrificado/services/authenthicationService.dart';
import 'package:bosque_petrificado/services/usuariosService.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPassController = TextEditingController();

  bool _cargando = false;
  String? _error;

  bool _mostrarPassword = false;
  bool _mostrarConfirmPassword = false;

  late AuthenticationService _authService;
  late UsuariosService _usuariosService;

  @override
  void initState() {
    super.initState();
    _authService = ServiceLocator().authService;
    _usuariosService = ServiceLocator().usuariosService;
  }

  Future<void> _registrarUsuario() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final pass = _passwordController.text.trim();
    final confPass = _confirmarPassController.text.trim();

    // VALIDAR CONTRASEÑAS IGUALES
    if (pass != confPass) {
      setState(() {
        _cargando = false;
        _error = "Las contraseñas no coinciden";
      });
      return;
    }

    try {
      final account = Account(_authService.client);

      // 1. Crear usuario en Appwrite Auth
      await account.create(
        userId: ID.unique(),
        email: _emailController.text.trim(),
        password: pass,
        name: _nombreController.text.trim(),
      );

      // 2. Crear usuario en base de datos
      await _usuariosService.crearUsuarioEnBD(
        nombre: _nombreController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _telefonoController.text.trim(),
        contrasena: pass,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta creada correctamente")),
      );

      Navigator.pop(context);

    } catch (e) {
      setState(() => _error = "Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear cuenta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: "Nombre completo"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Correo electrónico"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            const SizedBox(height: 12),

            // ✔ Campo contraseña con botón mostrar/ocultar
            TextField(
              controller: _passwordController,
              obscureText: !_mostrarPassword,
              decoration: InputDecoration(
                labelText: "Contraseña",
                suffixIcon: IconButton(
                  icon: Icon(
                    _mostrarPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _mostrarPassword = !_mostrarPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✔ Confirmar contraseña
            TextField(
              controller: _confirmarPassController,
              obscureText: !_mostrarConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirmar contraseña",
                suffixIcon: IconButton(
                  icon: Icon(
                    _mostrarConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _mostrarConfirmPassword = !_mostrarConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),

            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _registrarUsuario,
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
