import 'package:hive_flutter/adapters.dart';
part 'reminder_model.g.dart';

@HiveType(typeId: 4)
class ReminderModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String time;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String body;

  ReminderModel({
    this.id,
    required this.date,
    required this.time,
    required this.title,
    required this.body,
  });
}
