import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class StockAnimalesPage extends StatefulWidget {
  const StockAnimalesPage({Key? key}) : super(key: key);

  @override
  State<StockAnimalesPage> createState() => _StockAnimalesPageState();
}

class _StockAnimalesPageState extends State<StockAnimalesPage> {
  Map<String, dynamic>? data;
  List<FlSpot> stockLineData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final animalesUrl = Uri.parse("http://192.168.224.1:8000/api/animales/");
      final tactosUrl = Uri.parse("http://192.168.224.1:8000/api/tactos/");

      final responses = await Future.wait([
        http.get(animalesUrl),
        http.get(tactosUrl),
      ]);

      final animalesResponse = responses[0];
      final tactosResponse = responses[1];

      if (animalesResponse.statusCode == 200 &&
          tactosResponse.statusCode == 200) {
        final List<dynamic> animales = json.decode(animalesResponse.body);
        final List<dynamic> tactos = json.decode(tactosResponse.body);

        // --- Clasificación por tipo ---
        // Solo animales activos (sin fecha de salida)
        final activos =
            animales
                .where(
                  (a) => a['salida'] == null || a['salida'].toString().isEmpty,
                )
                .toList();

        final total = activos.length;

        // Clasificación por tipo, solo activos
        final vacas =
            activos
                .where(
                  (a) => a['tipo_animal']?.toString().toLowerCase() == 'vaca',
                )
                .length;
        final terneros =
            activos
                .where(
                  (a) =>
                      a['tipo_animal']?.toString().toLowerCase() == 'ternero',
                )
                .length;
        final novillos =
            activos
                .where(
                  (a) =>
                      a['tipo_animal']?.toString().toLowerCase() == 'novillo',
                )
                .length;

        // --- Tactos ---
        final tactadas = tactos.length;
        final noTactadas = vacas - tactadas < 0 ? 0 : vacas - tactadas;

        // --- Stock por mes (según fecha_registro) ---
        final Map<String, int> conteoPorMes = {};
        for (var a in animales) {
          if (a['fecha_registro'] != null) {
            final fecha = DateTime.parse(a['fecha_registro']);
            final claveMes =
                "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}";
            conteoPorMes[claveMes] = (conteoPorMes[claveMes] ?? 0) + 1;
          }
        }

        // Ordenar por mes
        final sortedKeys = conteoPorMes.keys.toList()..sort();
        int i = 0;
        stockLineData =
            sortedKeys.map((k) {
              i++;
              return FlSpot(i.toDouble(), conteoPorMes[k]!.toDouble());
            }).toList();

        // --- Ingresos y salidas por mes ---
        final Map<String, int> ingresosPorMes = {};
        final Map<String, int> salidasPorMes = {};

        for (var a in animales) {
          // Ingreso
          if (a['fecha_registro'] != null) {
            final fecha = DateTime.parse(a['fecha_registro']);
            final claveMes =
                "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}";
            ingresosPorMes[claveMes] = (ingresosPorMes[claveMes] ?? 0) + 1;
          }

          // Salida
          if (a['salida'] != null && a['salida'].toString().isNotEmpty) {
            final fechaSalida = DateTime.parse(a['salida']);
            final claveMesSalida =
                "${fechaSalida.year}-${fechaSalida.month.toString().padLeft(2, '0')}";
            salidasPorMes[claveMesSalida] =
                (salidasPorMes[claveMesSalida] ?? 0) + 1;
          }
        }

        setState(() {
          data = {
            "total": total,
            "vacas": vacas,
            "terneros": terneros,
            "novillos": novillos,
            "tactadas": tactadas,
            "no_tactadas": noTactadas,
            "meses": sortedKeys,
            "ingresosPorMes": ingresosPorMes,
            "salidasPorMes": salidasPorMes,
          };
        });
      } else {
        print(
          "Error HTTP: ${animalesResponse.statusCode}, ${tactosResponse.statusCode}",
        );
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Stock de Animales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body:
          data == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildResumen(),
                    const SizedBox(height: 20),
                    _buildGraficos(),
                    const SizedBox(height: 20),
                    _buildTabla(),
                  ],
                ),
              ),
    );
  }

  Widget _buildResumen() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen General",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "${data!['total']}",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Total"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vacas: ${data!['vacas']}"),
                    Text("Terneros/as: ${data!['terneros']}"),
                    Text("Novillos/as: ${data!['novillos']}"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildStockChart()),
        const SizedBox(width: 10),
        Expanded(child: _buildIngresosSalidasChart()),
      ],
    );
  }

  Widget _buildStockChart() {
    if (stockLineData.isEmpty) {
      return _buildChartPlaceholder("Sin datos de Stock");
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            "Stock de Animales",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.white,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: stockLineData,
                    isCurved: true,
                    color: const Color(0xFF2E7D32),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2E7D32).withOpacity(0.15),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget:
                          (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt() - 1;
                        if (data!['meses'] == null ||
                            index < 0 ||
                            index >= data!['meses'].length) {
                          return const SizedBox.shrink();
                        }
                        final mesNum = data!['meses'][index].split('-')[1];
                        const meses = [
                          "Ene",
                          "Feb",
                          "Mar",
                          "Abr",
                          "May",
                          "Jun",
                          "Jul",
                          "Ago",
                          "Sep",
                          "Oct",
                          "Nov",
                          "Dic",
                        ];
                        final mesLabel = meses[int.parse(mesNum) - 1];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            mesLabel,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngresosSalidasChart() {
    final Map<String, dynamic> ingresos = Map<String, dynamic>.from(
      data?['ingresosPorMes'] ?? {},
    );
    final Map<String, dynamic> salidas = Map<String, dynamic>.from(
      data?['salidasPorMes'] ?? {},
    );

    if (ingresos.isEmpty && salidas.isEmpty) {
      return _buildChartPlaceholder("Sin datos de Ingresos/Salidas");
    }

    final meses = {...ingresos.keys, ...salidas.keys}.toList()..sort();
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < meses.length; i++) {
      final mes = meses[i];
      final double ingreso =
          (ingresos[mes] is num) ? (ingresos[mes] as num).toDouble() : 0.0;
      final double salida =
          (salidas[mes] is num) ? (salidas[mes] as num).toDouble() : 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: ingreso, color: Colors.green, width: 6),
            BarChartRodData(toY: salida, color: Colors.red, width: 6),
          ],
        ),
      );
    }

    const mesesCortos = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ];

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            "Ingresos y Salidas",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        // Mostrar solo enteros
                        if (value % 1 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= meses.length) {
                          return const SizedBox.shrink();
                        }
                        final mesNum = meses[value.toInt()].split('-')[1];
                        const mesesCortos = [
                          "Ene",
                          "Feb",
                          "Mar",
                          "Abr",
                          "May",
                          "Jun",
                          "Jul",
                          "Ago",
                          "Sep",
                          "Oct",
                          "Nov",
                          "Dic",
                        ];
                        return Text(
                          mesesCortos[int.parse(mesNum) - 1],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.square, color: Colors.green, size: 10),
              SizedBox(width: 4),
              Text("Ingresos", style: TextStyle(fontSize: 10)),
              SizedBox(width: 12),
              Icon(Icons.square, color: Colors.red, size: 10),
              SizedBox(width: 4),
              Text("Salidas", style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabla() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Por Categoría de Animal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              border: TableBorder.symmetric(
                inside: const BorderSide(color: Colors.grey),
              ),
              children: [
                _buildRow([
                  "Categoría",
                  "Cantidad",
                  "Tactadas",
                  "No Tactadas",
                ], bold: true),
                _buildRow([
                  "Vacas",
                  "${data!['vacas']}",
                  "${data!['tactadas']}",
                  "${data!['no_tactadas']}",
                ]),
                _buildRow(["Terneros/as", "${data!['terneros']}", "-", "-"]),
                _buildRow(["Novillos/as", "${data!['novillos']}", "-", "-"]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(List<String> cells, {bool bold = false}) {
    return TableRow(
      children:
          cells
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    cell,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildChartPlaceholder(String title) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(title, style: TextStyle(color: Colors.grey.shade700)),
      ),
    );
  }
}
