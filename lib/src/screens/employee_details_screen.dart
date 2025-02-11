import 'package:employee_management/src/bloc/employee_bloc.dart';
import 'package:employee_management/src/config/text_styles/app_text_styles.dart';
import 'package:employee_management/src/config/theme/app_colors.dart';
import 'package:employee_management/src/config/utils/formatter.dart';
import 'package:employee_management/src/models/employee.dart';
import 'package:employee_management/src/widgets/custom_button.dart';
import 'package:employee_management/src/widgets/custom_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  /// optional employee to be passed for edit purpose
  final Employee? employee;

  /// callback to delete an employee will editing
  final void Function()? onDelete;

  /// Reusable screen to add or edit the employees' data
  const EmployeeDetailsScreen({
    super.key,
    this.employee,
    this.onDelete,
  }) : assert(!(employee != null && onDelete == null), "Can't have onDelete null while editing the Employee");

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _roleController.text = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee!.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.employee == null ? 'Add Employee Details' : 'Edit Employee Details',
          style: AppTextStyles.robotoF18(
            color: AppColors.whiteColor,
            weight: FontWeight.w500,
          ).copyWith(fontSize: 18),
        ),

        //show delete button if editing
        actions: widget.employee == null
            ? []
            : [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onDelete,
                  icon: const Icon(
                    CupertinoIcons.trash,
                    size: 14,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
      ),

      //main content
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: AppColors.whiteColor,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 23,
                  children: [
                    //name field
                    _buildInputField(
                      icon: Icons.person_outline,
                      hint: 'Employee name',
                      controller: _nameController,
                    ),

                    // role field
                    _buildDropdownField(
                      icon: Icons.work_outline,
                      value: _roleController.text,
                      onTap: () => openRoleSheet(
                        onChanged: (String? value) {
                          setState(() {
                            _roleController.text = value ?? '';
                          });
                        },
                        items: const [
                          'Product Designer',
                          'Flutter Developer',
                          'QA Tester',
                          'Product Owner',
                        ],
                      ),
                    ),

                    // date selection field
                    Row(
                      spacing: 16,
                      children: [
                        //start date
                        Expanded(
                          child: _buildDateField(
                            date: _startDate,
                            hint: 'Start date',
                            onTap: () async {
                              final date = await _selectDate(
                                context,
                                _startDate,
                                false,
                                null,
                              );
                              if (date != null) {
                                setState(() => _startDate = date);
                              }
                            },
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),

                        //end date
                        Expanded(
                          child: _buildDateField(
                            date: _endDate,
                            hint: 'No date',
                            onTap: () async {
                              final date = await _selectDate(
                                context,
                                _endDate,
                                true,
                                _startDate,
                              );
                              if (date != null) {
                                setState(() => _endDate = date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundColor,
            height: 1,
          ),

          //Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: "Cancel",
                  isSelected: false,
                  constraints: const BoxConstraints(minWidth: 73, minHeight: 40),
                  ontap: () => Navigator.pop(context),
                ),
                16.horizontalSpaceRadius,
                CustomButton(
                  text: "Save",
                  isSelected: true,
                  constraints: const BoxConstraints(minWidth: 73, minHeight: 40),
                  ontap: _saveEmployee,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24,
          ),
          Expanded(
            child: SizedBox(
              height: 24,
              child: TextField(
                style: AppTextStyles.robotoF16(
                  color: AppColors.textColor,
                  weight: FontWeight.w400,
                ).copyWith(fontSize: 16),
                controller: controller,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [
                  AutofillHints.name
                ],
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.robotoF16(
                    color: AppColors.hintColor,
                    weight: FontWeight.w400,
                  ).copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String value,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 24,
            ),
            Expanded(
              child: Text(
                value.isEmpty ? "Select role" : value,
                style: AppTextStyles.robotoF16(
                  color: value.isEmpty ? AppColors.hintColor : AppColors.textColor,
                  weight: FontWeight.w400,
                ).copyWith(fontSize: 16),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void openRoleSheet({
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          color: AppColors.whiteColor,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.backgroundColor,
            height: 1,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              onChanged(items[index]);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  items[index],
                  style: AppTextStyles.robotoF16(
                    color: AppColors.textColor,
                    weight: FontWeight.w400,
                  ).copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/calendar.svg",
              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              height: 19.2,
            ),
            const SizedBox(width: 9.68),
            Flexible(
              child: Text(
                date != null ? getFormattedDate(date) : hint,
                style: AppTextStyles.robotoF14(
                  color: date == null ? AppColors.hintColor : AppColors.textColor,
                  weight: FontWeight.w400,
                ).copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? initialDate, bool isEndDateDialog, DateTime? startingDate) async {
    return showDialog<DateTime?>(
      context: context,
      builder: (context) => UnconstrainedBox(
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 396.sp > 700 ? 700 : 396.sp,
            child: CustomDatePicker(
              isEndDateDialog: isEndDateDialog,
              initialDate: initialDate ?? DateTime.now(),
              onDateSelected: (date) {
                Navigator.pop(context, date);
              },
              startingDate: startingDate,
            ),
          ),
        ),
      ),
    );
  }

  // callback to be used when saving data
  void _saveEmployee() {
    if (_nameController.text.trim().isEmpty || _roleController.text.isEmpty || _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // can't have end date on/before start date
    if (_endDate != null && _startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    final employee = Employee(
      id: widget.employee?.id,
      name: _nameController.text,
      role: _roleController.text,
      startDate: _startDate!,
      endDate: _endDate,
    );

    if (widget.employee == null) {
      // add employee
      context.read<EmployeeBloc>().add(AddEmployee(employee));
    } else {
      // update the employee
      context.read<EmployeeBloc>().add(UpdateEmployee(employee));
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }
}
