import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/database/transaction_db_functions.dart';

class SearchRepository {
  final List<TransactionModal> allData =
      TransactionDbFunctions.allTransactionNotifier;

  void searchQuery(String query, List<TransactionModal> foundList) {
    List<TransactionModal> results = [];

    if (query.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where((element) => element.categoryModal.name
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase().trim()))
          .toList();
    }
    foundList = results;
  }
}
