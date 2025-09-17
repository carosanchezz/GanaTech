import 'package:flutter/material.dart';
import 'agregar_animal_page.dart'; // importamos la pantalla de agregar animal

class AnimalesScreen extends StatefulWidget {
  @override
  _AnimalesScreenState createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  // Lista dinámica de animales
  List<Map<String, String>> animales = [];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> animalesFiltrados = animales.where((animal) {
      return animal["id"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          animal["lote"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          animal["raza"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Animales",
          style: TextStyle(color: Colors.white), // 👈 acá el color blanco
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white), // 👈 flecha blanca
      ),
      body: Column(
        children: [
          // 🔍 Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 📋 Lista dinámica
          Expanded(
            child: ListView.builder(
              itemCount: animalesFiltrados.length,
              itemBuilder: (context, index) {
                final animal = animalesFiltrados[index];
                return ListTile(
                  leading: const Icon(Icons.pets, color: Colors.green),
                  title: Text(animal["id"]!),
                  subtitle: Text(
                    "${animal["tipo"]} · ${animal["raza"]} · "
                    "Peso ${animal["peso"]} · Lote ${animal["lote"]}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // más adelante conectamos con Detalle
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Botón para agregar nuevo animal
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarAnimalPage()),
          );
          setState(() {}); // refresca la lista cuando vuelve
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
