import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/search_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchController =
        Provider.of<SearchController>(context, listen: false);
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await transactionController.refreshUi();
      searchController.searchQuery('');
    });
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
                  onChanged: (value) => searchController.searchQuery(value),
                ),
                sBoxH10,
                Consumer<SearchController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.foundList.isNotEmpty
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
                                            _showPopUp(value.foundList, index);
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
                                    value.foundList[index].type ==
                                            CategoryType.income
                                        ? Icons.arrow_circle_up
                                        : Icons.arrow_circle_down,
                                    color: value.foundList[index].type ==
                                            CategoryType.income
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    value.foundList[index].categoryModal.name,
                                    style: appBodyTextStyle,
                                  ),
                                  trailing: Text(
                                    '₹${value.foundList[index].amount}',
                                    style: homeAmountStyle,
                                  ),
                                  subtitle: Text(
                                    DateFormat.yMMMMd()
                                        .format(value.foundList[index].date),
                                    style: homeDateStyle,
                                  ),
                                ),
                              );
                            },
                            itemCount: value.foundList.length,
                          )
                        : const Center(
                            child: Text('No data found'),
                          );
                  },
                )
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
