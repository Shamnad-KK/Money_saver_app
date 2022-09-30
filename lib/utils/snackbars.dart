import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SnackBars {
  static void customSnackbar(String text) async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
