import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/view/add_transaction_screen/add_transaction_screen.dart';
import 'package:provider/provider.dart';

class CustomTransactionList extends StatelessWidget {
  const CustomTransactionList({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final dropDownController = Provider.of<DropDownController>(context);
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
          value: dropDownController.customDropDownValue,
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
            dropDownController.customDropDownValue = newValue!;
            await dropDownController.customFilter(tabController: tabController);
          },
        ),
        Consumer2<DropDownController, TransactionController>(
          builder: (BuildContext context, value,
              TransactionController transactionController, Widget? child) {
            return transactionController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : value.foundData.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text('No Transactions'),
                        ),
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
                                  onPressed: (_) async {
                                    await transactionController.confirmDelete(
                                        context, index, value.foundData);
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
                                          transactionModal:
                                              value.foundData[index],
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
                                    value.foundData[index].type ==
                                            CategoryType.income
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
                                "₹ ${value.foundData[index].amount.round()}",
                                style: homeAmountStyle,
                              ),
                              subtitle: Text(
                                DateFormat.yMMMMd()
                                    .format(value.foundData[index].date),
                                style: homeDateStyle,
                              ),
                            ),
                          );
                        },
                        itemCount: value.foundData.length,
                      );
          },
        ),
      ],
    );
  }
}
