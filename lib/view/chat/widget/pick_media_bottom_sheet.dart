import 'dart:io';
import 'package:fat_end_fit/utils/app_color.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/chat/chat_customer_support_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_toast.dart';
import '../../../utils/common/app_text.dart';
import '../model/chat_message_model.dart';

class MediaPickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final sizeInMB = File(file.path).lengthSync() / (1024 * 1024);

      if (sizeInMB > 5) {
        AppToast.error("Image size should be less than 5 MB");
        return;
      }

      AppToast.success("Image picked: ${file.name}");
    }
    Get.back();
  }

  Future<void> pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (file != null) {
      final sizeInMB = File(file.path).lengthSync() / (1024 * 1024);

      if (sizeInMB > 30) {
        AppToast.error("Video size should be less than 30 MB");
        return;
      }

      AppToast.success("Video picked: ${file.name}");
    }
    Get.back();
  }
}

void showMediaPickerSheet() {
  final controller = Get.put(MediaPickerController());
  ChatController chatCon = Get.find();

  Get.bottomSheet(
    SafeArea(bottom: true,top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Handle indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
      
            // ✅ Title
            AppText(
              "Select Media",
              // style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              // ),
            ),
            const SizedBox(height: 20),
      
            // ✅ Options Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                mediaOption(
                  icon: Icons.image,
                  color: Colors.blue,
                  label: "Pick Image\n(Max 5 MB)",
                  onTap: () async {
                    Get.back();

                    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      final sizeInMB = File(file.path).lengthSync() / (1024 * 1024);
                      if (sizeInMB > 5) {
                        AppToast.error("Image size should be less than 5 MB");
                      } else {
                        await chatCon.sendMedia(file: File(file.path), type: MessageType.image);
                        // controller.
                        // ✅ valid image
                      }
                    }
                  },
                ),
                mediaOption(
                  icon: Icons.video_library,
                  color: Colors.orange,
                  label: "Pick Video\n(Max 30 MB)",
                  onTap: () async {
                    Get.back();

                    XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
                    if (file != null) {
                      final sizeInMB = File(file.path).lengthSync() / (1024 * 1024);
                      AppLogs.log("VIDEO SIZE: $sizeInMB");
                      if (sizeInMB > 30) {
                        AppLogs.log("⚠️ VIDEO TOO LARGE: $sizeInMB MB");
                        AppToast.error("Video size should be less than 30 MB");
                      } else {
                        await chatCon.sendMedia(file: File(file.path), type: MessageType.video);
                        // ✅ valid video
                      }
                    }
                    // Get.back();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

/// ✅ Reusable widget for option card
Widget mediaOption({
  required IconData icon,
  required Color color,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: Get.width * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: getSize(40,isFont: true), color: color),
          const SizedBox(height: 12),
          AppText(
            label,
            textAlign: TextAlign.center,maxLines: 2,
            fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}
