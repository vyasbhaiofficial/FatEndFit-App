import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/utils/common/common_line.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:fat_end_fit/view/profile/widget/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_text.dart';
import '../../utils/common_function.dart';
import 'edit/edit_profile_screen.dart';
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final userController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // gray bg
      body: SafeArea(
        child: Obx(
              () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child:         backButton(marginLeft: 0,marginTop: 5,marginRight: 5,marginBottom: 0),

                ),

                // Title
                 Center(
                  child: Text(
                    AppString.profile,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 7),

                // 🔹 White Card (User info + Edit Button)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Profile photo
                      CircleAvatar(
                        radius: 30,
                        // backgroundImage: NetworkImage(
                        //   getImageUrl(userController.user.value?.image ?? ""),
                        // ),
                        child: AppImage.circularAvatar(getImageUrl(userController.user.value?.image ?? ""),radius: 30,
                            placeholder: AppImage.circularAvatar(AppImages.commonUserIcon,radius: 25),
                            errorWidget: AppImage.circularAvatar(AppImages.commonUserIcon,radius: 25)
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name + Patient ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              userController.user.value?.name ?? "User Name",
                              // style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            // ),
                            const SizedBox(height: 4),
                            AppText(
                              "${AppString.patientId} : ${userController.user.value?.patientId ?? 'N/A'}",
                              // style: TextStyle(
                                fontSize: 12,
                                color: AppColor.textBlack,
                              // ),
                            ),
                          ],
                        ),
                      ),

                      // Edit Profile Button
                      GestureDetector(
                        onTap: () {
                          Get.to(() => EditProfileScreen(),
                              arguments: userController.user.value);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            AppString.editProfile,
                            // style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            // ),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 🔹 Form-style fields
                ProfileField(
                  label: AppString.contactNumber,
                  value: formatMobile(userController.user.value?.mobileNumber, userController.user.value?.mobilePrefix) ??
                      "97897 72832",
                ),
                Row(
                  children: [
                    Expanded(
                      child: ProfileField(
                        label: AppString.weight,
                        value:
                        userController.user.value?.weight?.toString() ?? "70",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ProfileField(
                        label: AppString.height,
                        value: userController.user.value?.height?.toString() ??
                            "0.0",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ProfileField(
                        label: AppString.age,
                        value:
                        userController.user.value?.age?.toString() ?? "30",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ProfileField(
                        label: AppString.gender,
                        value: userController.user.value?.gender ?? "Male",
                      ),
                    ),
                  ],
                ),

                if(userController.user.value?.medicalDescription != null && userController.user.value!.medicalDescription!.isNotEmpty)
                ProfileField(
                  label: AppString.condition/*"Any medical condition ?"*/,
                  value: userController.user.value?.medicalDescription ?? "Sugar",
                ),

                const SizedBox(height: 40),

                // Bottom floating support icon
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: FloatingActionButton(
                //     backgroundColor: Colors.yellow[700],
                //     onPressed: () {},
                //     child: const Icon(Icons.headset_mic, color: Colors.black),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CommonFloatingButton(),
    );
  }
}
String formatMobile(String? number, String? mobilePrefix) {
  if (number == null || number.isEmpty) return "N/A";

  final prefix = (mobilePrefix != null && mobilePrefix.isNotEmpty)
      ? mobilePrefix.trim()
      : "+91"; // default fallback

  // Already contains a "+" at the start → assume full number
  if (number.startsWith("+")) {
    return number;
  }

  // Add prefix
  return "$prefix $number";
}



// 🔹 Custom Widget for gray input-style fields
class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label :",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({super.key});
//   final userController = Get.put(ProfileController());
//
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        backgroundColor: AppColor.background,
//        body: SafeArea(
//          child: Obx(() => Column(
//            children: [
//              // 🔹 Header
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    backButton(marginLeft: 3),
//                    Text(
//                      AppString.profile,
//                      style: const TextStyle(
//                        fontSize: 18,
//                        fontWeight: FontWeight.bold,
//                        color: AppColor.textBlack,
//                      ),
//                    ),
//                    GestureDetector(onTap: () {
//                      Get.to(()=>EditProfileScreen(),arguments: userController.user.value);
//                    },
//                      onLongPress: () {
//                        LogoutDialog.show(context, onConfirm: () {
//                           userController.logout();
//                        },);
//                      },
//                      child: Container(
//                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                        decoration: BoxDecoration(
//                            color: AppColor.yellow,
//                            borderRadius: BorderRadius.circular(20),
//                            border: Border.all(color: Colors.black,width: 1.5)
//                        ),
//                        child: Text(
//                          AppString.editProfile,
//                          style: const TextStyle(
//                            color: AppColor.black,
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//
//              // 🔹 Profile Banner + Avatar
//              Stack(
//                alignment: Alignment.center,
//                children: [
//                  Padding(
//                    padding: const EdgeInsets.only(right: 20,left: 20),
//                    child: ClipRRect(
//                        borderRadius: BorderRadius.circular(8),
//                        child: Column(
//                          children: [
//                            ClipRRect(borderRadius: BorderRadius.circular(12),child: AppImage.network("https://img.freepik.com/free-photo/mixed-fruits-with-apple-banana-orange-other_74190-938.jpg",height: 120, width: double.infinity, fit: BoxFit.cover)),
//                            SizedBox(height: 40,)
//                          ],
//                        )
//                    ),
//                  ),
//                  Positioned(
//                    bottom: -30,
//                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),border: Border.all(color: AppColor.black,width: 2)),child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),child: AppImage.network(getImageUrl(userController.user.value?.image ?? ''),height: 120,width: 100,enableCaching: true,placeholder: AppImage.network(AppImages.commonUserIcon),errorWidget: AppImage.network(AppImages.commonUserIcon),))),
//                  ),
//                ],
//              ),
//
//              // 🔹 Name + Patient ID
//              Column(
//                children: [
//                  Container(
//                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                    decoration: BoxDecoration(
//                      color: AppColor.yellow,
//                      borderRadius: BorderRadius.circular(12),
//                    ),
//                    child: Text(
//                      userController.user.value?.name ?? 'User',
//                      style: TextStyle(
//                        color: AppColor.black,
//                        fontWeight: FontWeight.w600,
//                      ),
//                    ),
//                  ),
//                  const SizedBox(height: 4),
//                  Text(
//                    "${AppString.patientId} : ${userController.user.value?.patientId ?? 'N/A'}",
//                    style: const TextStyle(color: AppColor.textBlack),
//                  ),
//                ],
//              ),
//              const SizedBox(height: 20),
//
//              // 🔹 Profile Info List
//              Expanded(
//                child: SingleChildScrollView(
//                  padding: const EdgeInsets.symmetric(horizontal: 16),
//                  child: Column(
//                    children: [
//                      ProfileInfoTile(
//                        label: AppString.mobileNumber,
//                        value: userController.user.value?.mobileNumber ?? "N/A",
//                        leading: Row(
//                          children: [
//                            AppImage.network("https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png",height: 25,width: 35),
//                            Container(height: 30,width: 0.5,color: AppColor.yellow,margin: EdgeInsets.only(left: 10),)
//                          ],
//                        ),
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.gender,
//                        value: userController.user.value?.gender ?? "N/A",
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.city,
//                        value: userController.user.value?.city ?? "Surat",
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.country,
//                        value: userController.user.value?.country ?? "India",
//                        leading: Row(
//                          children: [
//                            AppImage.network("https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png",height: 25,width: 35),
//                            Container(height: 30,width: 0.5,color: AppColor.yellow,margin: EdgeInsets.only(left: 10),)
//                          ],
//                        ),
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.language,
//                        value: userController.user.value?.language ?? "N/A",
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.age,
//                        value: userController.user.value?.age.toString() ?? "N/A",
//                      ),
//                      ProfileInfoTile(
//                        label: AppString.weight,
//                        value: userController.user.value?.weight.toString() ?? "N/A",
//                      ),
//                    ],
//                  ),
//                ),
//              )
//            ],
//          ),),
//        ),
//      );
//    }
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     backgroundColor: AppColor.background,
//   //     body: SafeArea(
//   //       child: Column(
//   //         children: [
//   //           // 🔹 Header
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//   //             child: Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //               children: [
//   //                 backButton(marginLeft: 3),
//   //                 Text(
//   //                   AppString.profile,
//   //                   style: const TextStyle(
//   //                     fontSize: 18,
//   //                     fontWeight: FontWeight.bold,
//   //                     color: AppColor.textBlack,
//   //                   ),
//   //                 ),
//   //                 GestureDetector(onTap: () {
//   //                   Get.to(()=>EditProfileScreen());
//   //                 },
//   //                   child: Container(
//   //                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//   //                     decoration: BoxDecoration(
//   //                       color: AppColor.yellow,
//   //                       borderRadius: BorderRadius.circular(20),
//   //                       border: Border.all(color: Colors.black,width: 1.5)
//   //                     ),
//   //                     child: Text(
//   //                       AppString.editProfile,
//   //                       style: const TextStyle(
//   //                         color: AppColor.black,
//   //                         fontWeight: FontWeight.w600,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //
//   //           // 🔹 Profile Banner + Avatar
//   //           Stack(
//   //             alignment: Alignment.center,
//   //             children: [
//   //               Padding(
//   //                 padding: const EdgeInsets.only(right: 20,left: 20),
//   //                 child: ClipRRect(
//   //                   borderRadius: BorderRadius.circular(8),
//   //                   child: Column(
//   //                     children: [
//   //                       ClipRRect(borderRadius: BorderRadius.circular(12),child: AppImage.network("https://img.freepik.com/free-photo/mixed-fruits-with-apple-banana-orange-other_74190-938.jpg",height: 120, width: double.infinity, fit: BoxFit.cover)),
//   //                       SizedBox(height: 40,)
//   //                     ],
//   //                   )
//   //                 ),
//   //               ),
//   //               Positioned(
//   //                 bottom: -30,
//   //                 child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),border: Border.all(color: AppColor.black,width: 2)),child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),child: AppImage.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrZ1_bGUdf2jpsd3ki-uu0xOdcEaz1M0K8x1U1d3BO0jY_ZdKFoQj6KpxFseAW1kYbP_U&usqp=CAU",height: 120,width: 100,))),
//   //               ),
//   //             ],
//   //           ),
//   //
//   //           // 🔹 Name + Patient ID
//   //           Column(
//   //             children: [
//   //               Container(
//   //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//   //                 decoration: BoxDecoration(
//   //                   color: AppColor.yellow,
//   //                   borderRadius: BorderRadius.circular(12),
//   //                 ),
//   //                 child: const Text(
//   //                   "Madison Smith",
//   //                   style: TextStyle(
//   //                     color: AppColor.black,
//   //                     fontWeight: FontWeight.w600,
//   //                   ),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 4),
//   //               Text(
//   //                 "${AppString.patientId} : 1001",
//   //                 style: const TextStyle(color: AppColor.textBlack),
//   //               ),
//   //             ],
//   //           ),
//   //           const SizedBox(height: 20),
//   //
//   //           // 🔹 Profile Info List
//   //           Expanded(
//   //             child: SingleChildScrollView(
//   //               padding: const EdgeInsets.symmetric(horizontal: 16),
//   //               child: Column(
//   //                 children: [
//   //                   ProfileInfoTile(
//   //                     label: AppString.mobileNumber,
//   //                     value: "+91 98765 43210",
//   //                     leading: Row(
//   //                       children: [
//   //                         AppImage.network("https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png",height: 25,width: 35),
//   //                         Container(height: 30,width: 0.5,color: AppColor.yellow,margin: EdgeInsets.only(left: 10),)
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.gender,
//   //                     value: "Female",
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.city,
//   //                     value: "Surat",
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.country,
//   //                     value: "India",
//   //                     leading: Row(
//   //                       children: [
//   //                         AppImage.network("https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png",height: 25,width: 35),
//   //                         Container(height: 30,width: 0.5,color: AppColor.yellow,margin: EdgeInsets.only(left: 10),)
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.language,
//   //                     value: "English",
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.age,
//   //                     value: "20",
//   //                   ),
//   //                   ProfileInfoTile(
//   //                     label: AppString.weight,
//   //                     value: "75 kg",
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           )
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
//
// class ProfileInfoTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final Widget? leading;
//
//   const ProfileInfoTile({
//     super.key,
//     required this.label,
//     required this.value,
//     this.leading,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$label :",
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: AppColor.textBlack,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             decoration: BoxDecoration(
//               color: AppColor.black,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColor.yellow, width: 1),
//             ),
//             child: Row(
//               children: [
//                 if (leading != null) leading!,
//                 if (leading != null) const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     value,
//                     style: const TextStyle(
//                       color: AppColor.yellow,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
