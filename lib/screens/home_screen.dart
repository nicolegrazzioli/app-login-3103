import 'package:flutter/material.dart';
import 'package:app_final/screens/profile_screen.dart';
import 'package:app_final/screens/trip_details_screen.dart';
import 'package:app_final/screens/new_trip_screen.dart';
import '../core/models/user.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/custom_fab.dart';
import 'balances_screen.dart';

// --- MOCK API E MODELOS ---
// Estes modelos representam as informações que virão do seu back-end em Java futuramente via JSON.

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});
}

final List<Category> categories = [
  Category(
    name: 'Alimentação',
    icon: Icons.restaurant,
    color: const Color(0xFFFF7043),
  ),
  Category(
    name: 'Mercado',
    icon: Icons.shopping_basket,
    color: const Color(0xFF66BB6A),
  ),
  Category(
    name: 'Transporte',
    icon: Icons.directions_car,
    color: const Color(0xFF42A5F5),
  ),
  Category(
    name: 'Hospedagem',
    icon: Icons.hotel,
    color: const Color(0xFF7986CB),
  ),
  Category(
    name: 'Lazer',
    icon: Icons.confirmation_number,
    color: const Color(0xFFEC407A),
  ),
  Category(
    name: 'Compras',
    icon: Icons.local_mall,
    color: const Color(0xFF26C6DA),
  ),
  Category(
    name: 'Serviços',
    icon: Icons.assignment,
    color: const Color(0xFF78909C),
  ),
  Category(
    name: 'Extras',
    icon: Icons.auto_awesome,
    color: const Color(0xFFFFCA28),
  ),
];

class Trip {
  final String title;
  final String dateInterval;
  final double amount;
  final String? imageUrl;

  Trip({
    required this.title,
    required this.dateInterval,
    required this.amount,
    this.imageUrl,
  });
}

class ApiService {
  Future<User> fetchUser() async {
    // await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 1,
      name: "Nicole (Mock)",
      email: "nicole@exemplo.com",
      password: "123",
    );
  }

  Future<List<Trip>> fetchTrips() async {
    // await Future.delayed(const Duration(seconds: 1));
    return [
      Trip(
        title: "Viagem a Trabalho",
        dateInterval: "12/05/2026 - 15/05/2026",
        amount: 1545.90,
      ),
      Trip(
        title: "Férias de Inverno",
        dateInterval: "01/07/2026 - 15/07/2026",
        amount: 4712.30,
      ),
      Trip(
        title: "Encontro de Devs",
        dateInterval: "22/09/2026 - 25/09/2026",
        amount: 830.00,
      ),
    ];
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;
  List<Trip>? _trips;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final api = ApiService();
    final results = await Future.wait([
      api.fetchUser(),
      api.fetchTrips(),
    ]);

    if (mounted) {
      setState(() {
        _currentUser = results[0] as User;
        _trips = results[1] as List<Trip>;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.moneyGreen))
          : SafeArea(
              child: Column(
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      children: [
                        // Logo pila.go
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "pila",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: AppColors.moneyGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              ".go",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Saudação e Saldo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Olá, ${_currentUser?.name.split(' ')[0] ?? 'Nicole'}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Saldo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "R\$ 8.710,96",
                                  style: TextStyle(
                                    color: AppColors.moneyGreen,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Barra de Pesquisa e Filtros (Widget Compartilhado)
                        SearchFilterBar(
                          onFilterTap: () {
                            // Lógica de filtrar
                          },
                          onSortTap: () {
                            // Lógica de ordenar
                          },
                          onSearchChanged: (value) {
                            // Lógica de pesquisa
                          },
                        ),
                      ],
                    ),
                  ),

                  // --- LISTA DE VIAGENS ---
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _trips?.length ?? 0,
                      itemBuilder: (context, index) {
                        final trip = _trips![index];
                        return _buildTripCard(context, trip);
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTripScreen()),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BalancesScreen()),
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

  Widget _buildTripCard(BuildContext context, Trip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(trip: trip),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: trip.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(trip.imageUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: trip.imageUrl == null ? const Color(0xFF1E293B) : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              trip.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trip.dateInterval,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "R\$ ${trip.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: AppColors.moneyGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
