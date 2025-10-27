import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  List<dynamic> tratamientos = [];

  @override
  void initState() {
    super.initState();
    fetchTratamientos();
  }

  Future<void> fetchTratamientos() async {
    try {
      final url = Uri.parse("http://192.168.224.1:8000/api/tratamientos/");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tratamientos = data
              .where((t) => t['animal'] == widget.animal['id'])
              .toList();
        });
      }
    } catch (e) {
      print("Error al obtener tratamientos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalle del Animal",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Identificación
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.pets, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Identificación",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Caravana: ${widget.animal["caravana"] ?? "Sin dato"}"),
                          Text("Sexo: ${widget.animal["sexo"] ?? "-"}"),
                          Text("Peso: ${widget.animal["peso"] ?? "-"} kg"),
                          Text("Estado reproductivo: ${widget.animal["estado_reproductivo"] ?? "-"}"),
                          Text("Estado productivo: ${widget.animal["estado_productivo"] ?? "-"}"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Editar"),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Historial Sanitario
                const Text(
                  "Historial Sanitario",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // Tratamientos activos
                if (tratamientos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const Text(
                    "🩺 En tratamiento:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  for (var t in tratamientos)
                    Text("${t['fecha']} - ${t['condicion']}"),
                ],

                const SizedBox(height: 24),

                // Movimientos
                const Text(
                  "Movimientos",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DataTable(
                  columns: const [
                    DataColumn(label: Text("Fecha")),
                    DataColumn(label: Text("Tipo")),
                    DataColumn(label: Text("Origen")),
                    DataColumn(label: Text("Destino")),
                  ],
                  rows: [
                    if (widget.animal['salida'] != null)
                      DataRow(cells: [
                        DataCell(Text(widget.animal['salida'])),
                        const DataCell(Text("Salida")),
                        const DataCell(Text("Venta")),
                        const DataCell(Text("Destino")),
                      ]),
                    DataRow(cells: [
                      DataCell(Text(widget.animal['fecha_registro']
                              ?.toString()
                              .substring(0, 10) ??
                          "")),
                      const DataCell(Text("Ingreso")),
                      const DataCell(Text("Compra")),
                      const DataCell(Text("Origen")),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
