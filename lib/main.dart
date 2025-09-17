import 'package:flutter/material.dart';
import 'AnimalDetalle_page.dart'; // importa tu pantalla

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // quita la etiqueta "debug"
      title: 'Gestión Ganadera',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AnimalDetailScreen(), // ⬅️ arranca directo a tu página
    );
  }
}
