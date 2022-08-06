import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModal {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isDeleted;
  @HiveField(3)
  final CategoryType? type;

  CategoryModal({
    required this.id,
    required this.name,
    this.type,
    this.isDeleted = false,
  });
}
