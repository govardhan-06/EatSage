// ignore_for_file: prefer_const_constructors

import 'package:eatsage_frontend/pages/rest_login.dart';
import 'package:eatsage_frontend/pages/rest_reg.dart';
import 'package:flutter/material.dart';
import 'package:eatsage_frontend/pages/login_page.dart';
import 'package:eatsage_frontend/pages/register_page.dart';

class RestLoginOrReg extends StatefulWidget {
  const RestLoginOrReg({super.key});

  // This widget is the root of your application.
  @override
  State<RestLoginOrReg> createState() => _RestLoginOrRegState();
}

class _RestLoginOrRegState extends State<RestLoginOrReg> {
  bool ShowLoginPage = true;

  void togglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return RestLogin(
        onTap: togglePages,
      );
    } else {
      return RestReg(
        onTap: togglePages,
      );
    }
  }
}
