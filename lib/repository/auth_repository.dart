import 'package:flutter/material.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/screens/welcome_screen.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  String name = '';

  static Future login({required String name}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(nameKey, name);
  }

  Future<String?> saveName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final shared = sharedPreferences.getString(nameKey);
    return shared;
  }

  static Future checkSaved(BuildContext context) async {
    final newContext = Navigator.of(context);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final name = sharedPreferences.getString(nameKey);
    if (name == null) {
      newContext.pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    } else {
      newContext.pushReplacement(
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
