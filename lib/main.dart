import 'package:auth_cap/screens/home_screen.dart';
import 'package:auth_cap/screens/login_screen.dart';
import 'package:auth_cap/screens/register_screen.dart';
import 'package:auth_cap/services/auth_service.dart';
import 'package:auth_cap/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Ejemplo Auth Firebase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
