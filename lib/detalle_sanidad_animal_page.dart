import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalleAnimalPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const DetalleAnimalPage({Key? key, required this.animal}) : super(key: key);

  @override
  State<DetalleAnimalPage> createState() => _DetalleAnimalPageState();
}

class _DetalleAnimalPageState extends State<DetalleAnimalPage> {
  List<dynamic> tactos = [];
  List<dynamic> tratamientos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchDetalles();
  }

  Future<void> fetchDetalles() async {
    try {
      final tactosUrl = Uri.parse("http://192.168.224.1:8000/api/tactos/");
      final tratUrl = Uri.parse("http://192.168.224.1:8000/api/tratamientos/");

      final responses = await Future.wait([http.get(tactosUrl), http.get(tratUrl)]);
      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final todosTactos = json.decode(responses[0].body) as List;
        final todosTrat = json.decode(responses[1].body) as List;

        setState(() {
          tactos = todosTactos.where((t) => t['animal'] == widget.animal['id']).toList();
          tratamientos = todosTrat.where((t) => t['animal'] == widget.animal['id']).toList();
          cargando = false;
        });
      } else {
        throw Exception("Error en la conexión");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          "Caravana: ${widget.animal['caravana'] ?? ''}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard("Tactos", tactos, _buildTactoItem),
                const SizedBox(height: 20),
                _buildCard("Tratamientos", tratamientos, _buildTratItem),
              ],
            ),
    );
  }

  Widget _buildCard(String titulo, List<dynamic> datos, Widget Function(dynamic) itemBuilder) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          datos.isEmpty
              ? const Text("No se han registrado",
                  style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic))
              : Column(children: datos.map(itemBuilder).toList()),
        ],
      ),
    );
  }

  Widget _buildTactoItem(dynamic tacto) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${tacto['fecha']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Prenez: ${tacto['prenez']}"),
            Text("Ovarios: ${tacto['ovarios']}"),
            Text("Observaciones: ${tacto['observaciones'] ?? '-'}"),
          ],
        ),
      ),
    );
  }

  Widget _buildTratItem(dynamic trat) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${trat['fecha']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Condición: ${trat['condicion']}"),
            Text("Medicación: ${trat['medicacion']}"),
            Text("Dosis: ${trat['dosis']}"),
            Text("Realizado por: ${trat['realizado_por']}"),
            Text("Observaciones: ${trat['observaciones'] ?? '-'}"),
          ],
        ),
      ),
    );
  }
}
