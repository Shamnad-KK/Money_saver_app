import 'package:flutter/foundation.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/search_repository.dart';

class SearchController extends ChangeNotifier {
  final List<TransactionModal> _foundList = [];
  List<TransactionModal> get foundList => _foundList;

  void searchQuery(String query) {
    SearchRepository().searchQuery(query, _foundList);
    notifyListeners();
  }
}
