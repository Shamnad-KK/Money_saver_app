import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/helpers/text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gotoLogin(context);
    });
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/logo-removebg.png',
                scale: 2.5.sp,
              ),
              sBoxH10,
              AnimatedTextKit(animatedTexts: [
                ColorizeAnimatedText(
                  'MONEY SAVER',
                  textStyle: appBarTextStyle,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.black,
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> gotoLogin(BuildContext context) async {
    final checkSaved = AuthController.checkSaved(context);
    await Future.delayed(
      const Duration(seconds: 2),
    );
    await checkSaved;
  }
}
