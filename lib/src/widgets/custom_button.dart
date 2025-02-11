import 'package:employee_management/src/config/text_styles/app_text_styles.dart';
import 'package:employee_management/src/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  /// text to be showned in the button
  final String text;

  /// if the button is highlighted/selected one
  final bool isSelected;

  /// callback to be performed when the button is tapped
  final void Function() ontap;

  /// optional Padding for the button
  final EdgeInsets? padding;

  /// optional constraints for resizing the button
  final BoxConstraints? constraints;

  /// A Reusable widget to define the structure of a button in the app
  const CustomButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.ontap,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // this will consider whole widget to be tappable
      onTap: ontap,
      child: Container(
        constraints: constraints ?? const BoxConstraints(minHeight: 36),
        padding: padding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isSelected ? AppColors.primaryColor : AppColors.primaryColorLight, borderRadius: BorderRadius.circular(4.sp)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.robotoF14(
              color: isSelected ? AppColors.whiteColor : AppColors.primaryColor,
              weight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
