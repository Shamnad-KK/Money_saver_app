import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';
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
  // String? amountType;
  //String? dropDownValue;
  //CategoryType? categoryType;
  //CategoryModal? categoryModal;

  //final DateTime currentDate = DateTime.now();
  final formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("add screen called");
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    final categoryController = Provider.of<CategoryDBController>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryController.refreshUi();
      if (widget.type == ScreenAction.editScreen) {
        //dropDownValue = widget.transactionModal?.categoryModal.name;
        transactionController
            .setCategoryModel(widget.transactionModal?.categoryModal);
        //categoryModal = widget.transactionModal?.categoryModal;
        transactionController.setCategoryType(widget.transactionModal!.type);
        amountController.text = widget.transactionModal!.amount.toString();
        dateController.text =
            DateFormat('yMMMMd').format(widget.transactionModal!.date);
      }
    });
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
            key: formKey,
            child: Column(
              children: [
                Consumer<TransactionController>(builder: (BuildContext context,
                    TransactionController transactionValue, Widget? child) {
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
                            groupValue: transactionController.categoryType,
                            onChanged: (value) {
                              transactionController
                                  .setCategoryType(CategoryType.income);
                              transactionController.setDropDownValue(null);
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
                            groupValue: transactionController.categoryType,
                            onChanged: (value) {
                              transactionController
                                  .setCategoryType(CategoryType.expense);
                              transactionController.setDropDownValue(null);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                sBoxH20,
                Consumer2<TransactionController, CategoryDBController>(
                  builder: (BuildContext context, transactionvalue,
                      categoryValue, Widget? child) {
                    return DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return 'Category type cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: widget.type == ScreenAction.addScreen
                            ? transactionvalue.categoryType ==
                                    CategoryType.income
                                ? categoryValue.incomeModalNotifier.isEmpty
                                    ? 'Please add category'
                                    : 'Choose  category'
                                : categoryValue.expenseModalNotifier.isEmpty
                                    ? 'Please add category'
                                    : 'Choose  category'
                            : widget.transactionModal?.type ==
                                    transactionvalue.categoryType
                                ? widget.transactionModal!.categoryModal.name
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
                      value: transactionvalue.dropDownValue,
                      onChanged: (newValue) {
                        transactionController.setDropDownValue(newValue);
                        // setState(() {
                        //   dropDownValue = newValue;
                        // });
                      },
                      items:
                          transactionvalue.categoryType == CategoryType.income
                              ? categoryValue.incomeModalNotifier
                                  .map(
                                    (modal) => DropdownMenuItem<String>(
                                      onTap: () {
                                        transactionController
                                            .setCategoryModel(modal);
                                        // categoryModal = modal;
                                      },
                                      value: modal.id.toString(),
                                      child: Text(
                                        modal.name,
                                        style: appBodyTextStyle,
                                      ),
                                    ),
                                  )
                                  .toList()
                              : categoryValue.expenseModalNotifier
                                  .map(
                                    (modal) => DropdownMenuItem<String>(
                                      onTap: () {
                                        transactionController
                                            .setCategoryModel(modal);
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
                  },
                ),
                sBoxH20,
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(?:-\d+)?$'),
                    )
                  ],
                  controller: amountController,
                  validator: (value) {
                    if (value == '') {
                      return 'Amount cannot be empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Amount',
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
                ),
                sBoxH20,
                TextFormField(
                  controller: dateController,
                  validator: (value) {
                    if (value == '') {
                      return 'Date cannot be empty';
                    }
                    return null;
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Date',
                    hintStyle: appBodyTextStyle,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: blackColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        await transactionController.showDate(context);

                        if (transactionController.selectedDate != null) {
                          dateController.text = DateFormat('yMMMMd')
                              .format(transactionController.selectedDate!);
                        }
                      },
                      child: const Icon(
                        Icons.calendar_month_sharp,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Save',
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      await addTransaction().then((value) async {
                        transactionController.setDropDownValue(null);
                        transactionController.setCategoryModel(null);
                        transactionController
                            .setCategoryType(CategoryType.income);
                        transactionController.selectedDate = null;
                        await transactionController.getAllTransactions();
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

  Future<void> addTransaction() async {
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    if (transactionController.categoryModal == null ||
        amountController.text.isEmpty ||
        dateController.text.isEmpty) {
      return;
    } else {
      final amounttext = amountController.text;
      final parsedAmount = num.tryParse(amounttext);
      //final parsedDate = DateFormat.yMMMMd().format(_selectedDate!);
      transactionController.selectedDate ??= widget.transactionModal?.date;
      final transactionModal = TransactionModal(
        amount: parsedAmount!,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        categoryModal: transactionController.categoryModal!,
        date: transactionController.selectedDate!,
        type: transactionController.categoryType,
      );
      if (widget.type == ScreenAction.addScreen) {
        await transactionController.addTransaction(transactionModal);
        if (!mounted) {}
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Transaction added'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (widget.type == ScreenAction.editScreen) {
        await widget.transactionModal?.editTransaction(transactionModal);
        if (!mounted) {}
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Transaction edited'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (!mounted) {}

      transactionController.setCategoryType(CategoryType.income);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const BottomNavBar(),
          ),
          (route) => false);
    }
  }
}
