import 'package:flutter/material.dart';
import 'app_color.dart';
import 'common_function.dart';

class AppTextStyle {
  /// Headings
  static TextStyle heading1 = TextStyle(
    fontSize: getSize(22, isFont: true),
    fontWeight: FontWeight.bold,
    color: AppColor.textBlack,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: getSize(20, isFont: true),
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );

  static TextStyle heading3 = TextStyle(
    fontSize: getSize(18, isFont: true),
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );

  /// Body
  static TextStyle body = TextStyle(
    fontSize: getSize(15, isFont: true),
    color: AppColor.textBlack,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: getSize(13, isFont: true),
    color: AppColor.textGrey,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyBold = TextStyle(
    fontSize: getSize(15, isFont: true),
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );

  /// Labels
  static TextStyle label = TextStyle(
    fontSize: getSize(14, isFont: true),
    fontWeight: FontWeight.w500,
    color: AppColor.textGrey,
  );

  static TextStyle labelBold = TextStyle(
    fontSize: getSize(14, isFont: true),
    fontWeight: FontWeight.bold,
    color: AppColor.textBlack,
  );

  /// Buttons
  static TextStyle buttonText = TextStyle(
    fontSize: getSize(16, isFont: true),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle buttonTextOutlined = TextStyle(
    fontSize: getSize(16, isFont: true),
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );

  /// Links
  static TextStyle link = TextStyle(
    fontSize: getSize(14, isFont: true),
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
    decoration: TextDecoration.underline,
  );

  /// Captions
  static TextStyle caption = TextStyle(
    fontSize: getSize(12, isFont: true),
    color: AppColor.textGrey,
  );

  static TextStyle captionBold = TextStyle(
    fontSize: getSize(12, isFont: true),
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );
}
