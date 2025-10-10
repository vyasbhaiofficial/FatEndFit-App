import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/view/contact_us/contact_use_screen.dart';
import 'package:fat_end_fit/view/login/login_controller.dart';
import 'package:fat_end_fit/view/more/widget/log_out.dart';
import 'package:fat_end_fit/view/privacy_term_condition/privacy_policy.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_text.dart';
import '../about_us/about_us_screen.dart';
import '../privacy_term_condition/term_and_condition.dart';
import '../profile/profile_screen.dart';
import '../reference/reference_screen.dart';


class MoreController extends GetxController {

}

// class MoreScreen extends StatelessWidget {
//    MoreScreen({super.key});
//   final menuItems = [
//     AppString.profile.tr,
//     AppString.contactUs.tr,
//     AppString.aboutUs.tr,
//     AppString.reference.tr,
//     AppString.privacyPolicy.tr,
//     AppString.termsCondition.tr,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MoreController());
//
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             // Page title
//             Center(
//               child: AppText(
//                 AppString.more,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColor.textBlack,
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Menu list
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 itemCount: menuItems.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final key = menuItems[index]; // 👈 Store key (English only)
//                   return MoreMenuButton(
//                     title: key.tr, // 👈 Translation apply only here
//                     onTap: () {
//                       print("---- $key --- ${AppString.profile}");
//
//                       if (key == AppString.profile) {
//                         Get.to(()=>ProfileScreen());
//                       } else if (key == AppString.contactUs) {
//                         Get.to(()=>ContactUsScreen());
//                       } else if (key == AppString.aboutUs) {
//                         Get.to(()=>AboutUsScreen());
//                       } else if (key == AppString.reference) {
//                         Get.to(()=>ReferenceScreen());
//                       } else if (key == AppString.privacyPolicy) {
//                         Get.to(()=>PrivacyPolicyScreen());
//                       } else if (key == AppString.termsCondition) {
//                         Get.to(()=>TermsConditionScreen());
//                       }
//                     },
//                   );
//                 },
//               ),
//             )
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }


class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  final menuItems = [
    AppString.profile,
    AppString.contactUs,
    AppString.aboutUs,
    AppString.reference,
    AppString.privacyPolicy,
    AppString.termsCondition,
    AppString.logOut,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MoreController());

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Page title
            Center(
              child: AppText(
                AppString.more,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.textBlack,
              ),
            ),
            const SizedBox(height: 20),

            // 👇 Static menu list instead of ListView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MoreMenuButton(
                        title: AppString.profile.tr,
                        onTap: () => Get.to(() => ProfileScreen()),
                      ),
                      const SizedBox(height: 12),
                      MoreMenuButton(
                        title: AppString.contactUs.tr,
                        onTap: () => Get.to(() => ContactUsScreen()),
                      ),
                      const SizedBox(height: 12),
                      MoreMenuButton(
                        title: AppString.aboutUs.tr,
                        onTap: () => Get.to(() => AboutUsScreen()),
                      ),
                      const SizedBox(height: 12),
                      MoreMenuButton(
                        title: AppString.reference.tr,
                        onTap: () => Get.to(() => ReferenceScreen()),
                      ),
                      const SizedBox(height: 12),
                      MoreMenuButton(
                        title: AppString.privacyPolicy.tr,
                        onTap: () => Get.to(() => PrivacyPolicyScreen()),
                      ),
                      const SizedBox(height: 12),
                      MoreMenuButton(
                        title: AppString.termsCondition.tr,
                        onTap: () => Get.to(() => TermsConditionScreen()),
                      ),
                      const SizedBox(height: 12),
                      
                      MoreMenuButton(
                        title: AppString.logOut.tr,
                        onTap: () {
                          LoginController authController = Get.put(LoginController());
                          showLogoutDialog(() {
                          authController.logout();
                          },);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Common Menu Button
class MoreMenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? verticalPadding;
  final double? fontSize;
  final bool showIcon;

  const MoreMenuButton({
    super.key,
    required this.title,
    required this.onTap,
    this.verticalPadding,
    this.fontSize,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06, vertical: verticalPadding ?? 14),
        decoration: BoxDecoration(
          color: AppColor.yellow,
          // border: Border.all(width: 1, color: AppColor.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              title,
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w600,
              color: AppColor.textBlack,
            ),
            if (showIcon)
            Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(6),),
                child: const Icon(Icons.chevron_right, color: AppColor.black)),
          ],
        ),
      ),
    );
  }
}
