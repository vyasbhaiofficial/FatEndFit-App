import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/view/live_section/webinar_video/webinar_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_common_back_button.dart';
import '../../utils/common/app_text.dart';
import '../program_video/model/program_video_model.dart';
import '../program_video/program_video_controller.dart';
import '../program_video/program_video_details/program_video_details_screen.dart';
import '../program_video/program_video_screen.dart';
import 'live_section_controller.dart';
class LiveSectionScreen extends StatelessWidget {
  LiveSectionScreen({super.key});

  final controller = Get.put(WebinarVideoController()); // type=2 for webinars
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchVideos();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: AppText(
          AppString.webinar ?? '',
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.videos.isEmpty) {
          return const Center(child: AppLoaderWidget());
        }

        if(controller.videos.isEmpty){
          return const Center(child: AppText("No Data Found"));
        }

        return RefreshIndicator(
          color: AppColor.yellow,
          onRefresh: () async => controller.fetchVideos(isRefresh: true),
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: controller.videos.length +
                (controller.isMoreLoading.value ? 1 : 0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < controller.videos.length) {
                final video = controller.videos[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => WebinarVideoScreen(data: video,), arguments: video);
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
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
