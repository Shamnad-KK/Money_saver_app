import 'package:flutter/material.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';

class RadioButtonRowWidget extends StatelessWidget {
  const RadioButtonRowWidget({
    Key? key,
    required this.transactionConsumer,
  }) : super(key: key);
  final TransactionController transactionConsumer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            contentPadding: const EdgeInsets.all(
              0,
            ),
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            title: const Text("Income"),
            leading: Radio(
              value: CategoryType.income,
              groupValue: transactionConsumer.categoryType,
              onChanged: (value) {
                transactionConsumer.setCategoryType(CategoryType.income);
                transactionConsumer.setDropDownValue(null);
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: const EdgeInsets.all(
              0,
            ),
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            horizontalTitleGap: 0,
            title: const Text("Expense"),
            leading: Radio(
              value: CategoryType.expense,
              groupValue: transactionConsumer.categoryType,
              onChanged: (value) {
                transactionConsumer.setCategoryType(CategoryType.expense);
                transactionConsumer.setDropDownValue(null);
              },
            ),
          ),
        ),
      ],
    );
  }
}
