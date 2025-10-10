import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/view/Identify/widget/gender_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fat_end_fit/utils/app_color.dart';
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';
import '../../service/language_service.dart';
import '../../utils/app_print.dart';
import '../../utils/common/app_button_v1.dart' as button;
import '../../utils/common/app_dropdown.dart';
import '../../utils/common/app_radio_button.dart';
import '../../utils/common/app_textfield.dart';
import 'identify_2_controller.dart';
import 'identify_controller.dart'; // 👈 new controller import

class IdentifyStepperScreen extends StatelessWidget {
  final IdentifyStepperController stepController =
  Get.put(IdentifyStepperController());

  IdentifyStepperScreen({super.key});

  final List<Widget> steps = [
    LanguageStep(),
    LocationStep(),
    DetailStep(),
    ReferenceStep(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SafeArea(
        child: steps[stepController.currentStep.value],
      )),
    );
  }
}

// class LocationStep extends StatelessWidget {
//   final IdentifyController2 controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText("Add your location",
//               fontWeight: FontWeight.bold, fontSize: Get.width * 0.05),
//           CommonDropdown(
//             hint: "Select City",
//             items: ["Surat", "Ahmedabad", "Mumbai"],
//             selectedValue: controller.selectedCity,
//           ),
//           CommonDropdown(
//             hint: "Select State",
//             items: ["Gujarat", "Maharashtra"],
//             selectedValue: controller.selectedState,
//           ),
//           CommonDropdown(
//             hint: "Select Country",
//             items: ["India", "USA"],
//             selectedValue: controller.selectedCountry,
//           ),
//           const Spacer(),
//           CommonButton(
//             text: "Next",
//             onTap: () => Get.find<IdentifyStepperController>().nextStep(),
//           )
//         ],
//       ),
//     );
//   }
// }

class LocationStep extends StatelessWidget {
  final IdentifyController2 controller = Get.put(IdentifyController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back button
             backButton(onTap: () {
               Get.find<IdentifyStepperController>().prevStep();
             },autoBack: false,marginLeft: 0),

              const SizedBox(height: 8),

              // Title
              Text.rich(
                TextSpan(
                  text: "${AppString.addYour} ",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: AppString.location,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // City
              Text(
                "${AppString.city} :",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              CommonDropdown(
                hint: AppString.selectCity,
                items: ["Surat", "Ahmedabad", "Mumbai"],
                selectedValue: controller.selectedCity,

              ),
              const SizedBox(height: 20),

              // State
              Text(
                "${AppString.state} :",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              CommonDropdown(
                hint: AppString.selectState,
                items: ["Gujarat", "Maharashtra"],
                selectedValue: controller.selectedState,
              ),
              const SizedBox(height: 20),

              // Country
              Text(
                "${AppString.country} :",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              CommonDropdown(
                hint: AppString.selectCountry,
                items: ["India", "USA"],
                selectedValue: controller.selectedCountry,
              ),

              const Spacer(),

              // ✅ Bottom Right Next button
              Align(alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Get.find<IdentifyStepperController>().nextStep();
                  },
                  child: Text(
                    AppString.next,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// class ReferenceStep extends StatelessWidget {
//   final IdentifyController2 controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText("Application Reference",
//               fontWeight: FontWeight.bold, fontSize: Get.width * 0.05),
//           CommonRadioButton(
//               label: "Facebook",
//               value: "facebook",
//               groupValue: controller.selectedReference,
//               onTap: () => controller.selectedReference.value = "facebook"),
//           CommonRadioButton(
//               label: "Friends",
//               value: "friends",
//               groupValue: controller.selectedReference,
//               onTap: () => controller.selectedReference.value = "friends"),
//           CommonRadioButton(
//               label: "Instagram",
//               value: "instagram",
//               groupValue: controller.selectedReference,
//               onTap: () => controller.selectedReference.value = "instagram"),
//           const Spacer(),
//           CommonButton(
//             text: "Continue",
//             onTap: () {
//               controller.onNextButtonPressed({});
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

class ReferenceStep extends StatelessWidget {
  final IdentifyController2 controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // same bg as screenshot
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              backButton(onTap: () {
                Get.find<IdentifyStepperController>().prevStep();
              },autoBack: false,marginLeft: 0),

              const SizedBox(height: 8),

              // Title
              Text(
                "Application Reference",
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              // Radio buttons
              // CommonRadioButton(
              //   label: "Facebook",
              //   value: "facebook",
              //   groupValue: controller.selectedReference,
              //   onTap: () =>
              //   controller.selectedReference.value = "facebook",
              // ),
              // const SizedBox(height: 12),
              // CommonRadioButton(
              //   label: "Friends",
              //   value: "friends",
              //   groupValue: controller.selectedReference,
              //   onTap: () =>
              //   controller.selectedReference.value = "friends",
              // ),
              // const SizedBox(height: 12),
              // CommonRadioButton(
              //   label: "Instagram",
              //   value: "instagram",
              //   groupValue: controller.selectedReference,
              //   onTap: () =>
              //   controller.selectedReference.value = "instagram",
              // ),
              Obx(() => GestureDetector(
                onTap: () =>
                controller.selectedReference.value = "facebook",
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedReference.value == "facebook"
                        ? Colors.black87
                        : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Facebook",
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.selectedReference.value == "facebook"
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      if (controller.selectedReference.value == "facebook") ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check,
                            size: 18, color: Colors.white),
                      ]
                    ],
                  ),
                ),
              ),),
              const SizedBox(height: 12),

              Obx(() => GestureDetector(
                onTap: () =>
                controller.selectedReference.value = "friends",
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedReference.value == "friends"
                        ? Colors.black87
                        : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Friends",
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.selectedReference.value == "friends"
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      if (controller.selectedReference.value == "friends") ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check,
                            size: 18, color: Colors.white),
                      ]
                    ],
                  ),
                ),
              ),),
              const SizedBox(height: 12),

              Obx(() => GestureDetector(
                onTap: () =>
                controller.selectedReference.value = "instagram",
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedReference.value == "instagram"
                        ? Colors.black87
                        : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Instagram",
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.selectedReference.value == "instagram"
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      if (controller.selectedReference.value == "instagram") ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check,
                            size: 18, color: Colors.white),
                      ]
                    ],
                  ),
                ),
              ),),

              const Spacer(),

              // Bottom big text
              Center(
                child: Column(
                  children: [
                    AppText(
                      "Start your body",
                      // style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      // ),
                    ),
                    AppText(
                      "detoxification journey",
                      // style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      // ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              button.CommonButton(
                text: "Continue",
                buttonColor: Colors.yellow.shade600,
                buttonTextColor: Colors.black,
                radius: 30,
                onTap: () {
                  var newLan = "";
                  if (controller.selectedLanguage.value.contains("en")) {
                    newLan = "English";
                  } else if (controller.selectedLanguage.value.contains("hi")) {
                    newLan = "Hindi";
                  } else if (controller.selectedLanguage.value.contains("gu")) {
                    newLan = "Gujarati";
                  }

                  final data = {
                    'language': newLan,
                    'city': controller.selectedCity.value,
                    'state': controller.selectedState.value,
                    'country': controller.selectedCountry.value,
                    'firstName': Get.find<IdentifyController>().firstNameController.text.trim(),
                    'surname': Get.find<IdentifyController>().surnameController.text.trim(),
                    'weight': Get.find<IdentifyController>().weightController.text.trim(),
                    'height': Get.find<IdentifyController>().heightController.text.trim(),
                    'age': Get.find<IdentifyController>().ageController.text.trim(),
                    'gender': Get.find<IdentifyController>().gender.trim(),
                  };

                  // Log all data
                  AppLogs.log("📦 Next Button Data: $data");

                  controller.onNextButtonPressed(data);
                },

              ),
              SizedBox(height: Get.height * 0.06),

            ],
          ),
        ),
      ),
    );
  }
}


// class LanguageStep extends StatelessWidget {
//   final IdentifyController2 controller = Get.put(IdentifyController2());
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText("Choose your language",
//               fontWeight: FontWeight.bold, fontSize: Get.width * 0.05),
//           CommonRadioButton(label: "Gujarati", value: "gu", groupValue: controller.selectedLanguage,
//               onTap: () => controller.selectedLanguage.value = "gu"),
//           CommonRadioButton(label: "Hindi", value: "hi", groupValue: controller.selectedLanguage,
//               onTap: () => controller.selectedLanguage.value = "hi"),
//           CommonRadioButton(label: "English", value: "en", groupValue: controller.selectedLanguage,
//               onTap: () => controller.selectedLanguage.value = "en"),
//           const Spacer(),
//           CommonButton(
//             text: "Next",
//             onTap: () => Get.find<IdentifyStepperController>().nextStep(),
//           )
//         ],
//       ),
//     );
//   }
// }



class LanguageStep extends StatelessWidget {
  final IdentifyController2 controller = Get.put(IdentifyController2());

  final List<Map<String, String>> languages = [
    {"code": "gu", "label": "ગુજરાતી"},
    {"code": "hi", "label": "हिन्दी"},
    {"code": "en", "label": "English"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // same grey bg
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: "Choose your \n",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: "language",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Chips
              Obx(
                    () => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: languages.map((lang) {
                    final isSelected =
                        controller.selectedLanguage.value == lang["code"];
                    return GestureDetector(
                      onTap: () {
                        controller.selectedLanguage.value = lang["code"] ?? 'en';
                        LanguageService().changeLanguage(lang['code'] ?? 'en');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black87
                              : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lang["label"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check,
                                  size: 18, color: Colors.white),
                            ]
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // ✅ Next button
              Align(alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Get.find<IdentifyStepperController>().nextStep();
                  },
                  child: Text(
                    AppString.next,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class DetailStep extends StatelessWidget {
  final IdentifyController controller = Get.put(IdentifyController());
  final IdentifyController2 controller2 = Get.put(IdentifyController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back button
                 backButton(marginLeft: 0,autoBack: false,onTap: (){
                  Get.find<IdentifyStepperController>().prevStep();
                }),
                const SizedBox(height: 8),
            
                // Title
                Text.rich(
                  TextSpan(
                    text: "${AppString.addYour} ",
                    style: const TextStyle(
                        fontSize: 22, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: AppString.details,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
            
                // First Name
                Text("${AppString.firstName} :"),
                const SizedBox(height: 6),
                CommonTextField(
                  hintText: "Enter your name",
                  controller: controller.firstNameController,
                  onChanged: (value) {
                    if(value.isNotEmpty) {
                      controller.firstNameError.value =  "";
                    }else{
                      controller.firstNameError.value = AppString.firstNameError;
                    }
                  },
                ),
                Obx(() => controller.firstNameError.value.isNotEmpty
                ? Text(controller.firstNameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
                : const SizedBox()),
                const SizedBox(height: 16),
            
                // Surname
                Text("${AppString.surname} :"),
                const SizedBox(height: 6),
                CommonTextField(
                  hintText: "Enter your surname",
                  controller: controller.surnameController,
                  onChanged: (value) {
                    if(value.isNotEmpty) {
                      controller.surnameError.value =  "";
                    }else{
                      controller.surnameError.value = AppString.surnameError;
                    }
                  },
                ),
                Obx(() => controller.surnameError.value.isNotEmpty
                    ? Text(controller.surnameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
                    : const SizedBox()),
                const SizedBox(height: 16),
            
                // Weight + Height
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppString.weight} :"),
                          const SizedBox(height: 6),
                          // CommonTextField(
                          //   inputFormatters: [],
                          //   hintText: "Enter Weight",
                          //   controller: controller.weightController,
                          //   keyboardType: TextInputType.number,
                          //   onChanged: (value) {
                          //     if(value.isNotEmpty) {
                          //       controller.weightError.value =  "";
                          //     }else{
                          //       controller.weightError.value = AppString.weightError;
                          //     }
                          //   },
                          // ),
                          CommonTextField(
                            hintText: "Enter Weight",
                            controller: controller.weightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.weightError.value = AppString.weightError;
                              } else if (int.tryParse(value) == null) {
                                controller.weightError.value = "Invalid number";
                              } else if (value.length > 3) {
                                controller.weightError.value = "Weight can’t exceed 3 digits";
                              } else {
                                final weight = int.parse(value);
                                if (weight > 200) {
                                  controller.weightError.value = "Weight cannot exceed 200 kg";
                                } else {
                                  controller.weightError.value = "";
                                }
                              }
                            },
                          ),
                      Obx(() => controller.weightError.value.isNotEmpty
                          ? Text(controller.weightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
                          : const SizedBox()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppString.height} :"),
                          const SizedBox(height: 6),
                          CommonTextField(
                            hintText: "Enter Height",
                            controller: controller.heightController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.heightError.value = AppString.heightError;
                              } else if (int.tryParse(value) == null) {
                                controller.heightError.value = "Invalid number";
                              } else if (value.length > 3) {
                                controller.heightError.value = "Height can’t exceed 3 digits";
                              } else {
                                final weight = int.parse(value);
                                if (weight > 250) {
                                  controller.heightError.value = "Height cannot exceed 250 cm";
                                } else {
                                  controller.heightError.value = "";
                                }
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                      Obx(() => controller.heightError.value.isNotEmpty
                          ? Text(controller.heightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
                          : const SizedBox()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
            
                // Age + Gender
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppString.age} :"),
                          const SizedBox(height: 6),
                          CommonTextField(
                            hintText: "Enter Age",
                            controller: controller.ageController,
                            keyboardType: TextInputType.number, onChanged: (value) {
                              if (value.isNotEmpty) {
                                controller.ageError.value = "";
                              } else {
                                controller.ageError.value = AppString.ageError;
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                      Obx(() => controller.ageError.value.isNotEmpty
                      ? Text(controller.ageError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
                      : const SizedBox()),

                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppString.gender} :"),
                          const SizedBox(height: 6),
                          CommonDropdown(
                            hint: "Select",
                            items: ["Male", "Female", "Other"],
                            selectedValue: controller.gender,
                          ),
                          // CommonDropdown(
                          //   hint: "Select",
                          //   items: [
                          //     AppString.male,   // localized string for "Male"
                          //     AppString.female, // localized string for "Female"
                          //     // AppString.other,  // localized string for "Other"
                          //   ],
                          //   selectedValue: controller.gender,
                          // )

                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
            
                // Medical Condition
                 Text(AppString.condition ?? "Any medical condition ?"),
                const SizedBox(height: 6),
                CommonTextField(
                  hintText: "Any medical condition?",
                  controller: controller.conditionController,
                ),
            
                // const Spacer(),
            
                // ✅ Bottom Right Next
                SizedBox(height: Get.height * 0.06),

                Align(alignment: Alignment.bottomLeft,
                  child: CommonButton(
                    text: AppString.next,
                    onTap: () {
                      if(controller.validateForm()) {
                        Get.find<IdentifyStepperController>().nextStep();
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// class IdentifyScreen extends StatelessWidget {
//   final IdentifyController controller = Get.put(IdentifyController());
//
//   IdentifyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             backButton(marginLeft: 0,autoBack: false,onTap: (){
//               Get.find<IdentifyStepperController>().prevStep();
//             }),
//             Center(
//               child: AppText(
//                 "Enter your details",
//                 fontSize: Get.width * 0.06,
//                 fontWeight: FontWeight.bold,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // First Name
//             AppText(AppString.firstName, fontSize: 16, fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             CommonTextField(textColor: AppColor.yellow,
//               hintText: "ex. Smith",
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(20)
//               ],
//               controller: controller.firstNameController,
//               onChanged: (value) {
//                 if(value.isNotEmpty) {
//                   controller.firstNameError.value =  "";
//                 }else{
//                   controller.firstNameError.value = AppString.firstNameError;
//                 }
//               },
//             ),
//             Obx(() => controller.firstNameError.value.isNotEmpty
//                 ? Text(controller.firstNameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                 : const SizedBox()),
//
//             const SizedBox(height: 12),
//
//             // Surname
//             AppText(AppString.surname, fontSize: 16, fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             CommonTextField(
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(15)
//               ],
//               textColor: AppColor.yellow,
//               hintText: "ex. Madison",
//               controller: controller.surnameController,
//               onChanged: (value) {
//                 if(value.isNotEmpty) {
//                   controller.surnameError.value =  "";
//                 }else{
//                   controller.surnameError.value = AppString.surnameError;
//                 }
//               },
//             ),
//             Obx(() => controller.surnameError.value.isNotEmpty
//                 ? Text(controller.surnameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                 : const SizedBox()),
//
//             const SizedBox(height: 12),
//
//             // Weight & Height
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(AppString.weight, fontSize: 16, fontWeight: FontWeight.w600),
//                       const SizedBox(height: 8),
//                       CommonTextField(textColor: AppColor.yellow,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(3)
//                         ],
//                         hintText: "ex. 75 KG",
//                         keyboardType: TextInputType.number,
//                         controller: controller.weightController,
//                         onChanged: (value) {
//                           if(value.isNotEmpty) {
//                             controller.weightError.value =  "";
//                           }else{
//                             controller.weightError.value = AppString.weightError;
//                           }
//                         },
//                       ),
//                       Obx(() => controller.weightError.value.isNotEmpty
//                           ? Text(controller.weightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                           : const SizedBox()),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(AppString.height, fontSize: 16, fontWeight: FontWeight.w600),
//                       const SizedBox(height: 8),
//                       CommonTextField(textColor: AppColor.yellow,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(3)
//                         ],
//                         hintText: "ex. 165 Ft",
//                         controller: controller.heightController,
//                         onChanged: (value) {
//                           if(value.isNotEmpty) {
//                             controller.heightError.value =  "";
//                           }else{
//                             controller.heightError.value = AppString.heightError;
//                           }
//                         },
//                       ),
//                       Obx(() => controller.heightError.value.isNotEmpty
//                           ? Text(controller.heightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                           : const SizedBox()),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             // Age
//             AppText(AppString.age, fontSize: 16, fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             CommonTextField(textColor: AppColor.yellow,
//               hintText: "ex. 28",
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(2)
//               ],
//               controller: controller.ageController,
//               onChanged: (value) {
//                 if (value.isNotEmpty) {
//                   controller.ageError.value = "";
//                 } else {
//                   controller.ageError.value = AppString.ageError;
//                 }
//               },
//               keyboardType: TextInputType.number,
//               maxLength: 2,
//             ),
//
//             Obx(() => controller.ageError.value.isNotEmpty
//                 ? Text(controller.ageError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                 : const SizedBox()),
//
//             // Gender
//             AppText(AppString.gender, fontSize: 16, fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             GenderSelector(
//               selectedGender: controller.gender,
//               onChanged: (value) {
//                 print("Selected Gender: $value");
//               },
//
//             ),
//             const SizedBox(height: 12),
//
//             // Medical Condition
//             AppText(AppString.condition, fontSize: 16, fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             CommonTextField(textColor: AppColor.yellow,
//               hintText: "Ex. Diabetes",
//               controller: controller.conditionController,
//               onChanged: (value) {
//
//               },
//             ),
//             const SizedBox(height: 18),
//             CommonButton(
//               text: "Next",
//               onTap: () {
//
//                 Get.find<IdentifyStepperController>().nextStep();
//                 Get.find<IdentifyStepperController>().data.value = controller.identifyData;
//               },
//             ),
//             const SizedBox(height: 70),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
class CommonDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final RxString selectedValue;

  const CommonDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButton<String>(
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.black38),
          ),
          dropdownColor: Colors.grey.shade300,

          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item,
              style: const TextStyle(
                color: AppColor.blackColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              selectedValue.value = value;
            }
          },
        ),
      ),
    );
  }
}

// Common Button
class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CommonButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
class CommonTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CommonTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}

// class IdentifyScreen extends StatelessWidget {
//   final IdentifyController controller = Get.put(IdentifyController());
//
//   IdentifyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: AppText(
//                   AppString.howIdentify,
//                   fontSize: Get.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // First Name
//               AppText(AppString.firstName, fontSize: 16, fontWeight: FontWeight.w600),
//               const SizedBox(height: 8),
//               CommonTextField(textColor: AppColor.yellow,
//                 hintText: "ex. Smith",
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(20)
//                 ],
//                 controller: controller.firstNameController,
//                 onChanged: (value) {
//                   if(value.isNotEmpty) {
//                     controller.firstNameError.value =  "";
//                   }else{
//                     controller.firstNameError.value = AppString.firstNameError;
//                   }
//                 },
//               ),
//               Obx(() => controller.firstNameError.value.isNotEmpty
//                   ? Text(controller.firstNameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                   : const SizedBox()),
//
//               const SizedBox(height: 12),
//
//               // Surname
//               AppText(AppString.surname, fontSize: 16, fontWeight: FontWeight.w600),
//               const SizedBox(height: 8),
//               CommonTextField(
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(15)
//                 ],
//                 textColor: AppColor.yellow,
//                 hintText: "ex. Madison",
//                 controller: controller.surnameController,
//                 onChanged: (value) {
//                   if(value.isNotEmpty) {
//                     controller.surnameError.value =  "";
//                   }else{
//                     controller.surnameError.value = AppString.surnameError;
//                   }
//                 },
//               ),
//               Obx(() => controller.surnameError.value.isNotEmpty
//                   ? Text(controller.surnameError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                   : const SizedBox()),
//
//               const SizedBox(height: 12),
//
//               // Weight & Height
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppText(AppString.weight, fontSize: 16, fontWeight: FontWeight.w600),
//                         const SizedBox(height: 8),
//                         CommonTextField(textColor: AppColor.yellow,
//                           inputFormatters: [
//                             LengthLimitingTextInputFormatter(3)
//                           ],
//                           hintText: "ex. 75 KG",
//                           keyboardType: TextInputType.number,
//                           controller: controller.weightController,
//                           onChanged: (value) {
//                             if(value.isNotEmpty) {
//                               controller.weightError.value =  "";
//                             }else{
//                               controller.weightError.value = AppString.weightError;
//                             }
//                           },
//                         ),
//                         Obx(() => controller.weightError.value.isNotEmpty
//                             ? Text(controller.weightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                             : const SizedBox()),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppText(AppString.height, fontSize: 16, fontWeight: FontWeight.w600),
//                         const SizedBox(height: 8),
//                         CommonTextField(textColor: AppColor.yellow,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [
//                             LengthLimitingTextInputFormatter(3)
//                           ],
//                           hintText: "ex. 165 Ft",
//                           controller: controller.heightController,
//                           onChanged: (value) {
//                             if(value.isNotEmpty) {
//                               controller.heightError.value =  "";
//                             }else{
//                               controller.heightError.value = AppString.heightError;
//                             }
//                           },
//                         ),
//                         Obx(() => controller.heightError.value.isNotEmpty
//                             ? Text(controller.heightError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                             : const SizedBox()),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Age
//               AppText(AppString.age, fontSize: 16, fontWeight: FontWeight.w600),
//               const SizedBox(height: 8),
//               CommonTextField(textColor: AppColor.yellow,
//                 hintText: "ex. 28",
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(2)
//                 ],
//                 controller: controller.ageController,
//                 onChanged: (value) {
//                   if (value.isNotEmpty) {
//                     controller.ageError.value = "";
//                   } else {
//                     controller.ageError.value = AppString.ageError;
//                   }
//                 },
//                 keyboardType: TextInputType.number,
//                 maxLength: 2,
//               ),
//
//               Obx(() => controller.ageError.value.isNotEmpty
//                   ? Text(controller.ageError.value, style: const TextStyle(color: Colors.red, fontSize: 12))
//                   : const SizedBox()),
//
//               // Gender
//               AppText(AppString.gender, fontSize: 16, fontWeight: FontWeight.w600),
//               const SizedBox(height: 8),
//               GenderSelector(
//                 selectedGender: controller.gender,
//                 onChanged: (value) {
//                   print("Selected Gender: $value");
//                 },
//
//               ),
//               const SizedBox(height: 12),
//
//               // Medical Condition
//               AppText(AppString.condition, fontSize: 16, fontWeight: FontWeight.w600),
//               const SizedBox(height: 8),
//               CommonTextField(textColor: AppColor.yellow,
//                 hintText: "Ex. Diabetes",
//                 controller: controller.conditionController,
//                 onChanged: (value) {
//
//                 },
//               ),
//               const SizedBox(height: 70),
//
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 30,left: 30,top: 10),
//         child: Obx(() =>  CommonButton(
//             isLoading: controller.isButtonLoading.value,
//             height: 60,
//             isBlackButton: true,
//             text: AppString.start,
//             onTap: controller.submitForm
//         ),)
//       ),
//     );
//   }
// }
