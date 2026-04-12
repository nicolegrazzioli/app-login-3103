import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_final/screens/home_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.trip.title,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Valor Total - Placeholder enquanto não puxamos do banco
            const Text(
              "R\$ 4712,30",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF67C282), // Verde para os valores descritos pelo usuário
              ),
            ),
            const SizedBox(height: 40),
            
            // Gráfico de Pizza Básico com fl_chart
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 0,
                  sections: [
                    PieChartSectionData(
                      color: categories[0].color, // Alimentação
                      value: 40,
                      title: '',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      color: categories[1].color, // Mercado
                      value: 30,
                      title: '',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      color: categories[2].color, // Transporte
                      value: 20,
                      title: '',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      color: categories[3].color, // Hospedagem
                      value: 10,
                      title: '',
                      radius: 90,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: const BorderSide(color: Color(0xFF475569), width: 1),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("filtrar", style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 16)),
                          Icon(Icons.keyboard_arrow_down, color: Color(0xFFF5F5F5)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: const BorderSide(color: Color(0xFF475569), width: 1),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ordenar", style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 16)),
                          Icon(Icons.keyboard_arrow_down, color: Color(0xFFF5F5F5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const Text(
                    "xx/xx/xx, dia da semana",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildExpenseItem("Título do gasto", categories[3], "€ 1,50", "R\$ 10,00"),
                  const Divider(color: AppColors.silverBorder, height: 1),
                  _buildExpenseItem("Título do gasto", categories[5], "€ 1,50", "R\$ 10,00"),
                  const Divider(color: AppColors.silverBorder, height: 1),
                  const SizedBox(height: 16),
                  
                  const Text(
                    "xx/xx/xx, dia da semana",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildExpenseItem("Título do gasto", categories[3], "€ 1,50", "R\$ 10,00"),
                  const Divider(color: AppColors.silverBorder, height: 1),
                  _buildExpenseItem("Título do gasto", categories[5], "€ 1,50", "R\$ 10,00"),
                  const SizedBox(height: 80), // Padding extra para não ocluir com o bottomMenu/FAB
                ],
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 32.0),
        child: SizedBox(
          height: 70, 
          width: 70,
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: const Color(0xFF00E676),
            elevation: 0,
            shape: const CircleBorder(),
            label: const Text(
              "+",
              style: TextStyle(color: Colors.white, fontSize: 48),
            ),
          ),
        ),
      ),
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, 
          unselectedItemColor: const Color(0xFFF5F5F5),
          selectedItemColor: const Color(0xFFF5F5F5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 28), label: "Menu 1"),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined, size: 28), label: "Menu 2"),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: "Menu 3"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 28), label: "Menu 4"),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(String title, Category category, String originalAmount, String convertedAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Ícone
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.silverBorder, width: 1),
            ),
            child: Icon(category.icon, color: category.color),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(category.name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          // Valores
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(originalAmount, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(convertedAmount, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
