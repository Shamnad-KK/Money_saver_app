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
import 'package:money_manager/constants/enums.dart';
import 'package:provider/provider.dart';

class TodayTransactionList extends StatelessWidget {
  const TodayTransactionList({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final dropDownController = Provider.of<DropDownController>(context);
    return dropDownController.foundData.isEmpty
        ? const Center(
            child: Center(
              child: Text('No Transactions'),
            ),
          )
        : listView(dropDownController);
  }

  ListView listView(DropDownController dropDownController) {
    return ListView.builder(
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
                  _showPopUp(dropDownController, dropDownController.foundData,
                      index, context);
                },
                backgroundColor: Colors.red,
                label: 'Delete',
                icon: Icons.delete,
              ),
              SlidableAction(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r)),
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
              '₹ ${dropDownController.foundData[index].amount.round()}',
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
                        .allFilter(tabController: tabController));
                    transactionController.refreshUi();
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
