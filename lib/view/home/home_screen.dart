import 'dart:developer';

import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_storage.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/view/home/widget/common_progress_card.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/common/app_text.dart';
import '../../utils/app_images.dart';
import '../../utils/app_navigation.dart';
import '../../utils/common/common_line.dart';
import '../../utils/common_function.dart';
import '../chat/chat_customer_support_screen.dart';
import '../program_video/program_video_controller.dart';
import 'home_controller.dart';


// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//
//       /// Bottom Nav ne parent ma handle karavse (already banaveli che)
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Top Logo
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Center(
//                 child: AppImage.svg(
//                   AppImages.fatEndFitIcon,
//                   height: 50,
//                 ),
//               ),
//             ),
//
//             /// Profile Section
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: AppColor.black,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   /// Profile Pic
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child:AppImage.circularAvatar(radius: 30,
//                       "https://cdn.vectorstock.com/i/1000v/72/44/bodybuilder-logo-icon-on-white-background-vector-18167244.jpg",
//                       // height: 50,
//                       // width: 50,
//                       // fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//
//                   /// Name + Day
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         "Madison Smith",
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.yellow,
//                         maxLines: 1,
//                       ),
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: AppColor.progressYellow,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: AppText(
//                           "${AppString.day} 01",
//                           fontSize: 12,
//                           color: AppColor.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//
//                   /// Hold Program Button
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: AppColor.yellow,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: AppText(
//                       AppString.holdProgram,
//                       fontSize: 12,
//                       color: AppColor.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             resumeProgram(isHold: false),
//
//             /// Progress List
//             Expanded(child: ExpandableCardList()),
//             ///
//             // Expanded(
//             //   child: ListView(
//             //     padding: const EdgeInsets.symmetric(horizontal: 16),
//             //     children:  [
//             //       // CommonProgressCard(
//             //       //   day: "DAY - 04",
//             //       //   percentage: 50,
//             //       //   image: "https://centerforfamilymedicine.com/wp-content/uploads/2020/06/Center-for-family-medicine-The-Health-Benefits-of-Eating-10-Servings-Of-Fruits-_-Veggies-Per-Day.jpg",
//             //       // ),
//             //       // CommonProgressCard(day: "DAY - 03", percentage: 100),
//             //       // CommonProgressCard(day: "DAY - 02", percentage: 100),
//             //       // CommonProgressCard(day: "DAY - 01", percentage: 100),
//             //       // CommonProgressCard(day: "DAY - 00", percentage: 100),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//
//       /// Floating Support Button (bottom right)
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.yellow,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         onPressed: () {
//           Get.to(()=>CustomerSupportChatScreen());
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(7.0),
//           child: AppImage.svg(AppImages.headPhoneIcon),
//         ),
//       ),
//     );
//   }
//
//   Widget resumeProgram({bool isHold = true}) {
//     return isHold == false?SizedBox.shrink():Container(
//       margin: const EdgeInsets.only(top: 13, left: 16, right: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColor.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(children: [
//         SizedBox(width: 10,),
//         Expanded(child: AppText(AppString.yourProgramHasBeenPutOnHold,maxLines: 4,color: AppColor.textWhite,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold,)),
//         SizedBox(width: 10,),
//         Container(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: AppColor.yellow,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: AppText(
//             AppString.resume,
//             fontSize: 12,
//             color: AppColor.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],),
//     );
//   }
// }
// class HomeScreen extends StatefulWidget {
//   HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final HomeController controller = Get.put(HomeController());
//   ProfileController profile = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller.fetchHomeData();
//     controller.userName.value = profile.user.value?.name ?? "User";
//     if(profile.user.value?.image != null) {
//       controller.profileImage.value = profile.user.value!.image;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppLogs.log("User Token: ${AppStorage().read("token")}");
//
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Top Logo
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Center(
//                 child: AppImage.svg(AppImages.fatEndFitIcon, height: 50),
//               ),
//             ),
//
//             /// Profile Section
//             Obx(() => Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: AppColor.black,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: AppImage.circularAvatar(
//                       radius: 30,
//                       controller.profileImage.value,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//
//                   /// Name + Day
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         controller.userName.value,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.yellow,
//                       ),
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: AppColor.progressYellow,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: AppText(
//                           "DAY 0${controller.currentDay.value}",
//                           fontSize: 12,
//                           color: AppColor.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//
//                   /// Hold Program Button
//                   GestureDetector(
//                     onTap: () {
//                       controller.isProgramHold.value =
//                       !controller.isProgramHold.value;
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColor.yellow,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: AppText(
//                         controller.isProgramHold.value
//                             ? AppString.resume
//                             : AppString.holdProgram,
//                         fontSize: 12,
//                         color: AppColor.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//
//             /// Resume/Hold Program Box
//             Obx(() => controller.isProgramHold.value
//                 ? resumeProgram()
//                 : const SizedBox.shrink()),
//
//             /// Progress List
//             // Expanded(
//             //   child: Obx(() {
//             //     if (controller.progressList.isEmpty) {
//             //       return const Center(
//             //         child: Text(
//             //           "No Data Found",
//             //           style: TextStyle(
//             //             fontSize: 16,
//             //             fontWeight: FontWeight.bold,
//             //           ),
//             //         ),
//             //       );
//             //     }
//             //     return ExpandableCardList(items: controller.progressList);
//             //   }),
//             // ),
//            Obx(() =>  Expanded(child: controller.isLoading.value?AppLoaderWidget(size: 40,):ExpandableCardList(items: controller.homeProgressData.value?.progress ?? [])),)
//           ],
//         ),
//       ),
//
//       /// Floating Button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.yellow,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         onPressed: () {
//           Get.to(() => CustomerSupportChatScreen());
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(7.0),
//           child: AppImage.svg(AppImages.headPhoneIcon),
//         ),
//       ),
//     );
//   }
//
//   Widget resumeProgram() {
//     return Container(
//       margin: const EdgeInsets.only(top: 13, left: 16, right: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColor.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 10),
//           Expanded(
//               child: AppText(AppString.yourProgramHasBeenPutOnHold,
//                   maxLines: 4,
//                   color: AppColor.textWhite,
//                   overflow: TextOverflow.ellipsis,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(width: 10),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: AppColor.yellow,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: AppText(
//               AppString.resume,
//               fontSize: 12,
//               color: AppColor.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final ProfileController profile = Get.put(ProfileController());
  final ProgramVideoController programVideoCon = Get.put(ProgramVideoController());

  @override
  void initState() {
    super.initState();
    // profile.refreshUser();
    controller.fetchHomeData();
    profile.fetchUser();
    // print("controller.profileImage.value = profile.user.value!.image == ${profile.user.value!.language}");
    controller.userName.value = profile.user.value?.name ?? "User";
    if (profile.user.value?.image != null) {
      controller.profileImage.value = profile.user.value!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ screen size
    final width = size.width;
    final height = size.height;

    log("User Token: ${AppStorage().read("token")}");

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Logo
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.015),
              child: Center(
                child: Image.asset(AppImages.fatEndFitIcon, height: height * 0.06),
              ),
            ),

            /// Profile Section
            Obx(
                  () => Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: AppImage.circularAvatar(
                        radius: width * 0.08,
                        getImageUrl(profile.user.value?.image),
                        placeholder: AppImage.circularAvatar(AppImages.commonUserIcon,radius: 25),
                        errorWidget: AppImage.circularAvatar(AppImages.commonUserIcon,radius: 25)
                      ),

                    ),
                    SizedBox(width: width * 0.02),

                    /// Name + Day
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            profile.user.value?.name ?? controller.userName.value,
                            fontSize: getSize(14,isFont: true),
                            fontWeight: FontWeight.bold,
                            color: AppColor.textBlack,
                          ),
                          SizedBox(height: height * 0.005),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.025, vertical: height * 0.005),
                            decoration: BoxDecoration(
                              color: AppColor.progressYellow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: AppText(
                              "DAY 0${controller.currentDay.value}",
                              fontSize: getSize(11,isFont: true),
                              color: AppColor.textBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Hold Program Button
                    Obx(() {
                      AppLogs.log("PLAN ${controller.isProgramHold.value}");
                      return GestureDetector(
                        onTap: () async {
                          await controller.holdOrResumePlan(showDialog: true,
                            planId: profile.user.value?.plan ?? '',
                            type: controller.isProgramHold.value?2:1, // Resume
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03, vertical: height * 0.01),
                          decoration: BoxDecoration(
                            color: AppColor.yellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            controller.isProgramHold.value
                                ? AppString.resume
                                : AppString.holdProgram,
                            fontSize: width * 0.03,
                            color: AppColor.textBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },)
                  ],
                ),
              ),
            ),

            /// Resume/Hold Program Box
            Obx(() => controller.isProgramHold.value
                ? resumeProgram(context)
                : const SizedBox(height: 16,)),

            /// Progress List
            Obx(
                  () => Expanded(
                child: controller.isLoading.value
                    ? const AppLoaderWidget(size: 40)
                    : ExpandableCardList(
                  items: controller.homeProgressData.value?.progress ?? [],
                ),
              ),
            ),
          ],
        ),
      ),

      /// Floating Button
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColor.yellow,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      //   onPressed: () {
      //     if (Get.isOverlaysOpen) return;
      //     if (Get.currentRoute == '/CustomerSupportChatScreen') return; // prevent duplicate push
      //
      //     Get.to(() => CustomerSupportChatScreen());
      //   },
      //   child: Padding(
      //     padding: EdgeInsets.all(width * 0.02),
      //     child: AppImage.svg(AppImages.headPhoneIcon),
      //   ),
      // ),
      // floatingActionButton: CommonFloatingButton(),
    );
  }

  Widget resumeProgram(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      margin: EdgeInsets.only(top: height * 0.01, left: width * 0.04, right: width * 0.04),
      padding: EdgeInsets.all(width * 0.03), child: AppText(AppString.yourProgramOnHoldText,color: AppColor.textBlack,maxLines: 3,fontSize: 12,textAlign: TextAlign.center,)
    );
  }
}
