import 'package:flutter/material.dart';

class AnimalesScreen extends StatefulWidget {
  @override
  _AnimalesScreenState createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  // Lista dinámica de animales
  List<Map<String, String>> animales = [
    
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filtramos la lista según lo que se escriba en el buscador
    List<Map<String, String>> animalesFiltrados = animales.where((animal) {
      return animal["id"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             animal["lote"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             animal["raza"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Animales"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // 🔍 Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por ID",
                prefixIcon: Icon(Icons.search),
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
                  leading: Icon(Icons.pets, color: Colors.green),
                  title: Text(animal["id"]!),
                  subtitle: Text(
                    "${animal["tipo"]} · ${animal["raza"]} · "
                    "Peso ${animal["peso"]} · Lote ${animal["lote"]}",
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Más adelante mostramos el detalle del animal
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Botón para agregar nuevo animal
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Más adelante lo conectamos con la pantalla de "Agregar Animal"
        },
        backgroundColor: Colors.green[700],
        child: Icon(Icons.add),
      ),
    );
  }
}
