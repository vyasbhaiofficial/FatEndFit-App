import 'dart:io';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/view/profile/model/user_data.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../service/api_config.dart';
import '../../../service/api_service.dart';
import '../../../service/language_service.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/app_print.dart';
import '../../../utils/common_function.dart';

class EditProfileController extends GetxController {
  /// Controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();

  /// Reactive Variables
  var selectedGender = "".obs;
  var selectedLanguage = "".obs;
  var profileImage = Rx<File?>(null);
  ProfileController profileController = Get.find<ProfileController>();

  var isLoading = false.obs;

  @override
  onInit() {
    /// Initialize with existing profile data if available
    // For example, you can fetch existing data from a service or local storage
    nameController.text = profileController.user.value!.name; // Example default value
    ageController.text = profileController.user.value?.age.toString() ?? ''; // Example default value
    weightController.text = profileController.user.value?.weight.toString() ?? ''; // Example default value
    selectedGender.value = profileController.user.value?.gender ?? '';
    selectedLanguage.value = profileController.user.value?.language ?? '';
    print("selectedLanguage.value===========${selectedGender.value}");
    // if(selectedLanguage.value == 'en'){
    //   selectedLanguage.value = 'English';
    // } else if(selectedLanguage.value == 'hi'){
    //   selectedLanguage.value = 'Hindi';
    // } else if(selectedLanguage.value == 'gu'){
    //   selectedLanguage.value = 'Gujarati';
    // }
    profileImage.value = null;
    super.onInit();
  }

  /// Pick Profile Image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  /// Submit Profile Data (Future: API Integration)
  // Future<void> submitProfile() async {
  //   if(nameController.text.trim().isEmpty ||
  //      ageController.text.trim().isEmpty ||
  //      weightController.text.trim().isEmpty ||
  //      selectedGender.value.isEmpty ||
  //      selectedLanguage.value.isEmpty) {
  //     AppToast.error("Please fill all fields");
  //     return;
  //   }
  //   AppLoader.show();
  //   isLoading.value = true;
  //   String? url;
  //   // if(profileImage.value != null) {
  //     url = await UrlGenerator.getUrl(profileImage.value?.path ?? '');
  //   // }else{
  //   //   // url = profileController.user.value?.image;
  //   // }
  //   if(profileImage.value != null) {
  //     url = profileImage.value?.path;
  //   } /*else {
  //     url = profileController.user.value?.image;
  //   }*/
  //
  //   var newLanguage = selectedLanguage.value;
  //   if(selectedLanguage.value.contains("English")){
  //     newLanguage = "en";
  //   } else if(selectedLanguage.value.contains("Hindi")) {
  //     newLanguage = "hi";
  //   } else if(selectedLanguage.value.contains("Gujarati")) {
  //     newLanguage = "gu";
  //   }
  //
  //   // FormData formData = FormData.fromMap({
  //   //   fieldName: await MultipartFile.fromFile(filePath),
  //   //   if (additionalData != null) ...additionalData,
  //   // });
  //
  //   final data = {
  //     "name": nameController.text.trim(),
  //     "age": ageController.text.trim(),
  //     "weight": weightController.text.trim(),
  //     "gender": selectedGender.value,
  //     "language": selectedLanguage.value,
  //     // "profileImage": profileImage.value?.path,
  //     if(url != null && url.isNotEmpty) "image": url,
  //   };
  //   final response = await AppApi.getInstance().put(
  //     ApiConfig.userUpdate,
  //     data: data,
  //   );
  //
  //   if(response.success){
  //     LanguageService().changeLanguage(newLanguage);
  //     await profileController.refreshUser();
  //     AppLogs.log("Submit Profile: $data");
  //     AppLoader.hide();
  //     isLoading.value = false;
  //     AppToast.success("Profile updated successfully!");
  //     Get.back();
  //   }else{
  //     isLoading.value = false;
  //     AppLoader.hide();
  //   }
  // }
  Future<void> submitProfile() async {
    if (nameController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        weightController.text.trim().isEmpty ||
        selectedGender.value.isEmpty ||
        selectedLanguage.value.isEmpty) {
      AppToast.error("Please fill all fields");
      return;
    }

    AppLoader.show();
    isLoading.value = true;

    String? url;

    // language code mapping
    var newLanguage = selectedLanguage.value;
    var language = selectedLanguage.value;
    if (selectedLanguage.value.contains("English")) {
      newLanguage = "en";
      language = "English";
    } else if (selectedLanguage.value.contains("Hindi")) {
      newLanguage = "hi";
      language = "Hindi";
    } else if (selectedLanguage.value.contains("Gujarati")) {
      newLanguage = "gu";
      language = "Gujarati";
    }

    dynamic data;

    if (profileImage.value != null) {
      // user selected new image → send FormData
      data = dio.FormData.fromMap({
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "weight": weightController.text.trim(),
        "gender": selectedGender.value,
        "language": language,
        "image": await dio.MultipartFile.fromFile(
          profileImage.value!.path,
          filename: profileImage.value!.path.split('/').last,
        ),
      });
    } else {
      // no new image → send normal json
      data = {
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "weight": weightController.text.trim(),
        "gender": selectedGender.value,
        "language": language,
        // if (url != null && url.isNotEmpty) "image": url,
      };
    }

    final response = await AppApi.getInstance().put(
      ApiConfig.userUpdate,
      data: data,
    );

    if (response.success) {
      LanguageService().changeLanguage(newLanguage);
      await profileController.refreshUser();
      AppLogs.log("Submit Profile: $data");
      AppLoader.hide();
      isLoading.value = false;
      AppToast.success("Profile updated successfully!");
      Get.back();
    } else {
      isLoading.value = false;
      AppLoader.hide();
    }
  }



  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
