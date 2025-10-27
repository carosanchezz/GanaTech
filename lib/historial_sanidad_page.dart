import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detalle_sanidad_animal_page.dart';

class HistorialSanidadPage extends StatefulWidget {
  const HistorialSanidadPage({Key? key}) : super(key: key);

  @override
  State<HistorialSanidadPage> createState() => _HistorialSanidadPageState();
}

class _HistorialSanidadPageState extends State<HistorialSanidadPage> {
  List<dynamic> animales = [];
  List<dynamic> filtrados = [];
  bool cargando = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAnimales();
  }

  Future<void> fetchAnimales() async {
    try {
      final url = Uri.parse("http://192.168.224.1:8000/api/animales/");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          animales = data;
          filtrados = data;
          cargando = false;
        });
      } else {
        throw Exception("Error al obtener los animales");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => cargando = false);
    }
  }

  void filtrarAnimales(String query) {
    final resultados = animales.where((a) {
      final id = a['id'].toString();
      final caravana = a['caravana']?.toString().toLowerCase() ?? '';
      return id.contains(query) || caravana.contains(query.toLowerCase());
    }).toList();

    setState(() => filtrados = resultados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          "Animales",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por ID o Caravana',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: filtrarAnimales,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final animal = filtrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.pets, color: Color(0xFF2E7D32), size: 30),
                          title: Text(
                            "Caravana: ${animal['caravana'] ?? 'Sin dato'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleAnimalPage(animal: animal),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
