// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const myButton({super.key, required this.text, required this.onTap});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: Center(child: Text(text)),
      ),
    );
  }
}
