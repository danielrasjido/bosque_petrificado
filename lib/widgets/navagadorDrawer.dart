import 'package:flutter/material.dart';
import 'package:bosque_petrificado/services/serviceLocator.dart';
import 'package:bosque_petrificado/screens/loginScreen.dart';
import 'package:bosque_petrificado/screens/menuParadasScreen.dart';

class NavegadorDrawer extends StatelessWidget {
  const NavegadorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = ServiceLocator().authService;

    return Drawer(
      child: Builder(
        builder: (drawerContext) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.brown),
                child: Text(
                  'Menú de la aplicacion',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Inicio"),
                onTap: () {
                  Navigator.pop(drawerContext);
                },
              ),

              ListTile(
                leading: const Icon(Icons.place),
                title: const Text("Paradas"),
                onTap: () {
                  Navigator.pop(drawerContext);
                  Navigator.push(
                    drawerContext,
                    MaterialPageRoute(builder: (_) => const MenuParadasScreen()),
                  );
                },
              ),

              const Divider(),


            ],
          );
        },
      ),
    );
  }
}
