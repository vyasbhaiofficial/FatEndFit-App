import 'package:fat_end_fit/utils/common_function.dart';
import 'package:flutter/material.dart';
import '../app_color.dart';
import '../app_text_style.dart';
class CommonButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isOutlined; // NEW: for outline style
  final bool isBlackButton;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? height;
  final double? radius;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.isBlackButton = false,
    this.isOutlined = false, // default false
    this.padding,
    this.buttonColor,
    this.buttonTextColor,
    this.height,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool useOutline = isOutlined;
    final Color bgColor = useOutline
        ? Colors.transparent
        : (isBlackButton
        ? AppColor.buttonBlack
        : buttonColor ?? AppColor.buttonYellow);
    final Color txtColor = useOutline
        ? buttonTextColor ?? AppColor.black
        : buttonTextColor ?? (isBlackButton ? AppColor.white : AppColor.black);
    final BorderSide? borderSide =
    useOutline ? BorderSide(color: buttonTextColor ?? AppColor.black, width: 1) : null;

    return InkWell(
      borderRadius: BorderRadius.circular(radius ?? height ?? 50 / 2),
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: padding,
        height: getSize(height ?? 50, isHeight: true) ?? 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: borderSide != null ? Border.fromBorderSide(borderSide) : null,
          borderRadius: BorderRadius.circular(radius ?? (height ?? 50) / 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: isLoading
            ? SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(txtColor),
          ),
        )
            : Text(
          text,
          style: AppTextStyle.buttonText.copyWith(
            color: txtColor,
            fontSize: getSize(14),
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
// import 'package:fat_end_fit/utils/common_function.dart';
// import 'package:flutter/material.dart';
// import '../app_color.dart';
// import '../app_text_style.dart';
//
//
// class CommonButton extends StatelessWidget {
//   final String text;
//   final bool isLoading;
//   final bool showBorder;
//   final bool isBlackButton;
//   final VoidCallback onTap;
//   final EdgeInsets? padding;
//   final Color? buttonColor;
//   final Color? buttonTextColor;
//   final double? height;
//   final double? radius;
//
//
//   const CommonButton({
//     Key? key,
//     required this.text,
//     required this.onTap,
//      this.showBorder = false,
//      this.isBlackButton = false,
//      this.isLoading = false,
//      this.padding,
//      this.buttonColor,
//      this.buttonTextColor,
//      this.height,
//      this.radius,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(25),
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         margin: padding,
//         height: getSize(height ?? 50,isHeight: true) ?? 50,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           border: showBorder? Border.all(color: AppColor.black, width: 1) : null,
//           color: isBlackButton?AppColor.buttonBlack:buttonColor ?? AppColor.buttonYellow,
//           borderRadius: BorderRadius.circular(radius ?? height ?? 50 / 2),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 5),
//         child: isLoading
//             ? SizedBox(
//           height: 22,
//           width: 22,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor ?? (isBlackButton?AppColor.white:AppColor.black)),
//           ),
//         )
//             : Text(text, style: AppTextStyle.buttonText.copyWith(color: buttonTextColor ?? (isBlackButton?AppColor.white:AppColor.black),fontSize: getSize(14),overflow: TextOverflow.ellipsis),maxLines: 1,overflow: TextOverflow.ellipsis),
//       ),
//     );
//   }
// }
