import 'package:flutter/foundation.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/repository/search_repository.dart';

class SearchController extends ChangeNotifier {
  final List<TransactionModal> allData =
      TransactionDbFunctions.allTransactionNotifier;
  List<TransactionModal> _foundList = [];
  List<TransactionModal> get foundList => _foundList;

  void searchQuery(String query) async {
    _foundList = SearchRepository().searchQuery(query, _foundList, allData);
    notifyListeners();
  }
}
