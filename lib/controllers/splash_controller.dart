import 'package:flutter/material.dart';
import 'package:money_manager/repository/splash_repository.dart';

class SplashController {
  Future<void> gotoLogin(BuildContext context) async {
    await SplashRepository().gotoLogin(context);
  }
}
