import 'package:hive/hive.dart';
part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime? endDate;

  Employee({
    String? id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
