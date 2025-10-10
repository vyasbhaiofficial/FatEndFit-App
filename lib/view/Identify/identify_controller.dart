import 'package:fat_end_fit/service/firebase_service.dart';
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/connectivity_service.dart';
import '../../utils/app_navigation.dart';
import 'identify_2_screen.dart';

class IdentifyController extends GetxController {
  // Text Controllers
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final conditionController = TextEditingController();

  // Gender Selection
  RxString gender = "Male".obs;

  // Validation Errors
  var firstNameError = "".obs;
  var surnameError = "".obs;
  var weightError = "".obs;
  var heightError = "".obs;
  var ageError = "".obs;
  var fcmToken = "".obs;

  var isButtonLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    // Initialize FCM token
    FirebaseService.getToken().then((token) {
      fcmToken.value = token ?? '';
    });
  }

  Map<String, dynamic> get identifyData => {
    'name': firstNameController.text.trim(),
    'surname': surnameController.text.trim(),
    'fcmToken': fcmToken.value,
    'gender': gender.value,
    'age': int.tryParse(ageController.text.trim()) ?? 0,
    'height': double.tryParse(heightController.text.trim()) ?? 0.0,
    'weight': double.tryParse(weightController.text.trim()) ?? 0.0,
    // 'language': languageController.text.trim(),
    'medicalDescription': conditionController.text.trim(),
    // 'city': cityController.text.trim(),
    // 'state': stateController.text.trim(),
    // 'country': countryController.text.trim(),
    // 'image': image.value,
  };

  bool validateForm() {
    bool isValid = true;

    // First Name
    if (firstNameController.text.trim().isEmpty) {
      firstNameError.value = AppString.firstNameError;
      isValid = false;
    } else {
      firstNameError.value = "";
    }

    // Surname
    if (surnameController.text.trim().isEmpty) {
      surnameError.value = AppString.surnameError;
      isValid = false;
    } else {
      surnameError.value = "";
    }

    // Weight
    final weightText = weightController.text.trim();
    if (weightText.isEmpty) {
      weightError.value = AppString.weightError;
      isValid = false;
    } else if (int.tryParse(weightText) == null) {
      weightError.value = "Invalid weight";
      isValid = false;
    } else {
      final weight = int.parse(weightText);
      if (weight > 200) {
        weightError.value = "Weight cannot exceed 200 kg";
        isValid = false;
      } else if (weight <= 0) {
        weightError.value = "Invalid weight";
        isValid = false;
      } else {
        weightError.value = "";
      }
    }

    // Height
    final heightText = heightController.text.trim();
    if (heightText.isEmpty) {
      heightError.value = AppString.heightError;
      isValid = false;
    } else if (int.tryParse(heightText) == null) {
      heightError.value = "Invalid height";
      isValid = false;
    } else {
      final height = int.parse(heightText);
      if (height > 250) {
        heightError.value = "Height cannot exceed 250 cm";
        isValid = false;
      } else if (height <= 0) {
        heightError.value = "Invalid height";
        isValid = false;
      } else {
        heightError.value = "";
      }
    }

    // Age
    final ageText = ageController.text.trim();
    if (ageText.isEmpty) {
      ageError.value = AppString.ageError;
      isValid = false;
    } else if (int.tryParse(ageText) == null) {
      ageError.value = "Invalid age";
      isValid = false;
    } else {
      final age = int.parse(ageText);
      if (age < 1 || age > 120) {
        ageError.value = "Age must be between 1 and 120";
        isValid = false;
      } else {
        ageError.value = "";
      }
    }

    return isValid;
  }


  Future<void> submitForm() async {
    isButtonLoading.value = true;
    if (validateForm()) {
      // Simulate delay
      await Future.delayed(const Duration(seconds: 1));
      // Pass the data as Map to next screen
      Get.offAll(() => IdentifyScreen2(), arguments: identifyData);
    }
    isButtonLoading.value = false;
  }
}

class IdentifyStepperController extends GetxController {
  var currentStep = 0.obs;

  @override
  onInit(){
    super.onInit();
    Get.find<ConnectivityService>().checkAndShowDialog();
  }
  var data = {}.obs;

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
