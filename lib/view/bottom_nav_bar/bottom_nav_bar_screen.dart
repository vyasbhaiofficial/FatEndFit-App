import 'dart:io';

import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/view/bottom_nav_bar/widget/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../service/connectivity_service.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/common_line.dart';
import '../../utils/common_function.dart';
import '../home/home_screen.dart';
import '../live_section/live_section_screen.dart';
import '../more/more_screen.dart';
import '../my_progress/my_progress_screen.dart';
import '../profile/profile_controller.dart';
import '../testimonial/testimonial_screen.dart';
import 'bottom_nav_bar_controller.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  final BottomNavController controller = Get.put(BottomNavController());
  final PageController pageController = PageController();
  // final profile = Get.put(ProfileController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ConnectivityService>().checkAndShowDialog();
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _screens = [
      const HomeScreen(key: PageStorageKey("home")),
      const MyProgressScreen(key: PageStorageKey("progress")),
      const TestimonialScreen(key: PageStorageKey("testimonial")),
      LiveSectionScreen(key: PageStorageKey("live")),
      MoreScreen(key: PageStorageKey("more")),
    ];

    final List<String> labels = [
      AppString.home,
      AppString.myProgress,
      AppString.testimonial,
      AppString.webinar,
      AppString.more,
    ];

    final List<String> icons = [
      AppImages.homeBarIcon,
      AppImages.myProgressBarIcon,
      AppImages.testimonialBarIcon,
      AppImages.liveBarIcon,
      AppImages.moreBarIcon,
    ];

    return SafeArea(bottom: true,top: false,
      child: WillPopScope(
        onWillPop: () async {
          if (controller.selectedIndex.value != 0) {
            /// Jo current tab index 0 nathi to Home tab par switch
            controller.changeIndex(0);
            return false;
          } else {
            /// Jo already home tab par hoy to Exit bottom sheet show
            // showExitAppSheet();
            return true;
          }
        },
        child: Scaffold(
          // body:  PageView(
          //   controller: pageController,
          //   children: _screens,
          //   onPageChanged: (index) {
          //     controller.changeIndex(index);
          //   },
          // ),
          body: Obx(() =>  _screens[controller.selectedIndex.value],),
          /// Custom Bottom Bar
          // bottomNavigationBar: Obx(
          //       () => Card(
          //     color: AppColor.black,
          //     margin: EdgeInsets.zero,
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //       ),
          //     ),
          //     child: Container(
          //       padding: const EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
          //       decoration: const BoxDecoration(
          //         color: AppColor.black,
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(30),
          //           topRight: Radius.circular(30),
          //         ),
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: List.generate(labels.length, (index) {
          //           final isSelected = controller.selectedIndex.value == index;
          //           return GestureDetector(
          //             behavior: HitTestBehavior.translucent,
          //             onTap: () {
          //               controller.changeIndex(index);
          //               // pageController.jumpToPage(index);
          //               // pageController.animateToPage(
          //               //   index,
          //               //   duration: const Duration(milliseconds: 300),
          //               //   curve: Curves.easeInOut,
          //               // );
          //             },
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 SvgPicture.asset(
          //                   icons[index],
          //                   height: getSize(20,isHeight: true),
          //                   width: getSize(30),
          //                   color: AppString.myProgress == labels[index]
          //                       ? null
          //                       : isSelected
          //                       ? AppColor.yellow
          //                       : Colors.white,
          //                 ),
          //                 const SizedBox(height: 5),
          //                 SizedBox(
          //                   width: (labels[index] == AppString.more || labels[index] == AppString.home)?Get.width * 0.1:Get.width * 0.19,
          //                   child: Text(
          //                     labels[index].toUpperCase(),
          //                     style: TextStyle(
          //                       color: isSelected ? AppColor.yellow : Colors.white,
          //                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          //                       fontSize: getSize(9,isFont: true)/*Get.width * 0.025*/,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                     overflow: TextOverflow.ellipsis,
          //                     maxLines: 1,
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           );
          //         }),
          //       ),
          //     ),
          //   ),
          // ),
          // bottomNavigationBar: CommonBottomBar(
          //   selectedIndex: controller.selectedIndex,
          //   labels: [
          //     AppString.home,
          //     AppString.myProgress,
          //     AppString.testimonial,
          //     AppString.webinar,
          //     AppString.more,
          //   ],
          //   icons: [
          //     AppImages.homeBarIcon,
          //     AppImages.myProgressBarIcon,
          //     AppImages.testimonialBarIcon,
          //     AppImages.liveBarIcon,
          //     AppImages.moreBarIcon,
          //   ],
          //   onTap: (index) => controller.changeIndex(index),
          // ),
        bottomNavigationBar: CustomBottomBar(),
          floatingActionButton: CommonFloatingButton(),

        ),
      ),
    );
  }
}
// import 'dart:io';
// import 'package:fat_end_fit/utils/app_navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../utils/app_color.dart';
// import '../../utils/app_images.dart';
// import '../../utils/app_strings.dart';
// import '../../utils/common_function.dart';
// import '../home/home_screen.dart';
// import '../live_section/live_section_screen.dart';
// import '../more/more_screen.dart';
// import '../my_progress/my_progress_screen.dart';
// import '../testimonial/testimonial_screen.dart';
// import 'bottom_nav_bar_controller.dart';
//
// class BottomNavBarScreen extends StatefulWidget {
//   const BottomNavBarScreen({super.key});
//
//   @override
//   State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
// }
//
// class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
//   final BottomNavController controller = Get.put(BottomNavController());
//   final PageController pageController = PageController();
//   bool _isInitialized = false;
//
//   final List<Widget> _screens = [
//     HomeScreen(),
//     MyProgressScreen(),
//     TestimonialScreen(),
//     LiveSectionScreen(),
//     MoreScreen(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Delay initialization to avoid the PageView error
//     Future.delayed(Duration.zero, () {
//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> labels = [
//       AppString.home,
//       AppString.myProgress,
//       AppString.testimonial,
//       AppString.liveSection,
//       AppString.more,
//     ];
//
//     final List<String> icons = [
//       AppImages.homeBarIcon,
//       AppImages.myProgressBarIcon,
//       AppImages.testimonialBarIcon,
//       AppImages.liveBarIcon,
//       AppImages.moreBarIcon,
//     ];
//
//     return SafeArea(
//       bottom: true,
//       top: false,
//       child: PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) {
//           if (controller.selectedIndex.value != 0) {
//             controller.changeIndex(0);
//             pageController.jumpToPage(0);
//             return;
//           }
//           Navigator.pop(context);
//         },
//         child: Scaffold(
//           body: _isInitialized
//               ? PageView(
//             controller: pageController,
//             physics: const NeverScrollableScrollPhysics(),
//             children: _screens,
//             onPageChanged: (index) {
//               controller.changeIndex(index);
//             },
//           )
//               : const Center(child: CircularProgressIndicator()), // Show loading until initialized
//           bottomNavigationBar: Obx(
//                 () => Card(
//               color: AppColor.black,
//               margin: EdgeInsets.zero,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
//                 decoration: const BoxDecoration(
//                   color: AppColor.black,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: List.generate(labels.length, (index) {
//                     final isSelected = controller.selectedIndex.value == index;
//                     return GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () {
//                         controller.changeIndex(index);
//                         pageController.jumpToPage(index);
//                       },
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SvgPicture.asset(
//                             icons[index],
//                             height: getSize(20, isHeight: true),
//                             width: getSize(30),
//                             color: AppString.myProgress == labels[index]
//                                 ? null
//                                 : isSelected
//                                 ? AppColor.yellow
//                                 : Colors.white,
//                           ),
//                           const SizedBox(height: 5),
//                           SizedBox(
//                             width: (labels[index] == AppString.more || labels[index] == AppString.home)
//                                 ? Get.width * 0.1
//                                 : Get.width * 0.19,
//                             child: Text(
//                               labels[index].toUpperCase(),
//                               style: TextStyle(
//                                 color: isSelected ? AppColor.yellow : Colors.white,
//                                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                 fontSize: getSize(9, isFont: true),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }