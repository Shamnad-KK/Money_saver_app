import 'package:flutter/material.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTransactionDropdownWidget extends StatelessWidget {
  const AddTransactionDropdownWidget({
    super.key,
    required this.transactionConsumer,
    required this.categoryConsumer,
    required this.type,
    this.transactionModal,
  });
  final TransactionController transactionConsumer;
  final CategoryDBController categoryConsumer;
  final ScreenAction type;
  final TransactionModal? transactionModal;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: (value) {
        if (value == null) {
          return 'Category type cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: type == ScreenAction.addScreen
            ? transactionConsumer.categoryType == CategoryType.income
                ? categoryConsumer.incomeModalNotifier.isEmpty
                    ? 'Please add category'
                    : 'Choose  category'
                : categoryConsumer.expenseModalNotifier.isEmpty
                    ? 'Please add category'
                    : 'Choose  category'
            : transactionModal?.type == transactionConsumer.categoryType
                ? transactionModal!.categoryModal.name
                : 'Choose  category',
        hintStyle: appBodyTextStyle,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: blackColor,
          ),
          borderRadius: BorderRadius.circular(
            10.r,
          ),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
      ),
      value: transactionConsumer.dropDownValue,
      onChanged: (newValue) {
        transactionConsumer.setDropDownValue(newValue);
      },
      items: transactionConsumer.categoryType == CategoryType.income
          ? categoryConsumer.incomeModalNotifier
              .map(
                (modal) => DropdownMenuItem<String>(
                  onTap: () {
                    transactionConsumer.setCategoryModel(modal);
                  },
                  value: modal.id.toString(),
                  child: Text(
                    modal.name,
                    style: appBodyTextStyle,
                  ),
                ),
              )
              .toList()
          : categoryConsumer.expenseModalNotifier
              .map(
                (modal) => DropdownMenuItem<String>(
                  onTap: () {
                    transactionConsumer.setCategoryModel(modal);
                  },
                  value: modal.id.toString(),
                  child: Text(
                    modal.name,
                    style: appBodyTextStyle,
                  ),
                ),
              )
              .toList(),
    );
  }
}
