import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fat_end_fit/utils/app_color.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';

class GenderSelector extends StatelessWidget {
  final RxString selectedGender;
  final Function(String) onChanged;

  GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColor.yellow, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOption(AppString.male),
            _buildOption(AppString.female),
          ],
        ),
      );
    });
  }

  Widget _buildOption(String label) {
    final isSelected = selectedGender.value == label;
    return InkWell(
      onTap: () {
        selectedGender.value = label;
        onChanged(label);
      },
      child: Row(
        children: [
          AppText(
            label,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColor.yellow : AppColor.textWhite,
          ),
           SizedBox(width: Get.width * 0.05),
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.white, width: 1.5),
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? AppColor.yellow : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 16, color: AppColor.black)
                : null,
          ),
        ],
      ),
    );
  }
}
