import 'package:employee_management/src/config/text_styles/app_text_styles.dart';
import 'package:employee_management/src/config/theme/app_colors.dart';
import 'package:employee_management/src/config/utils/formatter.dart';
import 'package:employee_management/src/widgets/custom_button.dart';
import 'package:employee_management/src/widgets/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDatePicker extends StatefulWidget {
  /// Initial date from which the date picker should start
  final DateTime initialDate;

  /// Method to be run when the value is changed
  final ValueChanged<DateTime?> onDateSelected;

  /// To distinguish between the end and start dialog box
  final bool isEndDateDialog;

  /// For end dialog
  /// This will not allow user to select any date before the starting date
  final DateTime? startingDate;

  /// Customized date picker dialog box widget
  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.isEndDateDialog = false,
    this.startingDate,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  /// This will build the top buttons for quick selections
  Widget _buildQuickSelectButton(String text, DateTime? date) {
    final isSelected = selectedDate?.year == date?.year && selectedDate?.month == date?.month && selectedDate?.day == date?.day;

    return Expanded(
      child: CustomButton(
        text: text,
        constraints: const BoxConstraints(minHeight: 36),
        isSelected: isSelected,
        ontap: () => setState(
          () {
            selectedDate = date;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        // build no date for ending dialog
                        if (widget.isEndDateDialog) _buildQuickSelectButton('No date', null),
                        _buildQuickSelectButton('Today', DateTime.now().toLocal()),

                        // not to build the next monday button for end dialog
                        if (!widget.isEndDateDialog)
                          _buildQuickSelectButton(
                            'Next Monday',
                            DateTime.now()
                                .add(
                                  Duration(days: (DateTime.now().weekday >= DateTime.monday) ? 7 - (DateTime.now().weekday - DateTime.monday) : DateTime.monday - DateTime.now().weekday),
                                )
                                .toLocal(),
                          ),
                      ],
                    ),

                    // not to build the next day button for end dialog
                    if (!widget.isEndDateDialog)
                      Row(
                        spacing: 16,
                        children: [
                          _buildQuickSelectButton(
                            'Next Tuesday',
                            DateTime.now()
                                .add(
                                  Duration(days: (DateTime.now().weekday >= DateTime.tuesday) ? 7 - (DateTime.now().weekday - DateTime.tuesday) : DateTime.tuesday - DateTime.now().weekday),
                                )
                                .toLocal(),
                          ),
                          _buildQuickSelectButton(
                            'After 1 week',
                            DateTime.now().add(const Duration(days: 7)),
                          ),
                        ],
                      ),
                  ],
                ),
                24.verticalSpacingRadius,

                // customized calendar widget for picking the dates
                SizedBox(
                  height: 320.r,
                  child: CustomCalendarDatePicker(
                    // key will help in updating the state of widget with change in selectedDate
                    key: ValueKey(selectedDate),
                    initialDate: selectedDate,
                    firstDate: widget.isEndDateDialog ? widget.startingDate ?? widget.initialDate : DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.backgroundColor,
            height: 1,
          ),

          // footer row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // will show the current selected date with the proper format
                SvgPicture.asset(
                  "assets/svg/calendar.svg",
                  colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  height: 23,
                ),
                12.horizontalSpaceRadius,
                Expanded(
                  child: Text(
                    selectedDate != null ? getFormattedDate(selectedDate!) : "No date",
                    style: AppTextStyles.robotoF16(
                      color: AppColors.textColor,
                      weight: FontWeight.w400,
                    ).copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // footer button for canceling the selection
                CustomButton(
                  text: "Cancel",
                  isSelected: false,
                  constraints: const BoxConstraints(minWidth: 73, minHeight: 40),
                  ontap: () {
                    Navigator.pop(context);
                  },
                ),

                16.horizontalSpaceRadius,

                // footer button for saving the selected date
                CustomButton(
                  text: "Save",
                  isSelected: true,
                  constraints: const BoxConstraints(minWidth: 73, minHeight: 40),
                  ontap: () {
                    widget.onDateSelected(selectedDate);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
