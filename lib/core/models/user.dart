class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? phone;

  User({
   this.id,
   required this.name,
   required this.email,
   required this.password,
   this.phone,
});

  //chave, valor - chama user.toMap
  //transforma em string e guarda no banco
  Map<String, dynamic> toMap() { //dynamic = recebe string ou  int
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  //receb do banco
  factory /*metodo de criaçao de objetos*/ User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }


}