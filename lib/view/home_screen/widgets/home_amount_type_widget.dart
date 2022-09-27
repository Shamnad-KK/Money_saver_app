import 'package:flutter/material.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAmountTypeWidget extends StatelessWidget {
  const HomeAmountTypeWidget({
    Key? key,
    required this.isIncome,
  }) : super(key: key);

  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isIncome == true
            ? Text(
                'Income',
                style: appBodyTextStyle,
              )
            : const Icon(
                Icons.arrow_circle_down,
                color: Colors.red,
              ),
        SizedBox(
          width: 10.w,
        ),
        isIncome == true
            ? const Icon(
                Icons.arrow_circle_up,
                color: Colors.green,
              )
            : Text(
                'Expense',
                style: appBodyTextStyle,
              )
      ],
    );
  }
}
