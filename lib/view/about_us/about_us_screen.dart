import 'package:fat_end_fit/view/about_us/widget/common_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common_function.dart';
import '../setting_user/setting_user_controller.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override

  Widget build(BuildContext context) {

    AppSettingController appSettingController = Get.find();
    if(appSettingController.setting.value?.aboutUs.trim() == ""){
      appSettingController.fetchSettings();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          child: Column(
            children: [
              CommonHeader(title: AppString.aboutUs),
              Obx(() {
                String aboutUsHtml = appSettingController.setting.value?.aboutUs ?? '';

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
// Widget build(BuildContext context) {
//   AppSettingController appSettingController = Get.find();
//   String aboutUsText = HtmlUtils.parseHtmlString(appSettingController.setting.value!.aboutUs);
//   return Scaffold(
//     backgroundColor: AppColor.white,
//     body: SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CommonHeader(title: AppString.aboutUs),
//             const SizedBox(height: 20),
//             // Expanded(
//             //   child: SingleChildScrollView(
//             //     child: CommonParagraph(text: AppString.loremIpsum),
//             //   ),
//             // )
//             Expanded(
//               child: SingleChildScrollView(
//                 child: CommonParagraph(
//                   text: aboutUsText,
//                 ),
//               ),
//             )
//
//           ],
//         ),
//       ),
//     ),
//   );
// }