import 'package:flutter/material.dart';

class AgregarAnimalPage extends StatefulWidget {
  const AgregarAnimalPage({Key? key}) : super(key: key);

  @override
  State<AgregarAnimalPage> createState() => _AgregarAnimalPageState();
}

class _AgregarAnimalPageState extends State<AgregarAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _caravanaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  bool _sinCaravana = false;

  String? _sexoSeleccionado;
  String? _estadoReproductivoSeleccionado;
  String? _estadoProductivoSeleccionado;

  final List<String> _sexos = ['Macho', 'Hembra'];
  final List<String> _estadosReproductivos = [
    'Seleccione',
    'Preñada',
    'Vacía',
    'Lactando',
  ];
  final List<String> _estadosProductivos = [
    'Seleccione',
    'Engorde',
    'Recría',
    'Seca',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Animal',
          style: TextStyle(color: Colors.white), // 👈 título blanco
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(
          color: Colors.white, // 👈 flecha blanca
        ),
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

              // Dropdowns
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
              const SizedBox(height: 32),

              // Botón Guardar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 🚧 Aquí después se conecta con la base de datos 🚧
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Animal listo para guardar (sin DB aún)')),
                    );

                    Navigator.pop(context); // volvemos a AnimalesScreen
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // 👈 texto blanco del botón
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
