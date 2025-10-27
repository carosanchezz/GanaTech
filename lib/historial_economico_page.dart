import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class HistorialEconomicoPage extends StatefulWidget {
  const HistorialEconomicoPage({Key? key}) : super(key: key);

  @override
  State<HistorialEconomicoPage> createState() => _HistorialEconomicoPageState();
}

class _HistorialEconomicoPageState extends State<HistorialEconomicoPage> {
  double ingresosTotales = 0;
  double gastosTotales = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchDatos();
  }

  Future<void> fetchDatos() async {
    try {
      final url = Uri.parse("http://192.168.224.1:8000/api/movimientos/");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> movimientos = json.decode(response.body);

        double ingresos = 0;
        double gastos = 0;

        for (var m in movimientos) {
          final tipo = m['tipo']?.toString().toLowerCase() ?? '';
          final monto = double.tryParse(m['monto'].toString()) ?? 0.0;

          if (tipo == 'ingreso') {
            ingresos += monto;
          } else if (tipo == 'gasto') {
            gastos += monto;
          }
        }

        setState(() {
          ingresosTotales = ingresos;
          gastosTotales = gastos;
          cargando = false;
        });
      } else {
        throw Exception("Error al obtener datos (${response.statusCode})");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double total = ingresosTotales + gastosTotales;
    final double porcentajeIngresos =
        total > 0 ? (ingresosTotales / total) * 100 : 0;
    final double porcentajeGastos =
        total > 0 ? (gastosTotales / total) * 100 : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Historial Económico',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildResumenMensual(),
                  const SizedBox(height: 25),
                  _buildGraficoTorta(
                      porcentajeIngresos, porcentajeGastos, total),
                ],
              ),
            ),
    );
  }

  // --- Tarjeta de resumen mensual ---
  Widget _buildResumenMensual() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
          const Text(
            "Resumen mensual",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Divider(thickness: 0.7, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ingresos totales",
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
              Text(
                "\$${ingresosTotales.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Gastos totales",
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
              Text(
                "\$${gastosTotales.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Gráfico de torta ---
  Widget _buildGraficoTorta(
      double porcentajeIngresos, double porcentajeGastos, double total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
        children: [
          const Text(
            "Distribución de ingresos y gastos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 40), // más espacio para que se lea el título
          SizedBox(
            height: 230, // un poco más de altura para dar aire
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 65,
                sections: [
                  PieChartSectionData(
                    color: Colors.green.shade600,
                    value: porcentajeIngresos,
                    title:
                        "${porcentajeIngresos.toStringAsFixed(1)}%\nIngresos",
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.redAccent.shade200,
                    value: porcentajeGastos,
                    title: "${porcentajeGastos.toStringAsFixed(1)}%\nGastos",
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50), // separación mayor con el total
          Text(
            "Total: \$${total.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.circle, color: Colors.green, size: 12),
              SizedBox(width: 4),
              Text("Ingresos", style: TextStyle(fontSize: 12)),
              SizedBox(width: 12),
              Icon(Icons.circle, color: Colors.redAccent, size: 12),
              SizedBox(width: 4),
              Text("Gastos", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
