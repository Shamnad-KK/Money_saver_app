import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/repository/search_repository.dart';
import 'package:money_manager/utils/delete_alert_dialogue.dart';
import 'package:money_manager/utils/snackbars.dart';

class SearchingController extends ChangeNotifier {
  final TextEditingController searchTextController = TextEditingController();
  List<TransactionModal> _foundList = [];
  List<TransactionModal> get foundList => _foundList;

  Future<void> searchQuery(String query) async {
    final List<TransactionModal> allData =
        await TransactionRepository().refreshUi();
    _foundList = SearchRepository().searchQuery(query, _foundList, allData);
    notifyListeners();
  }

  Future<void> deleteFromSearch(
      TransactionModal modal, BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return DeleteAlertDialogue(ontap: () async {
            final navContext = Navigator.of(context);
            await modal.deleteTransaction(modal);
            SnackBars.customSnackbar('Transaction deleted');
            navContext.pop();
            searchTextController.clear();
            await searchQuery('');
          });
        });
    notifyListeners();
  }
}
