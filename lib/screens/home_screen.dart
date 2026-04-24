import 'package:flutter/material.dart';
import 'package:app_final/screens/profile_screen.dart';
import 'package:app_final/screens/trip_details_screen.dart';
import '../core/models/user.dart';

// --- MOCK API E MODELOS ---
// Estes modelos representam as informações que virão do seu back-end em Java futuramente via JSON.

//isso aqui ta certo
class AppColors {
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color moneyGreen = Color(0xFF10B981);
  static const Color bottomGreen = Color(0xFF058E64);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color silverBorder = Color(0xFF475569);
}

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
  // Simula a busca dos dados do usuário logado
  Future<User> fetchUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula tempo de rede
    return User(
      id: 1,
      name: "Nicole (Mock)",
      email: "nicole@exemplo.com",
      password: "123",
    );
  }

  // Simula a busca das viagens do usuário no banco de dados
  Future<List<Trip>> fetchTrips() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula tempo de rede
    return [
      Trip(
        title: "Viagem a Trabalho",
        dateInterval: "12/05/2026 - 15/05/2026",
        amount: 1545.90,
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/New_york_times_square-terabass.jpg/800px-New_york_times_square-terabass.jpg",
      ),
      Trip(
        title: "Férias de Inverno",
        dateInterval: "01/07/2026 - 15/07/2026",
        amount: 4712.30,
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Lago_di_Braies_-_2_-_Sept._2016.jpg/800px-Lago_di_Braies_-_2_-_Sept._2016.jpg",
      ),
      Trip(
        title: "Encontro de Devs",
        dateInterval: "22/09/2026 - 25/09/2026",
        amount: 830.00,
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Silicon_Valley_welcome_sign.jpg/800px-Silicon_Valley_welcome_sign.jpg",
      ),
    ];
  }
}

// --- TELA ---

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
    
    // Fazendo as chamadas paralelamente para ser mais rápido
    final results = await Future.wait([
      api.fetchUser(),
      api.fetchTrips(),
    ]);

    setState(() {
      _currentUser = results[0] as User;
      _trips = results[1] as List<Trip>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF67C282)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "pila.",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(left: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF67C282),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Text(
                              "go",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Olá, ${_currentUser?.name ?? 'Usuário'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter and Sort row (FIXED OUTSIDE SCROLL)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0),
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

          // Body List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dynamic Cards list
                  if (_trips != null && _trips!.isNotEmpty)
                    ..._trips!.map((trip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: trip.imageUrl == null
                            ? _buildSolidCard(trip)
                            : _buildImageCard(trip),
                      );
                    })
                  else
                    const Center(
                      child: Text("Nenhuma viagem cadastrada."),
                    ),

                  const SizedBox(height: 80), // Espaço pro Bottom App Bar e botão não cobrirem a lista
                ],
              ),
            ),
          ),
        ],
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 32.0), // Mais para a esquerda
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
          backgroundColor: Colors.transparent, // Fica com a cor do container pai
          unselectedItemColor: const Color(0xFFF5F5F5),
          selectedItemColor: const Color(0xFFF5F5F5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          currentIndex: 0,
          onTap: (index) {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: "Menu 1"),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined, size: 28), label: "Menu 2"),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: "Menu 3"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 28), label: "Menu 4"),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES DOS CARDS ---

  Widget _buildSolidCard(Trip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: trip)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C324D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trip.dateInterval,
                  style: const TextStyle(color: Color(0xFF2C324D), fontSize: 14),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "R\$ ${trip.amount.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF67C282), // Verde
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
   );
  }

  Widget _buildImageCard(Trip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: trip)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
          image: NetworkImage(trip.imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xB3000000), // 000000 com 70%
              Color(0xFF000000), // 000000 com 100%
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0, bottom: 16.0),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trip.dateInterval,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "R\$ ${trip.amount.toStringAsFixed(2).replaceAll('.', ',')}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF67C282), // Verde
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
