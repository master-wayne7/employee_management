import 'package:employee_management/src/models/employee.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Offline storage repository with basic CRUD operations
class StorageRepository {
  static const String boxName = 'employees';

  /// initialize the box
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EmployeeAdapter());
    await Hive.openBox<Employee>(boxName);
  }

  /// Add a new employee to DB (Create)
  Future<void> addEmployee(Employee employee) async {
    final box = Hive.box<Employee>(boxName);
    await box.put(employee.id, employee);
  }

  /// Fetch all the data (Read)
  Future<List<Employee>> getAllEmployees() async {
    final box = Hive.box<Employee>(boxName);
    return box.values.toList();
  }

  /// Update the existing employee (Update)
  Future<void> updateEmployee(Employee employee) async {
    final box = Hive.box<Employee>(boxName);
    await box.put(employee.id, employee);
  }

  /// Delete any employee (Delete)
  Future<void> deleteEmployee(String id) async {
    final box = Hive.box<Employee>(boxName);
    await box.delete(id);
  }
}
