import 'package:flutter/material.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/widgets/home_amount_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 40.w,
        right: 40.w,
        top: 110.h,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ValueListenableBuilder(
            builder: (BuildContext context, num value, Widget? child) {
              return Column(
                children: [
                  Text(
                    value.round() < 0 ? 'LOSS' : 'CURRENT BALANCE',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  FittedBox(
                    child: Text(
                      ' ${value.round()}',
                      style: value.round() < 0
                          ? homeBoldLossAmountStyle
                          : homeBoldAmountStyle,
                    ),
                  ),
                ],
              );
            },
            valueListenable: TransactionDbFunctions.currentBalance,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    HomeAmountTypeWidget(isIncome: true),
                    HomeAmountTypeWidget(isIncome: false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: ValueListenableBuilder(
                        builder:
                            (BuildContext context, num value, Widget? child) {
                          return FittedBox(
                            child: Text(
                              '₹ ${value.round()}',
                              style: homeLargeAmountStyle,
                            ),
                          );
                        },
                        valueListenable: TransactionDbFunctions.totalIncome,
                      ),
                    ),
                    Flexible(
                      child: ValueListenableBuilder(
                        builder:
                            (BuildContext context, num value, Widget? child) {
                          return FittedBox(
                            child: Text(
                              '₹ ${value.round()}',
                              style: homeLargeAmountStyle,
                            ),
                          );
                        },
                        valueListenable: TransactionDbFunctions.totalExpense,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
