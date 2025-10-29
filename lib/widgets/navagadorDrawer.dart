import 'package:bosque_petrificado/screens/menuParadasScreen.dart';
import 'package:flutter/material.dart';

class NavegadorDrawer extends StatelessWidget{
  const NavegadorDrawer({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          //1
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.brown),

            child: Text(
                'text oejasdfasdfmplo',
              style: TextStyle(
                color: Colors.white
              ),

            )
          ),


          //2
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Inicio"),
            onTap: (){
              Navigator.pop(context); //no nos lleva a ningún lado porque ya estamos en home
            },
          ),

          ListTile(
            leading: Icon(Icons.place),
            title: const Text("Parada 1"),
            onTap: (){
              Navigator.pop(context); // cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuParadasScreen())
              );
            },
          )



        ],
      ),
    );
  }

}