import 'package:auth_cap/models/user_model.dart';
import 'package:auth_cap/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class HomeScreen extends StatelessWidget {
  //const HomeScreen({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  final CollectionReference usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

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
                    Future<User?> userFuture = authService
                        .getUserFromFirestore(authService.getCurrentUser().uid);
                    return showList(authService, data, userFuture);
                  })),
        ],
      ),
    );
  }

  Widget showButton(
    String actualUserId,
  ) {
    return ElevatedButton(
        onPressed: () async {
          // await authService.delete();

          usersCollectionReference.doc(actualUserId).delete().then((_) {
            print('Se eliminó correctamente');
          });
        },
        child: const Icon(Icons.delete));
  }

  Widget showList(AuthService authService, QuerySnapshot<Object?> data,
      Future<User?> userFuture) {
    return FutureBuilder<User?>(
      future: userFuture,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.tipo == 'admin') {
            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                // print(data.docs[index].id);
                final currentUser = authService.getCurrentUser();
                return Row(
                  children: [
                    Text('Correo: ${data.docs[index]['email']}'),
                    showButton(data.docs[index].id)
                  ],
                );
              },
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }
}
