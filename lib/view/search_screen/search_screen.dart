import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/search_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/view/add_transaction_screen/add_transaction_screen.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController =
        Provider.of<SearchingController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<SearchingController>().searchQuery('');
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
                  controller: searchController.searchTextController,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: whiteColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hintText: 'Search...',
                  ),
                  onChanged: (_) => context
                      .read<SearchingController>()
                      .searchQuery(searchController.searchTextController.text),
                ),
                sBoxH10,
                Consumer<SearchingController>(
                  builder: (BuildContext context, SearchingController value,
                      Widget? child) {
                    return value.foundList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
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
                                      onPressed: (_) async {
                                        await value.deleteFromSearch(
                                            value.foundList[index], ctx);
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
                                            builder: (ctx) =>
                                                AddTransactionScreen(
                                              type: ScreenAction.editScreen,
                                              transactionModal:
                                                  value.foundList[index],
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
}
