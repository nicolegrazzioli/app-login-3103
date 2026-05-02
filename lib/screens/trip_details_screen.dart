import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_final/screens/home_screen.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/custom_fab.dart';
import 'profile_screen.dart';
import 'new_expense_screen.dart';
import 'new_trip_screen.dart';

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: AppColors.darkBackground,
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTripScreen(trip: widget.trip),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Editar Viagem', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Excluir Viagem', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                color: AppColors.moneyGreen, // Verde para os valores descritos pelo usuário
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
              child: SearchFilterBar(
                onFilterTap: () {},
                onSortTap: () {},
                onSearchChanged: (val) {},
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
      
      floatingActionButton: CustomFAB(
        rightPadding: 32.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewExpenseScreen(tripTitle: widget.trip.title)),
          );
        },
      ),
      
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildExpenseItem(String title, Category category, String originalAmount, String convertedAmount) {
    return Dismissible(
      key: UniqueKey(), // Idealmente usar o ID do gasto real aqui
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: const Text("Excluir Gasto", style: TextStyle(color: Colors.white)),
            content: const Text("Tem certeza que deseja excluir este gasto?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar", style: TextStyle(color: Colors.white))),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Excluir", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewExpenseScreen(
                tripTitle: widget.trip.title,
                isEditing: true,
                expenseData: {
                  'title': title,
                  'amount': originalAmount.split(' ')[1], // Extrai o número do "€ 1,50"
                  'currency': originalAmount.split(' ')[0] == '€' ? 'Euro' : 'Dólar',
                  'category': category.name,
                },
              ),
            ),
          );
        },
        child: Padding(
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
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text("Excluir Viagem", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Tem certeza que deseja excluir esta viagem? Todos os gastos serão perdidos.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Fechar dialog
                Navigator.pop(context); // Voltar para a home
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

