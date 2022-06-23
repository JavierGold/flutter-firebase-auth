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
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.home,
            size: 70,
          ),
          const Text(
            'Estás en Home Screen',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          SizedBox(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Cerrar Sesión',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                onPressed: () async {
                  await authService.signOut();
                },
              ),
            ],
          )),
          const Text(
            'Leer usuarios de Firestore',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
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
    return SizedBox(
      height: 25,
      width: 50,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () async {
            // await authService.delete();

            usersCollectionReference.doc(actualUserId).delete().then((_) {
              print('Se eliminó correctamente');
            });
          },
          child: const Icon(
            Icons.delete,
            size: 18,
            color: Colors.white,
          )),
    );
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
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Correo:   ${data.docs[index]['email']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      showButton(data.docs[index].id)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]);
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
