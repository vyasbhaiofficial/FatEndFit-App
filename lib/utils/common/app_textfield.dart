import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_color.dart';


class CommonTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final bool obscureText;
  final Color textColor;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final void Function(String)? onChanged;
  final int? maxLength;
  final Widget? prefixIcon;

  const CommonTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.enabledBorderColor,
    this.fillColor,
    this.borderRadius = 30,
    this.verticalPadding = 14,
    this.horizontalPadding = 16,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.maxLength,
    this.textColor = AppColor.textWhite,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,cursorColor: textColor ?? enabledBorderColor,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: TextStyle(
        color: textColor ?? AppColor.textWhite,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        filled: true,
        fillColor: fillColor ?? AppColor.black,
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor ?? AppColor.yellow, width: 1.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor ?? AppColor.yellow, width: 1.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onChanged: onChanged,
      maxLength: maxLength,
    );
  }
}
