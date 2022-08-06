import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/models/reminder_model/reminder_model.dart';

class ReminderDbFunctions {
  static final ValueNotifier<List<ReminderModel>> reminderModel =
      ValueNotifier([]);

  Future<void> addReminder(ReminderModel modal) async {
    final reminderDB = await Hive.openBox<ReminderModel>(reminderDbName);
    reminderDB.add(modal);
    //reminderModel.value.clear();
    reminderModel.value.add(modal);
    reminderModel.notifyListeners();
  }
}
