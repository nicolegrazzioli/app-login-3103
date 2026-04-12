import 'package:flutter/material.dart';
import 'package:app_final/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showPasswordFields = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          suffixIcon: obscure ? const Icon(Icons.remove_red_eye_outlined, color: Colors.white70) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.silverBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.neonGreen),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  RichText(
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
                              color: AppColors.bottomGreen,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Text(
                              "go",
                              style: TextStyle(
                                fontSize: 16,
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
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      "Meu perfil",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 24),
                    
                    // Avatar Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Alterar foto",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    
                    // Fields
                    _buildTextField("Nome", _nameController),
                    _buildTextField("E-mail", _emailController),
                    _buildTextField("Telefone", _phoneController),
                    
                    const SizedBox(height: 8),
                    
                    // Accordion for Password
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPasswordFields = !_showPasswordFields;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _showPasswordFields ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Alterar senha",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    
                    if (_showPasswordFields) ...[
                      const SizedBox(height: 24),
                      _buildTextField("Senha atual", _currentPasswordController, obscure: true),
                      _buildTextField("Nova senha", _newPasswordController, obscure: true),
                      _buildTextField("Confirmar senha", _confirmPasswordController, obscure: true),
                    ],
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bottomGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          // TODO: Mocks de salvar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Perfil atualizado com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text("Salvar", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
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
          currentIndex: 3, // Seleciona o 4º item (perfil)
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 28), label: "Menu 1"),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined, size: 28), label: "Menu 2"),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: "Menu 3"),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: "Menu 4"),
          ],
        ),
      ),
    );
  }
}
