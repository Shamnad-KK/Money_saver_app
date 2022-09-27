import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/view/home_screen/widgets/home_amount_type_widget.dart';
import 'package:provider/provider.dart';

class AmountCardWidget extends StatelessWidget {
  const AmountCardWidget({
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
          Consumer<TransactionController>(
            builder:
                (BuildContext context, transactionController, Widget? child) {
              return Column(
                children: [
                  Text(
                    transactionController.currentBalance.round() < 0
                        ? 'LOSS'
                        : 'CURRENT BALANCE',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  FittedBox(
                    child: Text(
                      ' ${transactionController.currentBalance.round()}',
                      style: transactionController.currentBalance.round() < 0
                          ? homeBoldLossAmountStyle
                          : homeBoldAmountStyle,
                    ),
                  ),
                ],
              );
            },
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
                      child: Consumer<TransactionController>(
                        builder: (BuildContext context, transactionController,
                            Widget? child) {
                          return FittedBox(
                            child: Text(
                              '₹ ${transactionController.totalIncome.round()}',
                              style: homeLargeAmountStyle,
                            ),
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: Consumer<TransactionController>(
                        builder: (BuildContext context, transactionController,
                            Widget? child) {
                          return FittedBox(
                            child: Text(
                              '₹ ${transactionController.totalExpense.round()}',
                              style: homeLargeAmountStyle,
                            ),
                          );
                        },
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
