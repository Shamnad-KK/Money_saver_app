import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';
import 'package:money_manager/widgets/small_button.dart';
import 'package:provider/provider.dart';

class CredentialScreen extends StatelessWidget {
  const CredentialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(
            'assets/credential_bg/2.jpg',
          ),
          fit: BoxFit.fill,
        ),
        color: Colors.black.withOpacity(0.8),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6.0,
          sigmaY: 6.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: authController.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: authController.nameController,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Name cannot be empty';
                        } else if (name.startsWith(RegExp(
                            r'''[ +×÷=/_€£¥₩;'`~\°•○●□■♤♡◇♧☆▪︎¤《》¡¿!@#$%^&*(),.?":{}|<>]'''))) {
                          return 'Name cannot start with special characters';
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(
                        color: appBarText,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: whiteColor,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: whiteColor,
                          ),
                        ),
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                          color: appBarText,
                        ),
                      ),
                    ),
                  ),
                  sBoxH20,
                  Align(
                    alignment: Alignment.centerRight,
                    child: SmallButton(
                      ontap: () {
                        if (authController.formKey.currentState!.validate()) {
                          authController.formKey.currentState?.save();

                          authController.login(
                              name: authController.nameController.text);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const BottomNavBar(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
