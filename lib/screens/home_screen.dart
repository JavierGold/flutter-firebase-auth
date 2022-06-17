import 'package:auth_cap/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatelessWidget {
  //const HomeScreen({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Estás en Home Screen'),
          Center(
            child: ElevatedButton(
              child: Text('Cerrar Sesión'),
              onPressed: () async {
                await authService.signOut();
              },
            ),
          ),
          Text(
            'Leer usuarios de Firestore',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: users,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Text('Algo salió mal');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Cargando');
                    }

                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Text('Correo: ${data.docs[index]['email']}');
                      },
                    );
                  })),
        ],
      ),
    );
  }
}
