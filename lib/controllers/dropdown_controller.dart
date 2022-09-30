import 'package:flutter/material.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/dropdown_repository.dart';

class DropDownController extends ChangeNotifier {
  String dropDownValue = 'ALL';
  String customDropDownValue = 'ONE WEEK';

  void setFoundData(List<TransactionModal> newFoundData) {
    _foundData = newFoundData;
  }

  List<TransactionModal> _foundData = [];

  List<TransactionModal> get foundData => _foundData;

  List<TransactionModal> allData = TransactionRepository.allTransactionNotifier;

  Widget homeDrop(TabController tabController) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        alignment: Alignment.centerRight,
        elevation: 16,
        value: dropDownValue,
        items: <String>[
          'ALL',
          'INCOME',
          'EXPENSE',
        ]
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: appLargeTextStyle,
                ),
              ),
            )
            .toList(),
        onChanged: (String? newValue) async {
          dropDownValue = newValue!;
          await allFilter(tabController: tabController);
          if (tabController.index == 2) {
            await customFilter(tabController: tabController);
          }
          notifyListeners();
        },
      ),
    );
  }

  Future<void> allFilter({required TabController tabController}) async {
    List<TransactionModal> results = <TransactionModal>[];
    setFoundData(allData);
    _foundData = await DropDownRepository().allFilter(
      dropDownValue,
      allData,
      _foundData,
      tabController,
      results,
    );
    notifyListeners();
  }

  Future<void> customFilter({required TabController tabController}) async {
    List<TransactionModal> results = <TransactionModal>[];
    setFoundData(allData);
    _foundData = await DropDownRepository().customFilter(
      results,
      allData,
      foundData,
      customDropDownValue,
      dropDownValue,
      tabController,
    );
    notifyListeners();
  }
}
