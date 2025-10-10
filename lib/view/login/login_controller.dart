// import 'package:fat_end_fit/utils/app_toast.dart';
// import 'package:get/get.dart';
//
// import '../../utils/app_navigation.dart';
// import '../Identify/Identify_screen.dart';
//
// class LoginController extends GetxController {
//   var mobileNumber = ''.obs;
//   var otp = ''.obs;
//   var isLoading = false.obs;
//   var isOtpSent = false.obs;
//
//   Future<void> sendOtp() async {
//     if (mobileNumber.value.length != 10) {
//       AppToast.error("Please enter a valid mobile number");
//       return;
//     }
//
//     isLoading.value = true;
//     await Future.delayed(const Duration(seconds: 2)); // API call here
//     isLoading.value = false;
//
//     // If success:
//     isOtpSent.value = true;
//     AppToast.success("Otp Sent, Please check your phone for the OTP");
//   }
//
//   Future<void> verifyOtp() async {
//     if (otp.value.length != 4) {
//       AppToast.error("Please enter a valid 4-digit OTP");
//       return;
//     }
//     if (otp.value != '1234') {
//       AppToast.error("Wrong OTP, please try again");
//       return;
//     }
//
//     isLoading.value = true;
//     await Future.delayed(const Duration(seconds: 2));
//     isLoading.value = false;
//
//     // If success:
//     AppToast.success("OTP verified successfully");
//     Get.offAll(()=>IdentifyScreen());
//     // Get.off(() => IdentifyScreen());
//     // Navigate to home/dashboard
//   }
// }

import 'dart:ui';

import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_storage.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../service/connectivity_service.dart';
import '../../utils/app_navigation.dart';
import '../Identify/Identify_screen.dart';
import '../bottom_nav_bar/bottom_nav_bar_screen.dart';
import '../profile/profile_controller.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_storage.dart';
import '../../utils/app_toast.dart';
// import '../identify/identify_screen.dart';
import '../profile/profile_controller.dart';

class LoginController extends GetxController {
  var mobileNumber = ''.obs;
  var otp = ''.obs;
  var isLoading = false.obs;
  var isOtpSent = false.obs;
// Add this in your controller
  RxBool isTermsAccepted = false.obs;
  String? _serverOtp;
  String? _token;
  String? _refreshToken;
  bool? isProfileUpdated;

  final AppApi _apiService = AppApi.getInstance();

  /// Timer
  var remainingSeconds = 60.obs; // default 60s
  Timer? _timer;

  @override
  onInit(){
    super.onInit();
    Get.find<ConnectivityService>().checkAndShowDialog();
  }

  /// 🔹 Send OTP API Call
  Future<void> sendOtp() async {
    if (mobileNumber.value.length != 10) {
      AppToast.error("Please enter a valid mobile number");
      return;
    }

    try {

      isLoading.value = true;

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiConfig.login,
        data: {
          "mobileNumber": mobileNumber.value,
          "fcmToken": "dummy_fcm_token_here",
        },
      );

      isLoading.value = false;

      if (response.success) {
        final data = response.data?['data'];
        // AppLogs.log("LOGIN SUCCESS: $data");
        _serverOtp = data?['OTP']?.toString();
        _token = data?['accessToken'];
        _refreshToken = data?['refreshToken'];
        isProfileUpdated = data?['user']['isProfileUpdated'] ?? false;

        isOtpSent.value = true;
        _startTimer(); // start OTP timer

        AppToast.success("Otp Sent Successfully.");
      } else {
        AppToast.error(response.message ?? "Login failed");
      }
    } catch (e) {
      isLoading.value = false;
      AppToast.error("Something went wrong: $e");
    }
  }

  /// 🔹 Resend OTP
  Future<void> resendOtp() async {
    _timer?.cancel();
    remainingSeconds.value = 60;
    await sendOtp();
  }

  /// 🔹 Cancel OTP Flow
  void cancelOtp() {
    _timer?.cancel();
    remainingSeconds.value = 60;
    isOtpSent.value = false;
    otp.value = "";
  }

  /// 🔹 Verify OTP
  Future<void> verifyOtp() async {
    if (otp.value.length != 4) {
      AppToast.error("Please enter a valid 4-digit OTP");
      return;
    }

    if (_serverOtp == null) {
      AppToast.error("Please request OTP first");
      return;
    }

    if (otp.value != _serverOtp) {
      AppToast.error("Wrong OTP, please try again");
      return;
    }

    await saveLoginData();
    AppApi.getInstance().setAuthToken(_token ?? '');

    AppToast.success("OTP verified successfully");

    if (isProfileUpdated == true) {
      Get.put(ProfileController());
      Get.offAll(() => BottomNavBarScreen());
    } else {
      Get.offAll(() => IdentifyStepperScreen());
    }
  }

  /// 🔹 Timer Handler
  void _startTimer() {
    _timer?.cancel();
    remainingSeconds.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// 🔹 Save data locally
  Future<void> saveLoginData() async {
    AppLogs.log("[ refreshToken ] $_refreshToken", color: Colors.red);
    AppLogs.log("[ accessToken ] $_token", color: Colors.red);
    await AppStorage().save("mobileNumber", mobileNumber.value);
    await AppStorage().save("token", _token);
    await AppStorage().save("refreshToken", _refreshToken);
    await AppStorage().save("isLogin", true);
    await AppStorage().save("isProfileUpdated", isProfileUpdated);
  }

  /// 🔹 Logout
  Future<void> logout() async {
    _timer?.cancel();
    await AppStorage().remove("mobileNumber");
    await AppStorage().remove("token");
    await AppStorage().remove("refreshToken");
    await AppStorage().remove("isLogin");
    await AppStorage().remove("isProfileUpdated");
    Get.offAll(() => LoginScreen());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

// class LoginController extends GetxController {
//   var mobileNumber = ''.obs;
//   var otp = ''.obs;
//   var isLoading = false.obs;
//   var isOtpSent = false.obs;
//
//   String? _serverOtp; // 🔹 API ma thi male OTP store karva
//   String? _token;     // 🔹 Token store karva future use mate
//   String? _refreshToken;     // 🔹 Token store karva future use mate
//   bool? isProfileUpdated;     // 🔹 Token store karva future use mate
//
//   final AppApi _apiService = AppApi.getInstance();
//
//   /// 🔹 Send OTP API Call
//   Future<void> sendOtp() async {
//     if (mobileNumber.value.length != 10) {
//       AppToast.error("Please enter a valid mobile number");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final response = await _apiService.post<Map<String, dynamic>>(
//         ApiConfig.login,
//         data: {
//           "mobileNumber": mobileNumber.value,
//           "fcmToken": "dummy_fcm_token_here",
//         },
//       );
//
//       isLoading.value = false;
//
//       if (response.success) {
//         final data = response.data?['data'];
//         AppLogs.log("LOGIN SCCESS: $data");
//         _serverOtp = data?['OTP']?.toString(); // OTP from server
//         _token = data?['accessToken']; // Token for future APIs
//         _refreshToken = data?['refreshToken']; // Token for future APIs
//         isProfileUpdated = data?['user']['isProfileUpdated'] ?? false; // Token for future APIs
//
//         isOtpSent.value = true;
//         // AppToast.success("Otp Sent: $_serverOtp (testing mode)");
//         AppToast.success("Otp Sent Successfully.");
//       } else {
//         AppToast.error(response.message ?? "Login failed");
//       }
//     } catch (e) {
//       isLoading.value = false;
//       AppToast.error("Something went wrong: $e");
//     }
//   }
//
//   /// 🔹 Verify OTP
//   Future<void> verifyOtp() async {
//     if (otp.value.length != 4) {
//       AppToast.error("Please enter a valid 4-digit OTP");
//       return;
//     }
//
//     if (_serverOtp == null) {
//       AppToast.error("Please request OTP first");
//       return;
//     }
//
//     if (otp.value != _serverOtp) {
//       AppToast.error("Wrong OTP, please try again");
//       return;
//     }
//
//     await saveLoginData();
//
//     AppApi.getInstance().setAuthToken(_token ?? '');
//
//     // ✅ OTP verified
//     AppToast.success("OTP verified successfully");
//
//     // Save token locally for future APIs (SharedPreferences, Hive, etc.)
//     // await StorageService.saveToken(_token);
//
//     // Navigate to IdentifyScreen
//     if(isProfileUpdated == true) {
//        Get.put(ProfileController());
//       Get.offAll(() => BottomNavBarScreen()); // Redirect to home screen if profile is updated
//     } else {
//       Get.offAll(() => IdentifyScreen()); // Redirect to IdentifyScreen if profile is not updated
//     }
//   }
//
//   Future<void> saveLoginData() async {
//     AppLogs.log("[ refreshToken ] $_refreshToken",color: Colors.red);
//     AppLogs.log("[ accessToken ] $_token",color: Colors.red);
//     await AppStorage().save("mobileNumber", mobileNumber.value);
//     await AppStorage().save("token", _token);
//     await AppStorage().save("refreshToken", _refreshToken);
//     await AppStorage().save("isLogin", true);
//     await AppStorage().save("isProfileUpdated", isProfileUpdated);
//   }
//
//   Future<void> logout() async {
//     await AppStorage().remove("mobileNumber");
//     await AppStorage().remove("token");
//     await AppStorage().remove("refreshToken");
//     await AppStorage().remove("isLogin");
//     await AppStorage().remove("isProfileUpdated");
//     Get.offAll(() => LoginScreen()); // Redirect to login screen
//   }
// }
