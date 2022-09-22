import 'package:money_manager/models/transaction/transaction_model.dart';

class ChartData {
  final String name;
  final num amount;

  ChartData({required this.name, required this.amount});
}

chartSort(List<TransactionModal> modal) {
  List<ChartData> chart = [];
  List newList = [];
  int amount;
  String name;
  for (int i = 0; i < modal.length; i++) {
    newList.add(0);
  }
  for (int i = 0; i < modal.length; i++) {
    amount = modal[i].amount.toInt();
    name = modal[i].categoryModal.name;
    for (int j = i + 1; j < modal.length; j++) {
      if (name == modal[j].categoryModal.name) {
        amount += modal[j].amount.toInt();
        newList[j] = -1;
      }
    }
    if (newList[i] != -1) {
      chart.add(ChartData(name: modal[i].categoryModal.name, amount: amount));
    }
  }
  return chart;
}
