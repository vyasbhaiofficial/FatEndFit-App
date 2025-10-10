import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/common/app_text.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final Widget rightWidget;
  const CommonHeader({super.key, required this.title,this.rightWidget = const SizedBox(width: 30,)});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        backButton(marginLeft: 0,marginTop: 5,marginRight: 5),
        Expanded(
          child: Center(
            child: AppText(
              title,
              fontSize: getSize(18),
              fontWeight: FontWeight.bold,
              color: AppColor.textBlack,
              maxLines: 1,
            ),
          ),
        ),
        rightWidget, // Placeholder for right side space
      ],
    );
  }
}

class CommonParagraph extends StatelessWidget {
  final String text;
  const CommonParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      fontSize: 14,
      color: AppColor.textBlack,
      fontWeight: FontWeight.normal,
      textAlign: TextAlign.justify,
      maxLines: 1000,
    );
  }
}

// class CommonTextField extends StatelessWidget {
//   final String hint;
//   final TextEditingController controller;
//
//   const CommonTextField({super.key, required this.hint, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: AppColor.white,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
