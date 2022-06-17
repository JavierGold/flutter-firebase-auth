import 'package:auth_cap/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatelessWidget {
  //const RegisterScreen({Key? key}) : super(key: key);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.createUserWithEmailAndPassword(
                emailController.text,
                passwordController.text,
              );
              users
                  .add({
                    'email': emailController.text,
                    'password': passwordController.text
                  })
                  .then((value) => print('Usuario añadido'))
                  .catchError((error) => print('falló añadir usuario'));
              Navigator.pop(context);
            },
            child: Text('Registrarse'),
          ),
        ],
      ),
    );
  }
}
