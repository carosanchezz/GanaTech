import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgregarAnimalPage extends StatefulWidget {
  const AgregarAnimalPage({Key? key}) : super(key: key);

  @override
  State<AgregarAnimalPage> createState() => _AgregarAnimalPageState();
}

class _AgregarAnimalPageState extends State<AgregarAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _caravanaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  DateTime? _fechaSalida; // 🆕 nueva variable

  bool _sinCaravana = false;

  String? _sexoSeleccionado;
  String? _estadoReproductivoSeleccionado;
  String? _estadoProductivoSeleccionado;
  String? _tipoAnimalSeleccionado;

  final List<String> _sexos = ['Macho', 'Hembra'];
  final List<String> _estadosReproductivos = [
    'Seleccione',
    'Preñada',
    'Vacía',
    'Lactando'
  ];
  final List<String> _estadosProductivos = [
    'Seleccione',
    'Engorde',
    'Recría',
    'Seca'
  ];
  final List<String> _tiposAnimal = ['Vaca', 'Ternero', 'Novillo'];

  Future<void> _guardarAnimal() async {
    final url = Uri.parse("http://192.168.224.1:8000/api/animales/");

    final body = {
      "caravana": _sinCaravana ? "" : _caravanaController.text,
      "peso": double.tryParse(_pesoController.text) ?? 0,
      "sexo": _sexoSeleccionado ?? "",
      "estado_reproductivo": _estadoReproductivoSeleccionado ?? "Seleccione",
      "estado_productivo": _estadoProductivoSeleccionado ?? "Seleccione",
      "tipo_animal": _tipoAnimalSeleccionado ?? "Vaca",
      if (_fechaSalida != null)
        // 🟢 CORREGIDO: formato correcto YYYY-MM-DD
        "salida":
            "${_fechaSalida!.year}-${_fechaSalida!.month.toString().padLeft(2, '0')}-${_fechaSalida!.day.toString().padLeft(2, '0')}",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Animal guardado con éxito")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al guardar: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error de conexión: $e")),
      );
    }
  }

  Future<void> _seleccionarFechaSalida() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaSalida) {
      setState(() => _fechaSalida = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Animal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Caravana
              TextFormField(
                controller: _caravanaController,
                decoration: const InputDecoration(labelText: 'Caravana *'),
                validator: (value) {
                  if (!_sinCaravana && (value == null || value.isEmpty)) {
                    return 'Ingrese un número de caravana';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _sinCaravana,
                    onChanged: (value) {
                      setState(() {
                        _sinCaravana = value ?? false;
                        if (_sinCaravana) {
                          _caravanaController.clear();
                        }
                      });
                    },
                  ),
                  const Text("Sin caravana asignada"),
                ],
              ),

              // Campo Peso
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso *'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el peso' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Sexo
              DropdownButtonFormField<String>(
                value: _sexoSeleccionado,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: _sexos
                    .map((sexo) =>
                        DropdownMenuItem(value: sexo, child: Text(sexo)))
                    .toList(),
                onChanged: (value) => setState(() => _sexoSeleccionado = value),
                validator: (value) =>
                    value == null ? 'Seleccione el sexo' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Estado Reproductivo
              DropdownButtonFormField<String>(
                value: _estadoReproductivoSeleccionado,
                decoration:
                    const InputDecoration(labelText: 'Estado reproductivo'),
                items: _estadosReproductivos
                    .map((estado) =>
                        DropdownMenuItem(value: estado, child: Text(estado)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _estadoReproductivoSeleccionado = value),
              ),
              const SizedBox(height: 16),

              // Dropdown Estado Productivo
              DropdownButtonFormField<String>(
                value: _estadoProductivoSeleccionado,
                decoration:
                    const InputDecoration(labelText: 'Estado productivo'),
                items: _estadosProductivos
                    .map((estado) =>
                        DropdownMenuItem(value: estado, child: Text(estado)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _estadoProductivoSeleccionado = value),
              ),
              const SizedBox(height: 16),

              // Dropdown Tipo Animal
              DropdownButtonFormField<String>(
                value: _tipoAnimalSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Animal'),
                items: _tiposAnimal
                    .map((tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _tipoAnimalSeleccionado = value),
                validator: (value) =>
                    value == null ? 'Seleccione el tipo de animal' : null,
              ),
              const SizedBox(height: 16),

              // 🆕 Campo Fecha de salida (opcional)
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de salida (opcional)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _seleccionarFechaSalida,
                  ),
                ),
                controller: TextEditingController(
                  text: _fechaSalida == null
                      ? ''
                      : "${_fechaSalida!.day}/${_fechaSalida!.month}/${_fechaSalida!.year}",
                ),
              ),
              const SizedBox(height: 32),

              // Botón Guardar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarAnimal();
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
