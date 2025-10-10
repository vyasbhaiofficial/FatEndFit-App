import 'package:fat_end_fit/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../common_function.dart';


class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  const AppText(
      this.text, {
        Key? key,
        this.fontSize,
        this.color,
        this.fontWeight = FontWeight.normal,
        this.textAlign = TextAlign.start,
        this.overflow = TextOverflow.ellipsis,
        this.maxLines,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize ?? getSize(15),
        color: color ?? AppColor.textBlack, // default app text color
        fontWeight: fontWeight,
      ),
    );
  }
}
