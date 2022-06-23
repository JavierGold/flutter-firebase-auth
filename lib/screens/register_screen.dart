import 'package:auth_cap/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatelessWidget {
  //const RegisterScreen({Key? key}) : super(key: key);
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          const Text(
            'Registro',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 45,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            child: Icon(
              Icons.article_outlined,
              size: 40,
            ),
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  focusColor: Colors.white,
                  counterStyle: TextStyle(
                    color: Colors.white,
                    height: double.minPositive,
                  ),
                  counterText: "",
                  filled: true,
                  fillColor: Color.fromARGB(255, 12, 12, 12),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  errorStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  focusColor: Colors.white,
                  counterStyle: TextStyle(
                    color: Colors.white,
                    height: double.minPositive,
                  ),
                  counterText: "",
                  filled: true,
                  fillColor: Color.fromARGB(255, 12, 12, 12),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  errorStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () async {
                    final authUser =
                        await authService.createUserWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    );
                    users
                        .add({
                          'email': emailController.text,
                          //'password': passwordController.text,
                          'uid': authUser!.uid,
                          'tipo': 'user'
                        })
                        .then((value) => print('Usuario añadido'))
                        .catchError((error) => print('falló añadir usuario'));
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Registro',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
