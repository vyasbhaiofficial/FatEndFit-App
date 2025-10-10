import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_color.dart';

class CommonDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final RxString selectedValue;

  const CommonDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(40),
          // border: Border.all(color: AppColor.yellow, width: 1.5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            hint: Text(
              hint,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
            isExpanded: true,
            dropdownColor: AppColor.black,
            icon: Container(padding: EdgeInsets.all(0),decoration: BoxDecoration(color: AppColor.white,borderRadius: BorderRadius.circular(5)),child: const Icon(Icons.keyboard_arrow_down_sharp, color: AppColor.black)),
            borderRadius: BorderRadius.circular(12),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  // decoration: const BoxDecoration(
                  //   border: Border(
                  //     bottom: BorderSide(color: AppColor.yellow, width: 0.8),
                  //   ),
                  // ),
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) selectedValue.value = val;
            },
          ),
        ),
      ),
    );
  }
}
