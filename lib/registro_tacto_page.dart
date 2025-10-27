import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sanidad_reproduccion_page.dart';

class RegistroTactoPage extends StatefulWidget {
  final Map<String, dynamic> animal; // Recibe el animal seleccionado

  const RegistroTactoPage({super.key, required this.animal});

  @override
  State<RegistroTactoPage> createState() => _RegistroTactoPageState();
}

class _RegistroTactoPageState extends State<RegistroTactoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fechaController = TextEditingController(
    text:
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
  );
  final TextEditingController observacionesController = TextEditingController();

  String? prenez;
  String? ovarios;

  final List<String> opcionesPrenez = ['Preñada', 'Vacía', 'En duda'];
  final List<String> opcionesOvarios = ['Sin alteraciones', 'Con alteraciones'];

  // 🔗 Reemplazá con tu IP local (ver con ipconfig)
  final String apiUrl = "http://192.168.224.1:8000/api/tactos/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Tacto',
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
                    'Identificación de animal',
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
                    DateTime? fechaSeleccionada = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (fechaSeleccionada != null) {
                      setState(() {
                        fechaController.text =
                            "${fechaSeleccionada.day.toString().padLeft(2, '0')}/${fechaSeleccionada.month.toString().padLeft(2, '0')}/${fechaSeleccionada.year}";
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Diagnóstico de Preñez',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Preñez*',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      opcionesPrenez
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => prenez = val),
                  validator:
                      (val) => val == null ? 'Seleccione una opción' : null,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Ovarios',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      opcionesOvarios
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => ovarios = val),
                ),

                const SizedBox(height: 25),

                // 🟢 BOTÓN GUARDAR
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await guardarTacto();

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

  Future<bool> guardarTacto() async {
    try {
      // 🔄 Convertimos la fecha al formato que Django espera (YYYY-MM-DD)
      final fechaISO = fechaController.text.split('/').reversed.join('-');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "animal": widget.animal["id"], // 👈 importante que sea ID
          "fecha": fechaISO,
          "prenez": prenez ?? "",
          "observaciones": observacionesController.text,
          "ovarios": ovarios ?? "",
        }),
      );

      print("📤 Enviado: ${response.body}");
      print("📄 Código: ${response.statusCode}");

      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error al enviar datos: $e");
      return false;
    }
  }
}
