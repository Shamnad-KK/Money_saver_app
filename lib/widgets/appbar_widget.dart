import 'package:flutter/material.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);
  final String? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                transactionController.setDropDownValue(null);
                transactionController.setCategoryModel(null);
                transactionController.setCategoryType(CategoryType.income);
                transactionController.selectedDate = null;
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 28,
              ),
            )
          : null,
      backgroundColor: mainColor,
      title: Text(
        leading ?? '',
        style: appBarTextStyle,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
