import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/profile/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../service/language_service.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/common/app_common_back_button.dart';
import '../../../utils/common/app_radio_button.dart';
import '../../../utils/common/app_text.dart';
import '../../../utils/common/app_textfield.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(marginLeft: 6),
                  AppText(AppString.editProfile,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textBlack),
                  const SizedBox(width: 50),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Profile Image Picker
                    Row(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => GestureDetector(
                          onTap: controller.pickImage,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColor.yellow,
                            child:CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              child: controller.profileImage.value != null
                                  ? ClipOval(
                                child: Image.file(
                                  controller.profileImage.value!,
                                  width: 104,
                                  height: 104,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : AppImage.circularAvatar(
                                radius: 52,
                                getImageUrl(controller.profileController.user.value?.image),
                                placeholder: AppImage.network(AppImages.commonUserIcon),
                                errorWidget: AppImage.network(AppImages.commonUserIcon),

                              ),
                            )

                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Name
                    AppText("${AppString.name} : ",fontWeight: FontWeight.w700,),
                    CommonTextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25)
                      ],
                      enabledBorderColor: AppColor.yellow,
                      hintText: AppString.name,
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 16),

                    /// Gender Dropdown
                    AppText("${AppString.gender} : ",fontWeight: FontWeight.w700,),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Male button
                        GestureDetector(
                          onTap: () => controller.selectedGender.value = "Male",
                          child: Container(
                            width: Get.width * 0.42,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == "Male"
                                  ? AppColor.yellow
                                  : AppColor.black,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColor.yellow, width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    AppString.male,
                                    color: controller.selectedGender.value == "Male"
                                        ? AppColor.black
                                        : AppColor.yellow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if(controller.selectedGender.value == "Male")
                                  const Icon(Icons.check, color: AppColor.black),
                              ],
                            ),
                          ),
                        ),

                        // Female button
                        GestureDetector(
                          onTap: () => controller.selectedGender.value = "Female",
                          child: Container(
                            width: Get.width * 0.42,

                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == "Female"
                                  ? AppColor.yellow
                                  : AppColor.black,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColor.yellow, width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    AppString.female,
                                    color: controller.selectedGender.value == "Female"
                                        ? AppColor.black
                                        : AppColor.yellow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if(controller.selectedGender.value == "Female")
                                  const Icon(Icons.check, color: AppColor.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),

                    const SizedBox(height: 16),

                    /// Language Dropdown
                    AppText("${AppString.language} : ",fontWeight: FontWeight.w700,),
                    CommonRadioButton(label: AppString.hindi, value: "Hindi", groupValue: controller.selectedLanguage,onTap: () {
                      // LanguageService().changeLanguage("hi");
                    },),
                    CommonRadioButton(label: AppString.english, value: "English", groupValue: controller.selectedLanguage,onTap: () {
                      // LanguageService().changeLanguage("en");
                    },),
                    CommonRadioButton(label: AppString.gujarati, value: "Gujarati", groupValue: controller.selectedLanguage, onTap: () {
                      // LanguageService().changeLanguage("gu");

                    },),
                    const SizedBox(height: 16),

                    /// Age
                    AppText("${AppString.age} : ",fontWeight: FontWeight.w700,),
                    CommonTextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2)
                      ],
                      enabledBorderColor: AppColor.yellow,
                      hintText: AppString.age,
                      controller: controller.ageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    /// Weight
                    AppText("${AppString.weight} : ",fontWeight: FontWeight.w700,),
                    CommonTextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3)
                      ],
                      enabledBorderColor: AppColor.yellow,
                      hintText: AppString.weight,
                      controller: controller.weightController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),

                    /// Submit Button
                    GestureDetector(
                      onTap: controller.isLoading.value?null:controller.submitProfile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.yellow,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Obx(() => Center(
                          child: controller.isLoading.value?SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.black),
                            ),
                          ):AppText(AppString.save,
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),)
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
