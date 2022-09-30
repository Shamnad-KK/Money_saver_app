import 'package:flutter/material.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:provider/provider.dart';

class AddAlertDialogueWidget extends StatelessWidget {
  const AddAlertDialogueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryDBController>(context, listen: false);
    return AlertDialog(
      title: categoryProvider.tabController.index == 0
          ? const Text(
              'Enter Income Category',
            )
          : const Text(
              'Enter Expense Category',
            ),
      content: Form(
        key: categoryProvider.formKey,
        child: TextFormField(
          controller: categoryProvider.categoryNameController,
          validator: (value) {
            return categoryProvider.addScreenValidate(value);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await categoryProvider.validated(context);
          },
          child: const Text(
            'Add',
          ),
        ),
      ],
    );
  }
}
