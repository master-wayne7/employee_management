import 'package:employee_management/src/data/storage_repository.dart';
import 'package:employee_management/src/models/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'employee_event.dart';
part 'employee_state.dart';

/// Bloc responsible for the state management
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final StorageRepository _repository;

  EmployeeBloc(this._repository) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employees = await _repository.getAllEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _repository.addEmployee(event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _repository.updateEmployee(event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _repository.deleteEmployee(event.id);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}
