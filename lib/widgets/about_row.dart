import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/helpers/colors.dart';

class AboutRowWidget extends StatelessWidget {
  const AboutRowWidget({
    Key? key,
    required this.leading,
    required this.title,
  }) : super(key: key);
  final String leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 10.r,
          backgroundColor: mainColor,
          child: Text(
            leading,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Flexible(
          child: Text(
            title,
            style: TextStyle(fontSize: 15.sp),
          ),
        )
      ],
    );
  }
}
