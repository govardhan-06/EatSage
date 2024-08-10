// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:eatsage_frontend/components/my_button.dart';
import 'package:eatsage_frontend/components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordcontroller =
      TextEditingController();
  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    if (_passwordcontroller.text == _confirmPasswordcontroller.text) {
      try {
        final _auth = AuthService();
        _auth.singUpWithEmailAndPassword(
            _emailcontroller.text, _passwordcontroller.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            title: Text(
              e.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
    //later
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 67, 100),
      body: Center(
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
                "Become a Sage!",
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
              MyTextfield(
                hintText: 'Confirm Password',
                obsecure: true,
                controller: _confirmPasswordcontroller,
              ),
              const SizedBox(
                height: 25,
              ),
              myButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(
                height: 12.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
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
                      "Login Now",
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
    );
  }
}
