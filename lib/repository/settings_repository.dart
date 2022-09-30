// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/urls.dart';
import 'package:money_manager/utils/snackbars.dart';
import 'package:money_manager/view/settings_screen/widgets/about_dialog_widget.dart';
import 'package:money_manager/view/splash_screen/splash_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsRepository {
  Future<void> help() async {
    try {
      await launchUrl(AppUrls.mailurl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> faceBook() async {
    try {
      await launchUrl(AppUrls.fbUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> linkedin() async {
    try {
      await launchUrl(AppUrls.linkedinUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> insta() async {
    try {
      await launchUrl(AppUrls.instaUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> gitHub() async {
    try {
      await launchUrl(AppUrls.gitUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> share() async {
    await Share.share(
      'Check out Money Saver for recording your transactions, https://play.google.com/store/apps/details?id=in.shamnad.money_manager',
    );
  }

  void showPopUp(BuildContext context, AuthController authController,
      TransactionController transactionController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Do you want to reset the app ?'),
          actions: [
            TextButton(
              onPressed: () async {
                await authController.resetApp();
                await transactionController.deleteAllData();
                SnackBars.customSnackbar('Reseted successfully');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const SplashScreen(),
                    ),
                    (route) => false);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void aboutDialogue(BuildContext context, TabController tabController) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AboutDialogWidget(tabController: tabController);
        });
  }
}
