import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/home/home_controller.dart';
import 'package:flutter/material.dart';

import '../../../utils/common/app_image.dart';
import '../../edit_program/edit_program_screen.dart';
import '../../program_video/program_video_controller.dart';
import '../../program_video/program_video_details/program_video_details_screen.dart';
import '../../program_video/program_video_screen.dart';
import '../model/home_model.dart';
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
class ExpandableCardList extends StatefulWidget {
  final List<DayProgress> items;
  const ExpandableCardList({Key? key, required this.items}) : super(key: key);

  @override
  State<ExpandableCardList> createState() => _ExpandableCardListState();
}
class _ExpandableCardListState extends State<ExpandableCardList> {
  RxInt expandedIndex = 0.obs; // start with none expanded
  final ProgramVideoController programVideoCon = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return widget.items.isEmpty
        ? Center(child: AppText("No Data Found."))
        : RefreshIndicator(
      onRefresh: () => homeController.fetchHomeData(),
      color: AppColor.yellow,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColor.lightGrey,
              AppColor.lightGrey,
              AppColor.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            // final bool isExpanded = expandedIndex.value == index;

            return Obx(() => GestureDetector(
              onTap: () async {
                if (expandedIndex.value == index) {
                  // fetch videos and navigate
                  AppLoader.show();
                  programVideoCon.day.value = item.day;
                  await programVideoCon.fetchVideos(isRefresh: true);
                  AppLoader.hide();

                  if (programVideoCon.videos.length == 1) {
                    Get.to(() => ProgramVideoDetailsScreen(
                      data: programVideoCon.videos[0],
                    ),
                        arguments: programVideoCon.videos[0],transition: Transition.rightToLeftWithFade);
                    return;
                  }
                  Get.to(() => DayProgramVideosScreen(), arguments: item.day,transition: Transition.rightToLeftWithFade);
                  return;
                }
                expandedIndex.value = index;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color:
                  expandedIndex.value == index ? AppColor.yellow : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedCrossFade(
                  firstChild: buildExpandedContent(item),
                  secondChild: buildCollapsedContent(item),
                  crossFadeState: expandedIndex.value == index
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ),);
          },
        ),
      ),
    );
  }

  Widget buildExpandedContent(item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          /// Left: Progress + text
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  "DAY-${item.day.toString().padLeft(2, '0')}",
                  // style: const TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  // ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: item.dayProgressPercent / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.blackColor),
                      ),
                      Center(
                        child: Text(
                          "${item.dayProgressPercent}%",
                          style: const TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blackColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                    ),
                    onPressed: () {
                      Get.to(() => EditProgramScreen(
                          day: item.day.toString().padLeft(2, '0')));
                    },
                    child: AppText(
                      maxLines: 1,
                      AppString.editProgress,
                      color: AppColor.textWhite,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Right: Image
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage.network(
                getImageUrl(item.firstThumbnail),
                fit: BoxFit.cover,
                height: Get.height * 0.18,
                errorWidget: AppImage.network("")
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCollapsedContent(item) {
    return Row(
      children: [
        Text(
          "DAY-${item.day.toString().padLeft(2, '0')}",
          style: const TextStyle(
            color: AppColor.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              const SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: item.dayProgressPercent / 100,
                  minHeight: 8,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColor.yellow),
                  backgroundColor: AppColor.lightGrey,
                ),
              ),
              Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, top: 2),
                  child: Text(
                    "${item.dayProgressPercent}%",
                    style: const TextStyle(
                      color: AppColor.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

// class _ExpandableCardListState extends State<ExpandableCardList> {
//   RxInt expandedIndex = 0.obs;
//   final ProgramVideoController programVideoCon = Get.find();
//   final HomeController homeController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.items.isEmpty
//         ? Center(child: AppText("No Data Found."))
//         : RefreshIndicator(
//       onRefresh: () {
//         return homeController.fetchHomeData();
//       },
//       color: AppColor.yellow,
//       child: Container(
//         margin: EdgeInsets.only(right: 14,left: 14,bottom: 0),
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(/*color: AppColor.lightGrey,*/borderRadius: BorderRadius.circular(16),gradient: LinearGradient(colors: [
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           AppColor.lightGrey,
//           // AppColor.lightGr
//           // ey,
//           // AppColor.lightGrey,
//           AppColor.white,
//         ],begin: Alignment.topCenter,end: Alignment.bottomCenter)),
//         child: ListView.builder(
//           // padding: const EdgeInsets.all(14),
//           itemCount: widget.items.length,
//
//           physics: const AlwaysScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             final item = widget.items[index];
//             final bool isExpanded = expandedIndex.value == index;
//
//             return Obx(
//                   () => GestureDetector(
//                 onTap: () async {
//                   if (expandedIndex.value == index) {
//                     AppLoader.show();
//                     programVideoCon.day.value = item.day;
//                     await programVideoCon.fetchVideos(isRefresh: true);
//                     AppLoader.hide();
//                     if (programVideoCon.videos.length == 1) {
//                       Get.to(
//                             () => ProgramVideoDetailsScreen(
//                           data: programVideoCon.videos[0],
//                         ),
//                         arguments: programVideoCon.videos[0],
//                       );
//                       return;
//                     }
//                     Get.to(() => DayProgramVideosScreen(),
//                         arguments: item.day);
//                     return;
//                   }
//                   expandedIndex.value = index;
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: expandedIndex.value == index ? AppColor.yellow : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: expandedIndex.value == index
//                       ? Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Row(
//                                             children: [
//                         /// Left: Progress + text
//                         Expanded(
//                           flex: 3,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "DAY-${item.day}",
//                                 style: TextStyle(
//                                   color: AppColor.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//
//                               /// Circular progress
//                               SizedBox(
//                                 height: 70,
//                                 width: 70,
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     CircularProgressIndicator(
//                                       value: item.dayProgressPercent / 100,
//                                       strokeWidth: 6,
//                                       backgroundColor: Colors.white,
//                                       valueColor:
//                                       AlwaysStoppedAnimation<Color>(
//                                           AppColor.blackColor),
//                                     ),
//                                     Center(
//                                       child: Text(
//                                         "${item.dayProgressPercent}%",
//                                         style: TextStyle(
//                                           color: AppColor.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//
//                               /// Edit button
//                               SizedBox(height: 30,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColor.blackColor,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                       BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 0),
//                                   ),
//                                   onPressed: () {
//                                     Get.to(()=> EditProgramScreen(day: item.day.toString().padLeft(2, '0')));
//                                   },
//                                   child: AppText(
//                                     maxLines: 1,
//                                     AppString.editProgress,
//                                     // style: TextStyle(
//                                       color: AppColor.textWhite,
//                                       fontSize: 10,
//                                     // ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(width: 8),
//
//                         /// Right: Image
//                         Expanded(
//                           flex: 6,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: AppImage.network(
//                               getImageUrl(item.firstThumbnail),
//                               fit: BoxFit.cover,
//                               height: Get.height * 0.18
//                             ),
//                           ),
//                         ),
//                                             ],
//                                           ),
//                       )
//                       : Row(
//                     children: [
//                       Text(
//                         "DAY-${item.day}",
//                         style: TextStyle(
//                           color: AppColor.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Stack(
//                           alignment: Alignment.centerRight,
//                           children: [
//                             SizedBox(height: 50,),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: LinearProgressIndicator(
//                                 value: item.dayProgressPercent / 100,
//                                 minHeight: 8,
//                                 valueColor:
//                                 AlwaysStoppedAnimation<Color>(
//                                     AppColor.yellow),
//                                 backgroundColor: AppColor.lightGrey,
//                               ),
//                             ),
//                             Positioned(top: 0,
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets.only(right: 6,top: 2),
//                                 child: Text(
//                                   "${item.dayProgressPercent}%",
//                                   style: TextStyle(
//                                     color: AppColor.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ExpandableCardList extends StatefulWidget {
//   final List<DayProgress> items;
//   const ExpandableCardList({Key? key, required this.items}) : super(key: key);
//
//   @override
//   State<ExpandableCardList> createState() => _ExpandableCardListState();
// }
//
// class _ExpandableCardListState extends State<ExpandableCardList> {
//   RxInt expandedIndex = 0.obs;
//   final ProgramVideoController programVideoCon = Get.find();
//   final HomeController homeController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.items.isEmpty?Center(child: AppText("No Data Found."),):
//     RefreshIndicator(onRefresh: () {
//       return homeController.fetchHomeData();
//     },color: AppColor.yellow,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(right: 14,left: 14,top: 7,bottom: 14),
//         itemCount: widget.items.length,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           final item = widget.items[index];
//           final bool isExpanded = expandedIndex.value == index;
//
//           return Obx(() => GestureDetector(
//             onTap: () async {
//               if(expandedIndex.value ==  index) {
//                 AppLoader.show();
//                 programVideoCon.day.value = item.day;
//                 await programVideoCon.fetchVideos(isRefresh: true);
//                 AppLoader.hide();
//                 if(programVideoCon.videos.length == 1){
//                   Get.to(() => ProgramVideoDetailsScreen(data: programVideoCon.videos[0],), arguments: programVideoCon.videos[0]);
//                   return;
//                 }
//                 Get.to(()=>DayProgramVideosScreen(),arguments: item.day);
//                 return;
//               }
//               expandedIndex.value =  index;
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: expandedIndex.value == index?AppColor.yellow:AppColor.black,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Day Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${AppString.day} - ${item.day}",
//                         style: TextStyle(
//                           color: expandedIndex.value == index
//                               ? AppColor.black
//                               : AppColor.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Expanded( // Row ma expand thay
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 20,left: 20),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: LinearProgressIndicator(
//                                   value: (item.dayProgressPercent) / 100,
//                                   minHeight: 18,
//                                   valueColor: AlwaysStoppedAnimation<Color>(expandedIndex.value == index?AppColor.black:AppColor.yellow),
//                                   backgroundColor: AppColor.offWhite,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: /*(item["percentage"] as int) / 100 + Get.width * 0.3*/0),
//                               child: Text(
//                                 "${item.dayProgressPercent}%",
//                                 style:  TextStyle(
//                                   color: expandedIndex.value != index?AppColor.black:AppColor.yellow,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//
//                   // const SizedBox(height: 8),
//
//
//
//                   /// Expandable Image
//                   AnimatedCrossFade(
//                     duration: const Duration(milliseconds: 300),
//                     crossFadeState: expandedIndex.value == index
//                         ? CrossFadeState.showFirst
//                         : CrossFadeState.showSecond,
//                     firstChild: Column(
//                       children: [
//                         const SizedBox(height: 12),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: AppImage.network(
//                             getImageUrl(item.firstThumbnail),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: 150,
//                           ),
//                         ),
//                       ],
//                     ),
//                     secondChild: const SizedBox.shrink(),
//                   )
//                 ],
//               ),
//             ),
//           ),);
//         },
//       ),
//     );
//   }
// }

