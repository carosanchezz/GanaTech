import 'package:flutter/material.dart';
import '1_Inicio.dart'; // asegúrate que aquí está MenuPage

void main() {
  runApp(const GestionGanaderaApp());
}

class GestionGanaderaApp extends StatelessWidget {
  const GestionGanaderaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Ganadera',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      // Pantalla inicial
      home: const MenuPage(), // cambiamos HomePage por MenuPage
    );
  }
}