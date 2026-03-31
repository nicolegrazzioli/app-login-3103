import 'package:app_final/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// statefull
//as coisas mudam de estado
//ocupa mais espaço operacional

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //variavel iniciando nome com _ fica oculta (como se fosse private)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //cria e inicializa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: SingleChildScrollView(
        //tela tem rolagem
        child: Form(
          key: _formKey,

          child: Column(
            children: <Widget>[
              //imagem
              Padding(
                padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
                //espaçamento ao redor do filho
                child: Center(
                    child: Container(
                        height: 150,
                        width: 200,
                        child: FlutterLogo(),
                    ),
                ),
              ),

              //input email
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                  child: TextFormField( //default: underline
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return '* campo obrigatorio';
                      }
                    }, //pega valor do campo e verifica alhuma coisa
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      label: Text('Email', style: TextStyle(color: Colors.deepPurpleAccent),),
                    ),
                  ),
              ),

              //input senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: TextFormField( //default: underline
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return '* campo obrigatorio';
                    }
                  }, //pega valor do campo e verifica alhuma coisa

                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    label: Text('Senha', style: TextStyle(color: Colors.deepPurpleAccent),),
                  ),
                ),
              ),

              // OutlinedButton(child: Text('sarjfrgçsodjg'), onPressed: (){}),
              //botao de esqueci a senha
              TextButton(
                  onPressed: (){},
                  child: Text(
                      'Esqueci a senha',
                       style: TextStyle(
                         color: Colors.blue,
                         fontSize: 15,
                       ),
                  ),
              ),


              //botao de login
              Container(
                height: 50,
                width: 500,
                child: ElevatedButton(
                    onPressed: (){
                      //gerenciador de rotas do flutter
                      bool valido = _formKey.currentState!.validate();
                      if (valido) {
                        Navigator.push( //insere uma nova rota na pilha
                            context,
                            MaterialPageRoute(
                              builder: (context) => /*manda para nova rota*/ HomeScreen(),
                            ),
                        );
                      }

                    },
                    //cria isntancia do botao e herda a estiliza~çao
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white, //o que vai na frente do botao (texto)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(30),
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
              ),

              const /*melhora performance*/ SizedBox(
                height: 90,
              ),
              TextButton(
                  onPressed: () => print('criar conta'),
                  child: Text(
                    'criar conta', style: TextStyle(color: Colors.purple),
                  ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
