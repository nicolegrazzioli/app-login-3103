import 'package:flutter/material.dart';
import 'package:app_final/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_final/screens/register_screen.dart';

// statefull -- as coisas mudam de estado, ocupa mais espaço operacional

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //variavel iniciando nome com _ fica oculta (como se fosse private)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //cria e inicializa
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        //tela tem rolagem
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: FlutterLogo(size: 100), // Logotipo simples no topo
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              //input email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Entrar na home simulando autenticação
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                              builder: (context) => /*manda para nova rota*/ HomeScreen(),
                    ),
                  );
                },
                child: const Text("Entrar"),
              ),
              TextButton(
                onPressed: () {
                  // Lógica para ir pra tela de Esqueci a senha futuro
                },
                child: const Text("Esqueci a senha"),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  // Ir para a tela de criar conta (-> tela 2)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Criar conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
