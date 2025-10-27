import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EconomicoScreen extends StatefulWidget {
  const EconomicoScreen({Key? key}) : super(key: key);

  @override
  State<EconomicoScreen> createState() => _EconomicoScreenState();
}

class _EconomicoScreenState extends State<EconomicoScreen> {
  List movimientos = [];
  final String apiUrl = "http://192.168.224.1:8000/api/movimientos/"; // 👈 unificada

  @override
  void initState() {
    super.initState();
    fetchMovimientos();
  }

  Future<void> fetchMovimientos() async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        movimientos = jsonDecode(response.body);
      });
    } else {
      print("❌ Error al cargar movimientos: ${response.statusCode}");
    }
  }

  Future<void> _registrarMovimiento(
      String tipo, String concepto, String monto, String fecha) async {
    final url = Uri.parse(apiUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fecha": fecha, // YYYY-MM-DD
        "tipo": tipo,
        "concepto": concepto,
        "monto": monto,
      }),
    );

    print("🔵 Enviando: ${response.body}");
    if (response.statusCode == 201) {
      fetchMovimientos();
      Navigator.pop(context); // cerrar modal solo si se guardó bien
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Movimiento registrado con éxito")),
      );
    } else {
      print("❌ Error al guardar: ${response.statusCode} ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  }

  void _mostrarFormulario(BuildContext context, String tipo) {
    final conceptoController = TextEditingController();
    final montoController = TextEditingController();
    DateTime fechaSeleccionada = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Registrar $tipo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: conceptoController,
                    decoration: const InputDecoration(labelText: "Concepto"),
                  ),
                  TextField(
                    controller: montoController,
                    decoration: const InputDecoration(labelText: "Monto"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Fecha: "),
                      Text(
                          "${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}"),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? nuevaFecha = await showDatePicker(
                            context: context,
                            initialDate: fechaSeleccionada,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (nuevaFecha != null) {
                            setStateDialog(() {
                              fechaSeleccionada = nuevaFecha;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _registrarMovimiento(
                      tipo,
                      conceptoController.text,
                      montoController.text,
                      "${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}",
                    );
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingresos y Gastos"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white, // 👈 hace que el título y la flecha sean blancos
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // 👈 espacio debajo de la barra verde
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _mostrarFormulario(context, "Ingreso");
                },
                child: const Text("Registrar ingreso"),
              ),
              ElevatedButton(
                onPressed: () {
                  _mostrarFormulario(context, "Gasto");
                },
                child: const Text("Registrar gasto"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final m = movimientos[index];
                return ListTile(
                  leading: Icon(
                    m['tipo'] == 'Ingreso' ? Icons.add : Icons.remove,
                    color: m['tipo'] == 'Ingreso' ? Colors.green : Colors.red,
                  ),
                  title: Text("${m['concepto']} - \$${m['monto']}"),
                  subtitle: Text("${m['fecha']} · ${m['tipo']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
