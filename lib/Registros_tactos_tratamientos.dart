import 'package:flutter/material.dart';
import 'registro_tacto_page.dart';
import 'registro_tratamiento_page.dart';

class RegistrosTactosTratamientosPage extends StatelessWidget {
  final Map<String, dynamic> animal; // 🐮 Recibe el animal desde la lista

  const RegistrosTactosTratamientosPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sanidad y Reproducción',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🟢 Botón Registrar Tacto
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistroTactoPage(animal: animal), // ✅ acá se pasa
                    ),
                  );
                },
                child: const Text(
                  '+ Registrar tacto',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🟢 Botón Registrar Tratamiento
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistroTratamientoPage(animal: animal), // ✅ y acá también
                    ),
                  );
                },
                child: const Text(
                  '+ Registrar tratamiento',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
