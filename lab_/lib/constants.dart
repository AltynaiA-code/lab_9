import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class Constants {
  // Font sizes
  static double get headline1 => 24.sp;
  static double get headline2 => 20.sp;
  static double get bodyText1 => 16.sp;
  static double get bodyText2 => 14.sp;
  
  // Padding
  static EdgeInsetsGeometry get padding => EdgeInsets.all(16.w);

  // Spacing
  static double get smallSpacing => 8.h;
  static double get mediumSpacing => 16.h;
  static double get largeSpacing => 24.h;

  // Button height and width
  static double get buttonHeight => 50.h;
  static double get buttonWidth => 300.w;

  // Border Radius
  static BorderRadius get borderRadius => BorderRadius.circular(20.r);

  // Icon sizes
  static double get iconSize => 24.sp;

  // Form Field Heights
  static double get formFieldHeight => 60.h;

  // Other constants
  static double get maxWidth => 800.w;  // Maximum width for larger screens
  static double get minWidth => 300.w;  // Minimum width for smaller screens
}
