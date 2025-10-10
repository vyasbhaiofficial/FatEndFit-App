import 'dart:convert';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:get/get.dart';

import 'package:fat_end_fit/utils/app_storage.dart';

import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../login/login_screen.dart';
import 'model/user_data.dart';

class ProfileController extends GetxController {

  /// Observables
  var user = Rxn<UserData>(); // current user
  var isLoading = false.obs;

  /// Keys for storage
  static const String storageKeyUser = "user_data";

  final _storage = AppStorage();
  final _api = AppApi.getInstance();

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
    fetchUser();
  }

  /// 🔹 Load cached user data from AppStorage
  void loadUserFromStorage() {
    AppStorage().checkIsLogin();
    final jsonStr = _storage.read<String>(storageKeyUser);
    if (jsonStr != null) {
      try {
        final jsonData = jsonDecode(jsonStr);
        user.value = UserData.fromJson(jsonData);
      } catch (e) {
        print("Error parsing cached user: $e");
      }
    }
  }

  /// 🔹 Fetch fresh user data from API
  Future<void> fetchUser() async {
    try {
      AppStorage().checkIsLogin();
      isLoading.value = true;

      final response = await _api.get<Map<String, dynamic>>(ApiConfig.getUser);

      if (response.success && response.data != null) {
        final userResponse = UserResponse.fromJson(response.data!);
        user.value = userResponse.data;
        AppLogs.log("USER NUMBER: ${user.value?.mobileNumber}, USER NAME: ${user.value?.name}");
        /// Save in storage
        if (userResponse.data != null) {
          _storage.save(storageKeyUser, jsonEncode(userResponse.data!.toJson()));
        }
      } else {
        AppLogs.log(response.message ?? "Failed to fetch user");
      }
    } catch (e) {
      AppLogs.log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Refresh user manually
  Future<void> refreshUser() async {
    await fetchUser();
  }

  /// 🔹 Logout user
  Future<void> logout() async {
    await AppStorage().remove("mobileNumber");
    await AppStorage().remove("token");
    await AppStorage().remove("isLogin");
    await AppStorage().remove("isProfileUpdated");
    Get.offAll(() => LoginScreen()); // Redirect to login screen
  }
}
