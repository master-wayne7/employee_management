import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Common textsyles with the default roboto font
class AppTextStyles {
  static TextStyle robotoF18({Color? color, FontWeight? weight}) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18.sp,
        color: color,
        fontWeight: weight,
        height: 21.09 / 18,
      );
  static TextStyle robotoF16({Color? color, FontWeight? weight}) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.sp,
        color: color,
        fontWeight: weight,
        height: 20 / 16,
      );
  static TextStyle robotoF15({Color? color, FontWeight? weight}) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15.sp,
        color: color,
        fontWeight: weight,
        height: 20 / 15,
      );
  static TextStyle robotoF14({Color? color, FontWeight? weight}) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14.sp,
        color: color,
        fontWeight: weight,
        height: 20 / 14,
      );
}
