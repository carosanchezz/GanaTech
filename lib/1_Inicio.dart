import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'animales_page.dart'; // importamos la pantalla de animales

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = -1; // -1 = ninguno seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestión Ganadera",
          style: TextStyle(color: Colors.white), // 👈 acá el color blanco
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuButton(
              index: 0,
              icon: FontAwesomeIcons.cow,
              label: "Animales",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AnimalesScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              index: 1,
              icon: Icons.vaccines,
              label: "Sanidad",
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              index: 2,
              icon: Icons.attach_money,
              label: "Económico",
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              index: 3,
              icon: Icons.bar_chart,
              label: "Reportes",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.green[700],
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
