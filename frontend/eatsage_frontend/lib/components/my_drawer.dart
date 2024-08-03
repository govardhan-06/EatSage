// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:eatsage_frontend/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.singOut();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 201, 67, 100),
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset(
                  'assets/icon.png',
                  width: 400, // Adjust width as needed
                  height: 400, // Adjust height as needed
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListTile(
                title: Text("Home", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListTile(
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () {
                  logout();
                },
              ),
            ),
          ],
        ));
  }
}
