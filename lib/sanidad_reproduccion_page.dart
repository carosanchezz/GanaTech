import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AnimalDetalle_page.dart';
import 'agregar_animal_page.dart';
import 'Registros_tactos_tratamientos.dart';

class SanidadScreen extends StatefulWidget {
  @override
  SanidadScreenState createState() => SanidadScreenState();
}

class SanidadScreenState extends State<SanidadScreen> {
  List<Map<String, dynamic>> animales = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchAnimales();
  }

  Future<void> fetchAnimales() async {
    try {
      // ⚠️ Cambiá también por tu IP local
      final response = await http.get(
        Uri.parse("http://192.168.224.1:8000/api/animales/"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          animales = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("Error al cargar animales: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectar con la API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> animalesFiltrados =
        animales.where((animal) {
          final id = animal["id"].toString().toLowerCase();
          final caravana = (animal["caravana"] ?? "").toString().toLowerCase();
          return id.contains(searchQuery.toLowerCase()) ||
              caravana.contains(searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sanidad y Reproducción",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔍 Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por ID o Caravana",
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
                  title: Text("Caravana: ${animal["caravana"] ?? "Sin dato"}"),
                  subtitle: Text(
                    "Sexo: ${animal["sexo"] ?? "-"} · "
                    "Peso: ${animal["peso"] ?? "-"} · "
                    "Estado prod.: ${animal["estado_productivo"] ?? "-"}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                RegistrosTactosTratamientosPage(animal: animal),
                      ),
                    );
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
          final nuevo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarAnimalPage()),
          );
          if (nuevo == true) {
            fetchAnimales(); // refrescamos después de guardar
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
