import 'package:flutter/material.dart';
import 'package:bosque_petrificado/screens/menuParadasScreen.dart';
import 'package:bosque_petrificado/screens/loginScreen.dart';
import 'package:bosque_petrificado/screens/adminParadasScreen.dart';
import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/services/authenthicationService.dart';
import 'package:bosque_petrificado/config/appConfig.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final client = Client()
      ..setEndpoint(AppConfig.endpoint)
      ..setProject(AppConfig.idProject)
      ..setSelfSigned(status: true);
    final databases = Databases(client);
    final authService = AuthenticationService(client, databases);

    await authService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administración"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text("Gestionar Paradas"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminParadasScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
