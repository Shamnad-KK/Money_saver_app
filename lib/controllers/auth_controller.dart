import 'package:flutter/material.dart';
import 'package:money_manager/repository/auth_repository.dart';

class AuthController extends ChangeNotifier {
  String? name = '';

  static Future login({required String name}) async {
    await AuthRepository.login(name: name);
  }

  Future<void> saveName() async {
    name = await AuthRepository().saveName();
    notifyListeners();
  }

  static Future checkSaved(BuildContext context) async {
    await AuthRepository.checkSaved(context);
  }

  static Future resetApp() async {
    await AuthRepository.resetApp();
  }
}
