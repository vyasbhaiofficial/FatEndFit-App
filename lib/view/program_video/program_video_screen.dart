// import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
// import 'package:fat_end_fit/utils/common/app_image.dart';
// import 'package:fat_end_fit/view/program_video/program_video_details/program_video_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../utils/app_color.dart';
// import '../../utils/app_strings.dart';
// import '../../utils/common/app_text.dart';
// import '../../utils/common/common_line.dart';
//
// class DayProgramVideosScreen extends StatelessWidget {
//   const DayProgramVideosScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Dummy video list
//     final videos = [
//       ProgramVideoModel(thumbnail: 'https://centerforfamilymedicine.com/wp-content/uploads/2020/06/Center-for-family-medicine-The-Health-Benefits-of-Eating-10-Servings-Of-Fruits-_-Veggies-Per-Day.jpg'),
//       ProgramVideoModel(thumbnail: 'https://centerforfamilymedicine.com/wp-content/uploads/2020/06/Center-for-family-medicine-The-Health-Benefits-of-Eating-10-Servings-Of-Fruits-_-Veggies-Per-Day.jpg'),
//       ProgramVideoModel(thumbnail: 'https://centerforfamilymedicine.com/wp-content/uploads/2020/06/Center-for-family-medicine-The-Health-Benefits-of-Eating-10-Servings-Of-Fruits-_-Veggies-Per-Day.jpg'),
//     ];
//
//     return Scaffold(
//       backgroundColor: AppColor.background,
//       appBar: AppBar(
//         surfaceTintColor: AppColor.white,
//         leading: backButton(marginTop: 12,marginBottom: 12,marginRight: 7),
//         title: AppText("${AppString.day.toLowerCase().capitalizeFirst } - 00"?? '',fontWeight: FontWeight.bold,fontSize: 20,),
//         centerTitle: true,
//         backgroundColor: AppColor.white,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 16),
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(onTap: () {
//             Get.to(()=>ProgramVideoDetailsScreen());
//           },child: ProgramVideoCard(video: videos[index],index: index + 1,));
//         },
//       ),
//     );
//   }
// }
//
// class ProgramVideoCard extends StatelessWidget {
//   final ProgramVideoModel video;
//   final int index;
//
//   const ProgramVideoCard({super.key, required this.video, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only( left: 16, right: 16, bottom: 10),
//       child: Column(
//         children: [
//           Container(width: Get.width,height:50,decoration: BoxDecoration(color: AppColor.yellow.withOpacity(0.6),borderRadius: BorderRadius.circular(30),border: Border.all(width: 1,color: AppColor.black)),child: Center(child: AppText(video.title ?? "${AppString.programVideo} - ${index}",fontWeight: FontWeight.bold,)),),
//           SizedBox(height: 12,),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: AppImage.network(
//               video.thumbnail,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 180,
//             ),
//           ),
//           SizedBox(height: 10,),
//           CustomLine(),
//         ],
//       ),
//     );
//   }
// }
//
// class ProgramVideoModel {
//   final String thumbnail;
//   final String? title;
//
//   ProgramVideoModel({required this.thumbnail,this.title});
// }
//
//
import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/program_video/program_video_controller.dart';
import 'package:fat_end_fit/view/program_video/program_video_details/program_video_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_text.dart';
import '../../utils/common/common_line.dart';
import 'model/program_video_model.dart';
class DayProgramVideosScreen extends StatefulWidget {
  DayProgramVideosScreen({super.key});

  @override
  State<DayProgramVideosScreen> createState() => _DayProgramVideosScreenState();
}

class _DayProgramVideosScreenState extends State<DayProgramVideosScreen> {
  final controller = Get.put(ProgramVideoController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int data = Get.arguments as int;
    controller.day.value = data;
    controller.fetchVideos();
  }
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // infinite scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchVideos();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        surfaceTintColor: AppColor.white,
        leading: backButton(
            marginTop: 12, marginBottom: 12, marginRight: 7),
        title: AppText(
          "${AppString.day.toLowerCase().capitalizeFirst} - ${ controller.day.value.toString().padLeft(2, '0')}",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.videos.isEmpty) {
          return const Center(child: AppLoaderWidget());
        }

        if (controller.videos.isEmpty) {
          return const Center(child: Text("No Data Found!"));
        }



        return RefreshIndicator(color: AppColor.yellow,triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async => controller.fetchVideos(isRefresh: true),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 36),
            itemCount: controller.videos.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.videos.length) {
                final video = controller.videos[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProgramVideoDetailsScreen(data: video,),
                        arguments: video);
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1,
                    child: ProgramVideoCard(
                        video: video, index: index + 1,length: controller.videos.length +
                        (controller.isMoreLoading.value ? 1 : 0),),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: AppLoaderWidget()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
class ProgramVideoCard extends StatelessWidget {
  final ProgramVideoModel video;
  final int index;
  final int length;

  const ProgramVideoCard({
    super.key,
    required this.video,
    required this.index,
    this.length = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 12, right: 12, bottom: 10),
      child: Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
        decoration: BoxDecoration(color: AppColor.lightGrey,borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.buttonBlack222222,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColor.black),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: AppText(
                  video.title,
                  color: AppColor.textWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AppImage.network(
                getImageUrl(video.thumbnail),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            const SizedBox(height: 10),

            // if(index != length)
            //   const CustomLine(),
          ],
        ),
      ),
    );
  }
}
