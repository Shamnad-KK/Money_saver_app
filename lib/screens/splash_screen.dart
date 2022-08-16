import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/helpers/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

  Future<void> gotoLogin() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    if (!mounted) {
      return;
    }
    await AuthController.checkSaved(context);
  }
}
