import 'package:flutter/material.dart';
import 'package:bosque_petrificado/config/appConfig.dart';

class BienvenidaScreen extends StatelessWidget{
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                ],
              ),
            ),
          )
      ),
    );
  }

}