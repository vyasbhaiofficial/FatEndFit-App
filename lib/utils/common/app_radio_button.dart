import 'package:fat_end_fit/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonRadioButton extends StatelessWidget {
  final String label;
  final String value;
  final RxString groupValue;
  final Function()? onTap;

  const CommonRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
     this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        groupValue.value = value;
        onTap!();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: groupValue.value == value ? AppColor.primary : AppColor.primary,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.yellow, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(
              groupValue.value == value ? Icons.radio_button_checked : Icons.radio_button_off_sharp,
              color: AppColor.yellow,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: AppColor.yellow, fontSize: 16,fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    ));
  }
}
