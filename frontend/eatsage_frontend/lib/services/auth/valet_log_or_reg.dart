// ignore_for_file: prefer_const_constructors

import 'package:eatsage_frontend/pages/valet_login.dart';
import 'package:eatsage_frontend/pages/valet_reg.dart';
import 'package:flutter/material.dart';
import 'package:eatsage_frontend/pages/login_page.dart';
import 'package:eatsage_frontend/pages/register_page.dart';

class ValetLogOrReg extends StatefulWidget {
  const ValetLogOrReg({super.key});

  // This widget is the root of your application.
  @override
  State<ValetLogOrReg> createState() => _valetLoginOrRegState();
}

class _valetLoginOrRegState extends State<ValetLogOrReg> {
  bool ShowLoginPage = true;

  void togglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return ValetLogin(
        onTap: togglePages,
      );
    } else {
      return ValetReg(
        onTap: togglePages,
      );
    }
  }
}
