import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';

class TodayTransactionList extends StatefulWidget {
  const TodayTransactionList({
    Key? key,
    required this.valueListenable,
  }) : super(key: key);
  final ValueListenable<List<TransactionModal>> valueListenable;
  @override
  State<TodayTransactionList> createState() => _TodayTransactionListState();
}

class _TodayTransactionListState extends State<TodayTransactionList> {
  @override
  void initState() {
    TransactionDbFunctions().refreshUi();
    TransactionDbFunctions().sortTodayTransactions();
    super.initState();
  }

  static final DateTime todayDate = DateTime.now();
  final parsedDate = DateFormat.yMMMMd().format(todayDate);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder:
          (BuildContext context, List<TransactionModal> value, Widget? child) {
        if (value.isEmpty) {
          return const Center(
            child: Text('No Transactions'),
          );
        } else {
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
                        setState(
                          () {
                            _showPopUp(value, index);
                          },
                        );
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
                              type: ScreenType.editScreen,
                              transactionModal: value[index],
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
                  leading: Icon(
                    value[index].type == CategoryType.income
                        ? Icons.arrow_circle_up
                        : Icons.arrow_circle_down,
                    color: value[index].type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    value[index].name,
                    style: appBodyTextStyle,
                  ),
                  trailing: Text(
                    '₹ ${value[index].amount.round()}',
                    style: homeAmountStyle,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(value[index].date),
                    style: homeDateStyle,
                  ),
                ),
              );
            },
            itemCount: value.length,
          );
        }
      },
      valueListenable: widget.valueListenable,
    );
  }

  void _showPopUp(List<TransactionModal> value, int index) {
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
                    value[index].delete();
                    TransactionDbFunctions().refreshUi();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
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
