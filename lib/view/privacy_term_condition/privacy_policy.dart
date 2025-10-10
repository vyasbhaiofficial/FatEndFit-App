import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common_function.dart';
import '../about_us/widget/common_header.dart';
import '../setting_user/setting_user_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSettingController appSettingController = Get.find();
    if(appSettingController.setting.value?.privacyPolicy.trim() == ""){
      appSettingController.fetchSettings();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          child: Column(
            children: [
              CommonHeader(title: AppString.privacyPolicy),
              Obx(() {
                String aboutUsHtml = appSettingController.setting.value?.privacyPolicy ?? "";

                return Expanded(
                  child: CommonHtmlViewer(htmlContent: aboutUsHtml),
                );
              },)
            ],
          ),
        ),
      ),
    );
  }
}

