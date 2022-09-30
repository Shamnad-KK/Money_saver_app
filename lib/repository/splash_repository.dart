import 'package:flutter/material.dart';
import 'package:money_manager/controllers/auth_controller.dart';

class SplashRepository {
  Future<void> gotoLogin(BuildContext context) async {
    final checkSaved = AuthController.checkSaved(context);
    await Future.delayed(
      const Duration(seconds: 2),
    );
    await checkSaved;
  }
}
