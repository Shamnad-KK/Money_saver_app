// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/repository/settings_repository.dart';

class SettingsController {
  late TabController tabController;
  Future<void> help() async {
    await SettingsRepository().help();
  }

  Future<void> facebook() async {
    await SettingsRepository().faceBook();
  }

  Future<void> linkedin() async {
    await SettingsRepository().linkedin();
  }

  Future<void> insta() async {
    await SettingsRepository().insta();
  }

  Future<void> gitHub() async {
    await SettingsRepository().gitHub();
  }

  Future<void> share() async {
    await SettingsRepository().share();
  }

  void showPopUP(BuildContext context, AuthController authController,
      TransactionController transactionController) {
    SettingsRepository()
        .showPopUp(context, authController, transactionController);
  }

  void aboutDialogue(BuildContext context, TabController tabController) {
    SettingsRepository().aboutDialogue(context, tabController);
  }
}
