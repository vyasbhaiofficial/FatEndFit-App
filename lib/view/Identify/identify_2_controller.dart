import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/view/setting_user/setting_user_controller.dart';
import 'package:get/get.dart';
// import 'package:fat_end_fit/service/app_api.dart'; // import your api service
import 'package:fat_end_fit/utils/app_strings.dart';

import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_storage.dart';
import '../bottom_nav_bar/bottom_nav_bar_screen.dart';
import '../profile/profile_controller.dart';

class IdentifyController2 extends GetxController {
  // Screen fields
  final RxString selectedLanguage = ''.obs;
  final RxString selectedReference = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCountry = ''.obs;

  var isButtonLoading = false.obs;

  // Call this when Next is pressed
  Future<void> onNextButtonPressed(Map<String, dynamic> previousData) async {
    isButtonLoading.value = true;

    AppLogs.log("Selected Language: ${selectedLanguage.value}");
    AppLogs.log("Selected Reference: ${selectedReference.value}");
    AppLogs.log("Selected City: ${selectedCity.value}");
    AppLogs.log("Selected State: ${selectedState.value}");
    AppLogs.log("Selected Country: ${selectedCountry.value}");

    var newLanguage = selectedLanguage.value;
    var language = selectedLanguage.value;
    if(previousData['language'] != null) {
      if (previousData['language'].contains("English")) {
        newLanguage = "en";
        language = "English";
      } else if (previousData['language'].contains("Hindi")) {
        newLanguage = "hi";
        language = "Hindi";
      } else if (previousData['language'].contains("Gujarati")) {
        newLanguage = "gu";
        language = "Gujarati";
      }
    }
    // Merge this screen’s selections with previous map
    var mergedMap = Map<String, dynamic>.from(previousData)
      ..addAll({
        'language': selectedLanguage.value,
        'reference': selectedReference.value,
        'city': selectedCity.value,
        'state': selectedState.value,
        'country': selectedCountry.value,
      });

    mergedMap['language'] = language;
    // isButtonLoading.value = false;
    AppLogs.log("[ BODY ] = Merged Data: $mergedMap");
    // return;

    // Make the api call
    final response = await AppApi.getInstance().put(
      ApiConfig.userUpdate,
      data: mergedMap,
    );

    isButtonLoading.value = false;



    AppLogs.log("RESPONCE UPDATE PROFILE: ${response.data}");
    if (response.success) {
      saveLoginData();
      // Navigate as needed
      Get.put(ProfileController());
      Get.offAll(() => BottomNavBarScreen());
      AppSettingController controller = Get.find();
      await controller.fetchSettings();
    } else {
      // Show error
     // show\\\
    }
  }
  Future<void> saveLoginData() async {
    await AppStorage().save("isLogin", true);
    await AppStorage().save("isProfileUpdated", true);
  }
}
