import 'dart:convert';

import 'package:auth_cap/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Future<User?> getUserFromFirestore(String uid) async {
    /* users.where("uid", isEqualTo: uid).get().then((value) {
      print("hooooooliiiiiiiiii");
      print(value.docs[0].data());
    }); */

    final userValue = await users.where("uid", isEqualTo: uid).get();
    final userData = userValue.docs[0].data();
    /* print(jsonEncode(userData)); */
    Map<String, dynamic> mapData = jsonDecode(jsonEncode(userData));
    print(mapData);

    return User(mapData['uid'], mapData['email'], tipo: mapData['tipo']);
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  auth.User getCurrentUser() {
    final auxUser = _firebaseAuth.currentUser;
    return auxUser!;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userValue = await users.where("email", isEqualTo: email).get();

    /* print(jsonEncode(userData)); */
    if (userValue.docs.isNotEmpty) {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromFirebase(credential.user);
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  /* Future delete(String uid) async {
    _userFromFirebase(user)
  } */
}
