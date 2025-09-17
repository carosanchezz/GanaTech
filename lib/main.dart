import 'package:flutter/material.dart';
import 'animales_page.dart';

void main() {
  runApp(GanaderiaApp());
}

class GanaderiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión Ganadera',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AnimalesScreen(),
    );
  }
}
