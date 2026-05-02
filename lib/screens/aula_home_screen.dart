import 'package:aula_formularios/core/dao/userDAO.dart';
import 'package:flutter/material.dart';

import '../core/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<User> users = [];

  bool loading = true;

  getUsuarios() async {
    loading = true;
    try {
      users = await UserDAO().findAllUsers();
    } finally {
      loading = false;
    }
    setState(() {});
  }

  deleteUser(int id) async {
    loading = true;
    try {
      await UserDAO().deleteUser(id);
      await getUsuarios();
    } finally {
      loading = false;
    }
  }

  editUser(int index) async {
    final user = users[index];
    final nameController = TextEditingController(text: user.name);
    final lastNameController = TextEditingController(text: user.lastName ?? '');
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: user.password);
    final phoneController = TextEditingController(text: user.phone ?? '');
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Update User'),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      label: Text('Last Name'),
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      label: Text('Phone'),
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedUser = User(
                            id: user.id,
                            name: nameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                        );
                        final success = await UserDAO().updateUser(updatedUser) > 0;
                        await getUsuarios();
                        if (!success) print('falhou');
                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: loading ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${users[index].name} ${users[index].lastName ?? ''}'),
                              Text('${users[index].email} ${users[index].phone ?? ''}'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async => await editUser(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async => await deleteUser(users[index].id!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
