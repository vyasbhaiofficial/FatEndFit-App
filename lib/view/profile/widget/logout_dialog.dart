import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/common/app_text.dart';
import '../profile_controller.dart';

class LogoutDialog {
  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColor.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  size: 48,
                  color: AppColor.yellow,
                ),
                const SizedBox(height: 16),
                const AppText(
                  "Log Out",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textBlack,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const AppText(
                  "Are you sure you want to log out?",
                  fontSize: 14,
                  color: AppColor.textGrey,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.textBlack,
                          side: const BorderSide(color: AppColor.borderGrey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const AppText(
                          "Cancel",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.buttonYellow,
                          foregroundColor: AppColor.textBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (Get.isRegistered<ProfileController>()) {
                            Get.delete<ProfileController>();
                          }

                          onConfirm();
                        },
                        child: const AppText(
                          "Log Out",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textBlack,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
