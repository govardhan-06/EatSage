// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eatsage_frontend/services/auth/login_or_register.dart';
import 'package:eatsage_frontend/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginOrReg();
          }
        },
      ),
    );
  }
}
