import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/helpers/text_style.dart';

class SettingsRowWidget extends StatelessWidget {
  const SettingsRowWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.ontap,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          Icon(icon),
          sBoxw10,
          Text(
            text,
            style: appBodyTextStyle,
          )
        ],
      ),
    );
  }
}
