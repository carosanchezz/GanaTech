import 'package:flutter/material.dart';

class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Animal"),
        backgroundColor: Colors.green[700],
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
                // Identificación con logo de vaca
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
                        children: const [
                          Text(
                            "Identificación",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("ID Caravana: H1025a"),
                          Text("Sexo: Hembra"),
                          Text("Raza: Hereford"),
                          Text("Fecha nacimiento: 15/03/2021"),
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

                // Historial Sanitario y Reproducción
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Historial Sanitario",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("10/03/2024 - Carbunclo"),
                          Text("20/09/2023 - Aftosa"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Reproducción",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Último parto: 03/08/2022"),
                          Text("Estado: Seca"),
                        ],
                      ),
                    ),
                  ],
                ),
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
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text("28/02/2024")),
                        DataCell(Text("Salida")),
                        DataCell(Text("Venta")),
                        DataCell(Text("Venta")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("17/07/2023")),
                        DataCell(Text("Ingreso")),
                        DataCell(Text("Compra")),
                        DataCell(Text("Compra")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("02/04/2023")),
                        DataCell(Text("Ingreso")),
                        DataCell(Text("Nacimiento")),
                        DataCell(Text("—")),
                      ],
                    ),
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
