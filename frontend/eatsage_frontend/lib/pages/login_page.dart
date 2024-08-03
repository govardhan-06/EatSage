// ignore_for_file: prefer_const_constructors

import 'package:eatsage_frontend/pages/rest_login.dart';
import 'package:eatsage_frontend/pages/valet_login.dart';
import 'package:eatsage_frontend/services/auth/rest_auth_gate.dart';
import 'package:eatsage_frontend/services/auth/valet_auth_gate.dart';
import 'package:eatsage_frontend/services/auth/valet_log_or_reg.dart';
import 'package:flutter/material.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:eatsage_frontend/components/my_button.dart';
import 'package:eatsage_frontend/components/my_text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(
            e.toString(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 67, 100),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      width: 400, // Adjust width as needed
                      height: 400, // Adjust height as needed
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Eating made easier.",
                      style: TextStyle(
                        fontFamily: 'San Francisco',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextfield(
                      hintText: 'Email',
                      obsecure: false,
                      controller: _emailcontroller,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextfield(
                      hintText: 'Password',
                      obsecure: true,
                      controller: _passwordcontroller,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    myButton(
                      text: "Login",
                      onTap: () => login(context),
                    ),
                    const SizedBox(
                      height: 12.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member? ",
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontFamily: 'San Francisco',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ValetAuthGate()),
                      );
                    }
                    ;
                    // Handle VALET button press
                  },
                  child: Text(
                    "VALET",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestAuthGate()),
                        );
                      }

                      // Handle RESTAURANT button press
                    },
                    child: Text(
                      "RESTAURANT",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
