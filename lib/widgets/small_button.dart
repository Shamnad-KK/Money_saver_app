import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/helpers/colors.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.ontap,
  }) : super(key: key);
  final VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: whiteColor,
          ),
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'assets/icons/double_arrow_forward.png',
        ),
      ),
    );
  }
}
