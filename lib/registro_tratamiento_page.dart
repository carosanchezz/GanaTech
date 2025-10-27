import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sanidad_reproduccion_page.dart';

class RegistroTratamientoPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const RegistroTratamientoPage({super.key, required this.animal});

  @override
  State<RegistroTratamientoPage> createState() =>
      _RegistroTratamientoPageState();
}

class _RegistroTratamientoPageState extends State<RegistroTratamientoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fechaController = TextEditingController(
    text:
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
  );
  final TextEditingController dosisController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController realizadoPorController = TextEditingController();

  String? condicionSeleccionada;
  String? medicacionSeleccionada;

  final List<String> condiciones = [
    'Herida',
    'Infección',
    'Fiebre',
    'Parásitos',
  ];
  final List<String> medicaciones = [
    'Antibiótico',
    'Vacuna',
    'Vitaminas',
    'Antiparasitario',
  ];

  // 🔗 Reemplazá con tu IP real
  final String apiUrl = "http://192.168.224.1:8000/api/tratamientos/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Tratamiento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Identificación de Animal',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // 📅 FECHA
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha*',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? nuevaFecha = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (nuevaFecha != null) {
                      setState(() {
                        fechaController.text =
                            "${nuevaFecha.day.toString().padLeft(2, '0')}/${nuevaFecha.month.toString().padLeft(2, '0')}/${nuevaFecha.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 25),

                const Center(
                  child: Text(
                    'Datos del Tratamiento',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Condición*',
                    border: OutlineInputBorder(),
                  ),
                  value: condicionSeleccionada,
                  items:
                      condiciones
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged:
                      (val) => setState(() => condicionSeleccionada = val),
                  validator:
                      (val) => val == null ? 'Seleccione una condición' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Medicación*',
                    border: OutlineInputBorder(),
                  ),
                  value: medicacionSeleccionada,
                  items:
                      medicaciones
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                  onChanged:
                      (val) => setState(() => medicacionSeleccionada = val),
                  validator:
                      (val) => val == null ? 'Seleccione una medicación' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: dosisController,
                  decoration: const InputDecoration(
                    labelText: 'Dosis (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: realizadoPorController,
                  decoration: const InputDecoration(
                    labelText: 'Realizado por (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await guardarTratamiento();

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Datos guardados correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // 🔁 Espera un momento para mostrar el mensaje y luego redirige
                          await Future.delayed(const Duration(seconds: 1));

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SanidadScreen(),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error al guardar en la base de datos',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },

                    child: const Text(
                      'GUARDAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> guardarTratamiento() async {
    try {
      final fechaISO = fechaController.text.split('/').reversed.join('-');

      final body = {
        "animal": widget.animal["id"],
        "fecha": fechaISO,
        "condicion": condicionSeleccionada ?? "",
        "medicacion": medicacionSeleccionada ?? "",
        "dosis": dosisController.text,
        "observaciones": observacionesController.text,
        "realizado_por": realizadoPorController.text,
      };

      print("📤 Enviando: $body");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("📄 Código: ${response.statusCode}");
      print("📥 Respuesta: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error al enviar datos: $e");
      return false;
    }
  }
}
