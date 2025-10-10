import 'package:fat_end_fit/service/language_service.dart';
import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_strings.dart';
import '../../utils/common/app_button_v1.dart';
import '../../utils/common/app_dropdown.dart';
import '../../utils/common/app_radio_button.dart';
import '../bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'identify_2_controller.dart';

class IdentifyScreen2 extends StatelessWidget {
  // final RxString selectedLanguage = "".obs;
  // final RxString selectedReference = "".obs;
  // final RxString selectedCity = "".obs;
  // final RxString selectedState = "".obs;
  // final RxString selectedCountry = "".obs;
  final IdentifyController2 controller = Get.put(IdentifyController2());
  IdentifyScreen2({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> data = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(AppString.language,fontWeight: FontWeight.bold,fontSize: Get.width * 0.05,),
                CommonRadioButton(label: AppString.hindi, value: AppString.hindi, groupValue: controller.selectedLanguage,onTap: () {
                  controller.selectedLanguage.value = AppString.hindi;
                  LanguageService().changeLanguage("hi");
                },),
                CommonRadioButton(label: AppString.english, value: AppString.english, groupValue: controller.selectedLanguage,onTap: () {
                  controller.selectedLanguage.value = AppString.english;
                  LanguageService().changeLanguage("en");
                },),
                CommonRadioButton(label: AppString.gujarati, value: AppString.gujarati, groupValue: controller.selectedLanguage, onTap: () {
                  controller.selectedLanguage.value = AppString.gujarati;
                  LanguageService().changeLanguage("gu");

                },),
            
                const SizedBox(height: 20),
            
                AppText(AppString.applicationReference,fontWeight: FontWeight.bold,fontSize: Get.width * 0.05,),
                CommonRadioButton(
                  label: AppString.facebook,
                  value: AppString.facebook,
                  groupValue: controller.selectedReference,
                  onTap: () => controller.selectedReference.value = AppString.facebook,
                ),
                CommonRadioButton(
                  label: AppString.friendsAndFamily,
                  value: AppString.friendsAndFamily,
                  groupValue: controller.selectedReference,
                  onTap: () => controller.selectedReference.value = AppString.friendsAndFamily,
                ),
                CommonRadioButton(
                  label: AppString.instagram,
                  value: AppString.instagram,
                  groupValue: controller.selectedReference,
                  onTap: () => controller.selectedReference.value = AppString.instagram,
                ),
            
                const SizedBox(height: 20),
            
                AppText(AppString.city,fontWeight: FontWeight.bold,fontSize: Get.width * 0.05,),
                CommonDropdown(
                  hint: AppString.selectCity,
                  items: ["Surat", "Ahmedabad", "Mumbai"],
                  selectedValue: controller.selectedCity,
                ),
            
                AppText(AppString.state,fontWeight: FontWeight.bold,fontSize: Get.width * 0.05,),
                CommonDropdown(
                  hint: AppString.selectState,
                  items: ["Gujarat", "Maharashtra", "Rajasthan"],
                  selectedValue: controller.selectedState,
                ),
            
                AppText(AppString.country,fontWeight: FontWeight.bold,fontSize: Get.width * 0.05,),
                CommonDropdown(
                  hint: AppString.selectCountry,
                  items: ["India", "USA", "UK"],
                  selectedValue: controller.selectedCountry,
                ),
            
                const SizedBox(height: 30),

                Obx(() => CommonButton(
                  isBlackButton: true,
                  isLoading: controller.isButtonLoading.value,
                  text: AppString.next,
                  onTap: () => controller.onNextButtonPressed(data),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
