import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/database/models/category_model/category_model.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';
import 'package:money_manager/widgets/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ScreenAction {
  addScreen,
  editScreen,
}

class AddTransactionScreen extends StatefulWidget {
  AddTransactionScreen({
    Key? key,
    required this.type,
    this.transactionModal,
  }) : super(key: key);
  ScreenAction type;
  TransactionModal? transactionModal;
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final formKey = GlobalKey<FormState>();
  String? amountType;
  String? dropDownValue;
  CategoryType? categoryType;
  CategoryModal? categoryModal;

  final DateTime currentDate = DateTime.now();
  DateTime? _selectedDate;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<CategoryModal> names = CategoryDbFunctions.allCategoryNotifier.value;

  Future<void> _showDate() async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  @override
  void initState() {
    CategoryDbFunctions().refreshUi();
    if (widget.type == ScreenAction.editScreen) {
      //dropDownValue = widget.transactionModal?.categoryModal.name;
      categoryModal = widget.transactionModal?.categoryModal;
      categoryType = widget.transactionModal!.type;
      amountController.text = widget.transactionModal!.amount.toString();
      dateController.text =
          DateFormat('yMMMMd').format(widget.transactionModal!.date);
    } else {
      categoryType = CategoryType.income;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
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
                          groupValue: categoryType,
                          onChanged: (value) {
                            setState(
                              () {
                                //categoryType = value as CategoryType;
                                //oR
                                categoryType = CategoryType.income;
                                dropDownValue = null;
                              },
                            );
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
                          groupValue: categoryType,
                          onChanged: (value) {
                            setState(
                              () {
                                //categoryType = value as CategoryType;
                                //oR
                                categoryType = CategoryType.expense;
                                dropDownValue = null;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                sBoxH20,
                ValueListenableBuilder(
                  builder: (BuildContext context, List<CategoryModal> value,
                      Widget? child) {
                    return DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return 'Category type cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: widget.type == ScreenAction.addScreen
                            ? categoryType == CategoryType.income
                                ? CategoryDbFunctions
                                        .incomeModalNotifier.value.isEmpty
                                    ? 'Please add category'
                                    : 'Choose  category'
                                : CategoryDbFunctions
                                        .expenseModalNotifier.value.isEmpty
                                    ? 'Please add category'
                                    : 'Choose  category'
                            : widget.transactionModal?.type == categoryType
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
                      value: dropDownValue,
                      onChanged: (newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                      items: categoryType == CategoryType.income
                          ? value
                              .map(
                                (modal) => DropdownMenuItem<String>(
                                  onTap: () {
                                    categoryModal = modal;
                                  },
                                  value: modal.id.toString(),
                                  child: Text(
                                    modal.name,
                                    style: appBodyTextStyle,
                                  ),
                                ),
                              )
                              .toList()
                          : value
                              .map(
                                (modal) => DropdownMenuItem<String>(
                                  onTap: () {
                                    categoryModal = modal;
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
                  valueListenable: categoryType == CategoryType.income
                      ? CategoryDbFunctions.incomeModalNotifier
                      : CategoryDbFunctions.expenseModalNotifier,
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
                        await _showDate();
                        setState(
                          () {
                            if (_selectedDate != null) {
                              dateController.text =
                                  DateFormat('yMMMMd').format(_selectedDate!);
                            }
                          },
                        );
                      },
                      child: const Icon(
                        Icons.calendar_month_sharp,
                      ),
                    ),
                  ),
                ),
                LargeButton(
                  text: 'Save',
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      await addTransaction();
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
    if (categoryModal == null ||
        amountController.text.isEmpty ||
        dateController.text.isEmpty ||
        categoryType == null) {
      return;
    } else {
      final amounttext = amountController.text;
      final parsedAmount = num.tryParse(amounttext);
      //final parsedDate = DateFormat.yMMMMd().format(_selectedDate!);
      _selectedDate ??= widget.transactionModal?.date;
      final transactionModal = TransactionModal(
          amount: parsedAmount!,
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          categoryModal: categoryModal!,
          date: _selectedDate!,
          type: categoryType!);
      if (widget.type == ScreenAction.addScreen) {
        await TransactionDbFunctions().addTransaction(transactionModal);
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const BottomNavBar(),
          ),
          (route) => false);
    }
  }
}
