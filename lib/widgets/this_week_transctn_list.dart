import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';
import 'package:money_manager/getx/get_x.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';

class CustomTransactionList extends StatelessWidget {
  CustomTransactionList({
    Key? key,
    required this.foundData,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;
  final RxList foundData;

  final DropDownController dropDownController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sBoxH10,
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            isDense: true,
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
          value: dropDownController.customDropDownValue.value,
          items: ['ONE WEEK', 'ONE MONTH', 'ONE YEAR']
              .map(
                (value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: appBodyTextStyle,
                  ),
                ),
              )
              .toList(),
          onChanged: (String? newValue) async {
            dropDownController.customDropDownValue.value = newValue!;
            await dropDownController.customFilter(tabController: tabController);
            dropDownController.rebuildList.value =
                !dropDownController.rebuildList.value;
          },
        ),
        Obx(
          () => dropDownController.foundData.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('No Transactions'),
                  ),
                )
              : dropDownController.rebuildList.value
                  ? listView(dropDownController)
                  : listView(dropDownController),
        ),
      ],
    );
  }

  Expanded listView(DropDownController dropDownController) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 1,
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    bottomLeft: Radius.circular(5.r),
                  ),
                  onPressed: (context) {
                    _showPopUp(dropDownController.foundData, index, context);
                  },
                  backgroundColor: Colors.red,
                  label: 'Delete',
                  icon: Icons.delete,
                ),
                SlidableAction(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r),
                  ),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AddTransactionScreen(
                          type: ScreenAction.editScreen,
                          transactionModal: dropDownController.foundData[index],
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.blueGrey,
                  label: 'Edit',
                  icon: Icons.edit,
                )
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    dropDownController.foundData[index].type ==
                            CategoryType.income
                        ? Icons.arrow_circle_up
                        : Icons.arrow_circle_down,
                    color: dropDownController.foundData[index].type ==
                            CategoryType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
              title: Text(
                dropDownController.foundData[index].categoryModal.name,
                style: appBodyTextStyle,
              ),
              trailing: Text(
                "₹ ${dropDownController.foundData[index].amount.round()}",
                style: homeAmountStyle,
              ),
              subtitle: Text(
                DateFormat.yMMMMd()
                    .format(dropDownController.foundData[index].date),
                style: homeDateStyle,
              ),
            ),
          );
        },
        itemCount: dropDownController.foundData.length,
      ),
    );
  }

  void _showPopUp(
      List<TransactionModal> value, int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) setNewState) {
          return AlertDialog(
            title: const Text('Are you sure ?'),
            content: const Text('Do you want to delete ?'),
            actions: [
              TextButton(
                onPressed: () {
                  setNewState(() {
                    value[index].delete().whenComplete(() => dropDownController
                        .customFilter(tabController: tabController));

                    TransactionDbFunctions().refreshUi();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Transaction deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
            ],
          );
        });
      },
    );
  }
}
