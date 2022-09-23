import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<TransactionModal> transactionModel =
      TransactionDbFunctions.allTransactionNotifier;

  List<TransactionModal> foundList = [];

  void runFilter(String enteredKeyword) {
    List<TransactionModal> results = [];
    if (enteredKeyword.isEmpty) {
      results = transactionModel;
    } else {
      results = transactionModel
          .where(
            (element) => element.categoryModal.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      foundList = results;
    });
  }

  @override
  void initState() {
    foundList = transactionModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        leading: 'Search',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            top: 20.h,
            right: 20.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: whiteColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hintText: 'Search...',
                  ),
                  onChanged: (value) => runFilter(value),
                ),
                sBoxH10,
                foundList.isNotEmpty
                    ? ListView.builder(
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
                                        _showPopUp(foundList, index);
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
                                    const SnackBar(
                                      content: Text('loading'),
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
                                foundList[index].type == CategoryType.income
                                    ? Icons.arrow_circle_up
                                    : Icons.arrow_circle_down,
                                color:
                                    foundList[index].type == CategoryType.income
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              title: Text(
                                foundList[index].categoryModal.name,
                                style: appBodyTextStyle,
                              ),
                              trailing: Text(
                                '₹${foundList[index].amount}',
                                style: homeAmountStyle,
                              ),
                              subtitle: Text(
                                DateFormat.yMMMMd()
                                    .format(foundList[index].date),
                                style: homeDateStyle,
                              ),
                            ),
                          );
                        },
                        itemCount: foundList.length,
                      )
                    : const Center(
                        child: Text('No data found'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopUp(List<TransactionModal> value, int index) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text('Do you want to delete ?'),
          actions: [
            TextButton(
              onPressed: () {
                TransactionDbFunctions().deleteTransaction(value[index].id);
                setState(() {
                  TransactionDbFunctions.allTransactionNotifier.removeAt(index);
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
      },
    );
  }
}
