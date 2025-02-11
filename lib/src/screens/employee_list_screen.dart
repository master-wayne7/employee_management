import 'package:employee_management/src/bloc/employee_bloc.dart';
import 'package:employee_management/src/config/text_styles/app_text_styles.dart';
import 'package:employee_management/src/config/utils/formatter.dart';
import 'package:employee_management/src/models/employee.dart';
import 'package:employee_management/src/screens/employee_details_screen.dart';
import 'package:employee_management/src/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EmployeeListScreen extends StatelessWidget {
  /// the main screen of the app
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee List',
          style: AppTextStyles.robotoF18(
            color: AppColors.whiteColor,
            weight: FontWeight.w500,
          ).copyWith(fontSize: 18),
        ),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            // Loading state
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              // if no employees are there then show placeholder
              return _buildPlaceHolder();
            }

            // build content if not empty
            return _buildContent(state);
          } else if (state is EmployeeError) {
            // if there is an error then show error message
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),

      // Add button
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EmployeeDetailsScreen(),
          ),
        ),
        child: const Icon(
          Icons.add,
          size: 18,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  /// Placeholder widget to show an illustration with the text
  Widget _buildPlaceHolder() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_record.png',
              width: 261.79.sp,
              height: 218.85.sp,
            ),
            Text(
              'No employee records found',
              style: AppTextStyles.robotoF18(
                color: AppColors.textColor,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// This widget is responsible to show the employees data
  Widget _buildContent(EmployeeLoaded state) {
    return Builder(builder: (context) {
      final now = DateTime.now();
      final currentEmployees = state.employees.where((e) => e.endDate == null || e.endDate!.isAfter(now)).toList();
      final previousEmployees = state.employees.where((e) => e.endDate != null && !e.endDate!.isAfter(now)).toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Employees (with endDate after now or no endDate)
            if (currentEmployees.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Current employees',
                  style: AppTextStyles.robotoF16(
                    weight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ).copyWith(fontSize: 16, height: 24 / 16),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: currentEmployees.length,
                itemBuilder: (context, index) {
                  return _buildEmployeeListTile(context, currentEmployees[index], false);
                },
              ),
            ],

            // Previous Employees (with endDate before or equal to now)
            if (previousEmployees.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Previous employees',
                  style: AppTextStyles.robotoF16(
                    weight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ).copyWith(fontSize: 16, height: 24 / 16),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: previousEmployees.length,
                itemBuilder: (context, index) {
                  return _buildEmployeeListTile(context, previousEmployees[index], true);
                },
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                "Swipe left to delete",
                style: AppTextStyles.robotoF15(weight: FontWeight.w400, color: AppColors.hintColor).copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// callback to delete any employee and show the undo button
  void deleteEmployee(Employee employee, BuildContext context) {
    // Store bloc reference
    final employeeBloc = context.read<EmployeeBloc>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    employeeBloc.add(DeleteEmployee(employee.id));

    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              'Employee data has been deleted',
              style: AppTextStyles.robotoF15(weight: FontWeight.w400, color: AppColors.whiteColor).copyWith(fontSize: 15),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                employeeBloc.add(AddEmployee(employee));
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                'Undo',
                style: AppTextStyles.robotoF15(weight: FontWeight.w400, color: AppColors.primaryColor).copyWith(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// common reusable list tile with swipable actions
  Widget _buildEmployeeListTile(BuildContext context, Employee employee, bool isPreviousEmployee) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 100 / MediaQuery.sizeOf(context).width,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) => deleteEmployee(employee, context),
            backgroundColor: AppColors.redColor,
            foregroundColor: AppColors.whiteColor,
            icon: CupertinoIcons.trash,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        tileColor: AppColors.whiteColor,
        title: Text(
          employee.name,
          style: AppTextStyles.robotoF16(
            weight: FontWeight.w500,
            color: AppColors.textColor,
          ).copyWith(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            0.verticalSpacingRadius,
            Text(
              employee.role,
              style: AppTextStyles.robotoF14(
                weight: FontWeight.w400,
                color: AppColors.hintColor,
              ).copyWith(fontSize: 14),
            ),
            Text(
              !isPreviousEmployee ? 'From ${getFormattedDate(employee.startDate)}' : "${getFormattedDate(employee.startDate)} - ${getFormattedDate(employee.endDate!)}",
              style: AppTextStyles.robotoF14(
                weight: FontWeight.w400,
                color: AppColors.hintColor,
              ).copyWith(fontSize: 14),
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsScreen(
              employee: employee,
              onDelete: () {
                deleteEmployee(employee, context);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
