import 'package:flutter/material.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';

class AddScreenCardWidget extends StatelessWidget {
  const AddScreenCardWidget({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: mainColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: appBarTextStyle,
          ),
          const Icon(
            Icons.add,
            size: 65,
            color: whiteColor,
          )
        ],
      ),
    );
  }
}
