import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/view/add_transaction_screen/widgets/add_screen_text_field_widget.dart';
import 'package:money_manager/view/add_transaction_screen/widgets/addtransaction_dropdown_widget.dart';
import 'package:money_manager/view/add_transaction_screen/widgets/radio_button_row_widget.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:money_manager/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    Key? key,
    required this.type,
    this.transactionModal,
  }) : super(key: key);
  final ScreenAction type;
  final TransactionModal? transactionModal;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final TransactionController transactionController;
  late final CategoryDBController categoryController;
  late final DropDownController dropDownController;

  @override
  void initState() {
    transactionController =
        Provider.of<TransactionController>(context, listen: false);
    categoryController =
        Provider.of<CategoryDBController>(context, listen: false);
    dropDownController =
        Provider.of<DropDownController>(context, listen: false);

    transactionController.amountController.clear();
    transactionController.dateController.clear();
    transactionController.desController?.clear();
    transactionController.selectedDate = null;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryController.refreshUi();
      if (widget.type == ScreenAction.editScreen) {
        transactionController
            .setCategoryModel(widget.transactionModal?.categoryModal);
        transactionController.setCategoryType(widget.transactionModal!.type);
        transactionController
            .setDropDownValue(widget.transactionModal!.categoryModal.name);
        transactionController.amountController.text =
            widget.transactionModal!.amount.toString();
        transactionController.desController?.text =
            widget.transactionModal?.description ?? "No description";
        transactionController.dateController.text =
            DateFormat('yMMMMd').format(widget.transactionModal!.date);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("add screen called");

    return Scaffold(
      appBar: AppBarWidget(
        leading: widget.type == ScreenAction.addScreen
            ? 'Add Transaction'
            : 'Edit Transaction',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
          ),
          child: Form(
            key: transactionController.formKey,
            child: Column(
              children: [
                Consumer<TransactionController>(builder: (BuildContext context,
                    TransactionController transactionConsumer, Widget? child) {
                  return RadioButtonRowWidget(
                    transactionConsumer: transactionConsumer,
                  );
                }),
                sBoxH20,
                Consumer2<TransactionController, CategoryDBController>(
                  builder: (BuildContext context, transactionvalue,
                      categoryValue, Widget? child) {
                    return AddTransactionDropdownWidget(
                      transactionConsumer: transactionvalue,
                      categoryConsumer: categoryValue,
                      type: widget.type,
                      transactionModal: widget.transactionModal,
                    );
                  },
                ),
                AddScreenTextFieldWidget(
                  controller: transactionController.desController,
                  hintText: 'Description (optional)',
                  isDescription: true,
                ),
                AddScreenTextFieldWidget(
                  controller: transactionController.amountController,
                  validatorText: 'Amount',
                  hintText: 'Amount',
                ),
                AddScreenTextFieldWidget(
                  controller: transactionController.dateController,
                  validatorText: 'Date',
                  hintText: 'Date',
                  readOnly: true,
                ),
                CustomButton(
                  text: 'Save',
                  ontap: () async {
                    if (transactionController.formKey.currentState!
                        .validate()) {
                      await transactionController
                          .addorEditTransaction(
                        transactionController.amountController,
                        transactionController.dateController,
                        transactionController.desController,
                        widget.type,
                        widget.transactionModal,
                        context,
                      )
                          .then((value) async {
                        dropDownController.dropDownValue = 'ALL';
                        dropDownController.customDropDownValue = 'ONE WEEK';
                      });
                    }
                  },
                ),
                sBoxH10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
