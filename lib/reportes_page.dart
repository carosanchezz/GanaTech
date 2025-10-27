import 'package:flutter/material.dart';
import 'stock_animales_page.dart';
import 'historial_economico_page.dart';
import 'historial_sanidad_page.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), 
        title: const Text(
          'Reportes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, 
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildReportCard(
              icon: Icons.show_chart,
              title: 'Stock de Animales',
              subtitle: 'Evolución del número de animales',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StockAnimalesPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              icon: Icons.pie_chart,
              title: 'Sanidad y Reproducción',
              subtitle: 'Datos sobre sanidad y reproducción',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistorialSanidadPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              icon: Icons.attach_money,
              title: 'Economía',
              subtitle: 'Ingresos y gastos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistorialEconomicoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Tarjeta reutilizable ---
  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF2E7D32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
