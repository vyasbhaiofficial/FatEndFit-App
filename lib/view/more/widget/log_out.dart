import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';

void showLogoutDialog(VoidCallback onConfirm) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColor.pureWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout,
              size: 48,
              color: AppColor.yellow,
            ),
            const SizedBox(height: 16),
            Text(
              "Log Out",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColor.blackColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: AppColor.blackColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
