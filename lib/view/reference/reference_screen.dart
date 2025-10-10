import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/view/reference/reference_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_text.dart';
import '../../utils/common/app_textfield.dart';
import '../about_us/widget/common_header.dart';
import '../more/more_screen.dart';
import 'my_reference_list_screen.dart';

// class ReferenceScreen extends StatelessWidget {
//   ReferenceScreen({super.key});
//
//   final nameCtrl = TextEditingController();
//   final mobileCtrl = TextEditingController();
//   final relationCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonHeader(title: "\t\t\t ${AppString.reference}",rightWidget: MoreMenuButton(onTap: () {
//                 Get.to(()=>MyReferenceScreen());
//               },title: AppString.myReference,verticalPadding: 3,showIcon: false,fontSize: 12,),),
//               const SizedBox(height: 20),
//               CommonTextField(hintText: AppString.personName, controller: nameCtrl,fillColor: AppColor.yellow,enabledBorderColor: AppColor.black,textColor: AppColor.black.withOpacity(0.5)),
//               SizedBox(height: 16,),
//               CommonTextField(hintText: AppString.mobileNumber, controller: mobileCtrl,fillColor: AppColor.yellow,enabledBorderColor: AppColor.black,textColor: AppColor.black.withOpacity(0.5)),
//               SizedBox(height: 16,),
//               CommonTextField(hintText: AppString.relation, controller: relationCtrl,fillColor: AppColor.yellow,enabledBorderColor: AppColor.black,textColor: AppColor.black.withOpacity(0.5),),
//               SizedBox(height: 16,),
//               const Spacer(),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.black,
//                   minimumSize: const Size(double.infinity, 48),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Get.snackbar("Submit", "Reference Added!");
//                 },
//                 child: AppText(
//                   AppString.submit,
//                   color: AppColor.textWhite,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class ReferenceScreen extends StatelessWidget {
  ReferenceScreen({super.key});

  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final relationCtrl = TextEditingController();

  final ReferenceController controller = Get.put(ReferenceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHeader(
                title: "\t\t\t ${AppString.reference}",
                rightWidget: MoreMenuButton(
                  onTap: () {
                    Get.to(() => MyReferenceScreen());
                  },
                  title: AppString.myReference,
                  verticalPadding: 3,
                  showIcon: false,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              CommonTextField(
                hintText: AppString.personName,
                controller: nameCtrl,
                fillColor: AppColor.black.withOpacity(0.7),
                enabledBorderColor: AppColor.black.withOpacity(0.7),
                textColor: AppColor.textWhite,
              ),
              const SizedBox(height: 16),
              CommonTextField(
                hintText: AppString.mobileNumber,
                controller: mobileCtrl,
                fillColor: AppColor.black.withOpacity(0.7),
                enabledBorderColor: AppColor.black.withOpacity(0.7),
                textColor: AppColor.textWhite,
                keyboardType: TextInputType.number,inputFormatters: [

                  LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly,
              ],
              ),
              const SizedBox(height: 16),
              CommonTextField(
                hintText: AppString.relation,
                controller: relationCtrl,
                fillColor: AppColor.black.withOpacity(0.7),
                enabledBorderColor: AppColor.black.withOpacity(0.7),
                textColor: AppColor.textWhite,
              ),
              SizedBox(height: Get.height * 0.04),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.yellow,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    if (nameCtrl.text.isNotEmpty &&
                        mobileCtrl.text.isNotEmpty &&
                        relationCtrl.text.isNotEmpty) {
                      await controller.createReference(
                        name: nameCtrl.text,
                        mobile: mobileCtrl.text,
                        relation: relationCtrl.text,
                      );
                      nameCtrl.text = "";
                      mobileCtrl.text = "";
                      relationCtrl.text = "";
                    } else {
                      AppToast.error("All fields are required");
                    }
                  },
                  child: AppText(
                    AppString.submit,
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
