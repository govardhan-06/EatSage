// ignore_for_file: prefer_const_constructors

import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:eatsage_frontend/components/my_drawer.dart';

class RestHomePage extends StatelessWidget {
  const RestHomePage({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.singOut(); // Corrected the typo here
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 201, 67, 100),
          shadowColor: Colors.white,
          title: Text(
            "Restaurent Home",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: logout,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        drawer: MyDrawer(), // Using the MyDrawer widget here
      ),
    );
  }
}
