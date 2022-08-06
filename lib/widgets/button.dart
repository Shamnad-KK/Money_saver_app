import 'package:flutter/cupertino.dart';
import 'package:money_manager/helpers/colors.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({Key? key, required this.text, required this.ontap})
      : super(key: key);
  final String text;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 17, color: whiteColor),
          ),
        ),
      ),
    );
  }
}
