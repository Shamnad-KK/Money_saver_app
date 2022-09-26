import 'package:money_manager/models/transaction/transaction_model.dart';

class SearchRepository {
  List<TransactionModal> searchQuery(String query,
      List<TransactionModal> foundList, List<TransactionModal> allData) {
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
    return foundList;
  }
}
