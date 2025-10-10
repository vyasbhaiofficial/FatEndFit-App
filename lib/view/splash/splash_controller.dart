import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_storage.dart';
import 'package:fat_end_fit/view/Identify/Identify_screen.dart';
import 'package:fat_end_fit/view/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../service/connectivity_service.dart';
import '../../utils/app_navigation.dart';
import '../login/login_screen.dart';
import '../profile/profile_controller.dart';
import '../setting_user/app_issue_screen.dart';
import '../setting_user/setting_user_controller.dart';

class SplashController extends GetxController {
  final appSettingController = Get.put(AppSettingController());
  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

/// This method handles the loading process when the app starts
/// It checks various conditions to determine which screen to navigate to
  void _startLoading() async {
   // Read login status, profile update status, and token from storage
   bool isLogin = AppStorage().read("isLogin") ?? false;
   bool isProfileUpdated = AppStorage().read("isProfileUpdated") ?? false;
   String token = AppStorage().read("token") ?? "";
   await Get.putAsync(() => ConnectivityService().initConnectivity());

   // Fetch application settings
   await appSettingController.fetchSettings();

   // Check if settings are available
   if (appSettingController.setting.value == null) {
     // Log if no settings are found
     AppLogs.log("No settings found, continuing normal flow", tag: "SPLASH");
   } else {
     // Log the fetched app settings
     AppLogs.log("App settings fetched: ${appSettingController.setting.value?.appActive}", tag: "SPLASH");
     
     // 🔹 If app is not active → go to issue screen
     if (appSettingController.setting.value?.appActive == false) {
       AppLogs.log("App inactive → Showing Issue Screen", tag: "SPLASH");
       Get.offAll(() => const IssueScreen());
       return;
     }
   }

   AppLogs.log("SplashController: isLogin: $isLogin, isProfileUpdated: $isProfileUpdated, token: $token");

    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in and profile is updated
    if(isLogin && isProfileUpdated && token.isNotEmpty) {
      Get.put(ProfileController());
      Get.offAll(()=> BottomNavBarScreen());
    } else if (isLogin && !isProfileUpdated) {

      // If user is logged in but profile is not updated, navigate to profile update screen
      Get.offAll(() => IdentifyStepperScreen());
    } else {
      // If user is not logged in, navigate to login screen
      Get.offAll(() => LoginScreen());

    }
  }
}
