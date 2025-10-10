import 'package:fat_end_fit/view/setting_user/setting_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<AppSettingController>();

    return Obx(() {
      // ✅ If app active → back to splash/login flow handle karse
      if (settingController.setting.value?.appActive == true) {
        return const SizedBox.shrink();
      }

      // ❌ App inactive → show maintenance UI
      return Scaffold(
        backgroundColor: AppColor.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Animated circle icon
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColor.yellow.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build_rounded,
                    size: MediaQuery.of(context).size.width * 0.18,
                    color: AppColor.yellow,
                  ),
                ),
                const SizedBox(height: 30),

                // 🔹 Title
                Text(
                  "We are fixing issues",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textBlack,
                  ),
                ),
                const SizedBox(height: 12),

                // 🔹 Subtitle
                Text(
                  "Our app is temporarily down for maintenance.\nPlease check back later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: AppColor.textGrey,
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Retry button
                ElevatedButton(
                  onPressed: () async {
                    await settingController.fetchSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonYellow,
                    foregroundColor: AppColor.textBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: settingController.isLoading.value
                      ? const CircularProgressIndicator(
                    color: AppColor.black,
                  )
                      : const Text(
                    "Retry",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
