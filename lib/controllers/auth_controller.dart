// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/screens/welcome_screen.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static Future login({required String name}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(nameKey, name);
  }

  static Future checkSaved(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final name = sharedPreferences.getString(nameKey);
    if (name == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    }
  }

  static Future resetApp() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
