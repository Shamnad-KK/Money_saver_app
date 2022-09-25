import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:provider/provider.dart';

class AllTransactionList extends StatelessWidget {
  const AllTransactionList({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    log("hy");
    return Consumer<DropDownController>(
      builder: (context, DropDownController value, child) {
        if (value.isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return value.foundData.isEmpty
            ? const Center(
                child: Text('No Transactions'),
              )
            : ListView.builder(
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
                            _showPopUp(value, value.foundData, index, context);
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
                                  transactionModal: value.foundData[index],
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
                            value.foundData[index].type == CategoryType.income
                                ? Icons.arrow_circle_up
                                : Icons.arrow_circle_down,
                            color: value.foundData[index].type ==
                                    CategoryType.income
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                      title: Text(
                        value.foundData[index].categoryModal.name,
                        style: appBodyTextStyle,
                      ),
                      trailing: Text(
                        '₹${value.foundData[index].amount.round()}',
                        style: homeAmountStyle,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMd().format(value.foundData[index].date),
                        style: homeDateStyle,
                      ),
                    ),
                  );
                },
                itemCount: value.foundData.length,
              );
      },
    );
  }

  void _showPopUp(DropDownController dropDownController,
      List<TransactionModal> value, int index, BuildContext context) {
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text('Do you want to delete ?'),
          actions: [
            TextButton(
              onPressed: () async {
                value[index].delete().whenComplete(() =>
                    dropDownController.allFilter(tabController: tabController));
                transactionController.refreshUi();

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
      },
    );
  }
}
