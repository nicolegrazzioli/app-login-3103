import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_fab.dart';
import '../widgets/search_filter_bar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'new_currency_purchase_screen.dart';

class BalancesScreen extends StatefulWidget {
  const BalancesScreen({super.key});

  @override
  State<BalancesScreen> createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  late final PageController _pageController;
  
  final List<Map<String, dynamic>> _mockCurrencies = [
    {"code": "EUR", "balance": "1.500,00", "converted": "R\$ 8.250,00", "vet": "R\$ 5,50", "color": AppColors.euroColor},
    {"code": "USD", "balance": "850,00", "converted": "R\$ 4.675,00", "vet": "R\$ 5,50", "color": AppColors.dollarColor},
  ];

  @override
  void initState() {
    super.initState();
    // Iniciamos em um número alto para permitir rolagem para a esquerda também
    _pageController = PageController(
      viewportFraction: 0.5, 
      initialPage: 1000,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCurrencyCard(String code, String balance, String convertedValue, String vet, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(color: cardColor.withOpacity(0.15), blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(code, style: const TextStyle(color: AppColors.offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(balance, style: const TextStyle(color: AppColors.offWhite, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(convertedValue, style: const TextStyle(color: AppColors.offWhite, fontSize: 18)),
          Text("VET: $vet", style: const TextStyle(color: AppColors.offWhite, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(String title, String location, String originalAmount, String convertedAmount, Color color) {

    return Dismissible(
      key: UniqueKey(),
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
            title: const Text("Excluir Compra", style: TextStyle(color: Colors.white)),
            content: const Text("Tem certeza que deseja excluir esta compra de moeda?", style: TextStyle(color: Colors.white70)),
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
                builder: (context) => NewCurrencyPurchaseScreen(
                  isEditing: true,
                  purchaseData: {
                    'amount': originalAmount.replaceAll(RegExp(r'[^0-9,]'), ''),
                    'currency': title,
                    'rate': '5.50', // Mock rate
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.silverBorder, width: 1),
                  ),
                  child: Icon(Icons.currency_exchange, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(location, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(originalAmount, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(convertedAmount, style: const TextStyle(color: AppColors.offWhite, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Saldos",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "R\$ 14.850,00", // Soma de todas as moedas convertidas pelo VET
              style: TextStyle(
                color: AppColors.moneyGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Carrossel de Moedas Infinito
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final currency = _mockCurrencies[index % _mockCurrencies.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildCurrencyCard(
                      currency["code"], 
                      currency["balance"], 
                      currency["converted"], 
                      currency["vet"], 
                      currency["color"],
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Barra de Busca e Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SearchFilterBar(
                onFilterTap: () {},
                onSortTap: () {},
                onSearchChanged: (value) {},
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de Compras de Moeda
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const Text(
                    "Compras Recentes",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text("20/04/2026, Segunda-feira", style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildPurchaseItem("Euro", "Wise", "€ 500,00", "R\$ 2.750,00", AppColors.euroColor),
                  const Divider(color: AppColors.silverBorder, height: 1),
                  const SizedBox(height: 16),
                  
                  const Text("15/04/2026, Quarta-feira", style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildPurchaseItem("Dólar", "Cofre", "US\$ 300,00", "R\$ 1.500,00", AppColors.dollarColor),
                  const Divider(color: AppColors.silverBorder, height: 1),
                  const SizedBox(height: 16),
                  
                  const Text("10/04/2026, Sexta-feira", style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildPurchaseItem("Euro", "Cartão", "€ 1.000,00", "R\$ 5.500,00", AppColors.euroColor),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewCurrencyPurchaseScreen()),
          );
        },
      ),
      
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // 1 é o índice de "Saldos"
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
