import 'dart:developer';

import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:fat_end_fit/view/profile/profile_screen.dart';
import 'package:fat_end_fit/view/program_video/program_video_details/program_video_details_controller.dart';
import 'package:get/get.dart';
import '../../service/api_config.dart';
import '../../service/api_service.dart';
import 'model/program_video_model.dart';
// String? getLangValue(MultiLangText? data) {
//   if (data == null) return null;
//
//   final profileController = Get.find<ProfileController>();
//   final lang = profileController.user.value?.language.toLowerCase() ?? "english";
//
//   switch (lang) {
//     case "hindi":
//       return data.hindi ?? data.english;
//     case "gujrati":
//     case "gujarati":
//       return data.gujarati ?? data.english;
//     case "english":
//     default:
//       return data.english;
//   }
// }


class ProgramVideoController extends GetxController {
  var videos = <ProgramVideoModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var day = 0.obs;
  int start = 0;
  final int limit = 10;
  bool hasMore = true;

  Future<void> fetchVideos({bool isRefresh = false}) async {
    if (isLoading.value || isMoreLoading.value) return;

    if (isRefresh) {
      start = 0;
      hasMore = true;
      videos.clear();
    }

    if (!hasMore) return;

    if (start == 0) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    try {
      final response = await AppApi.getInstance().get(
        ApiConfig.getProgramVideos, // /user/video/get
        queryParameters: {
          "type": 1, // (1 = day wise, 2 = webinar)
          "start": start,
          "limit": limit,
          "day": day.value.toString(),
        },
      );

      log(" [ FETCH VIDEO ] message = ${response.message}, data = ${response.data}");
      if (response.success) {
        List data = response.data["data"];
        var fetched = data.map((e) => ProgramVideoModel.fromJson(e)).toList();

        if (fetched.length < limit) {
          hasMore = false;
        }
        videos.addAll(fetched);
        start += limit;
      }
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}
// import 'model/program_video_model.dart';
// import 'package:get/get.dart';
// import '../../service/api_config.dart';
// import '../../service/api_service.dart';
// import 'model/program_video_model.dart';
//
// class ProgramVideoController extends GetxController {
//   final int videoType; // 1 = day wise, 2 = webinar
//
//   ProgramVideoController(this.videoType);
//
//   var videos = <ProgramVideoModel>[].obs;
//   var isLoading = false.obs;
//   var isMoreLoading = false.obs;
//
//   int start = 0;
//   final int limit = 10;
//   bool hasMore = true;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchVideos();
//   }
//
//   Future<void> fetchVideos({bool isRefresh = false}) async {
//     if (isLoading.value || isMoreLoading.value) return;
//
//     if (isRefresh) {
//       start = 0;
//       hasMore = true;
//       videos.clear();
//     }
//
//     if (!hasMore) return;
//
//     if (start == 0) {
//       isLoading.value = true;
//     } else {
//       isMoreLoading.value = true;
//     }
//
//     try {
//       final response = await AppApi.getInstance().get(
//         ApiConfig.getProgramVideos, // /user/video/get
//         queryParameters: {
//           "type": videoType, // 👈 pass dynamic type
//           "start": start,
//           "limit": limit,
//         },
//       );
//
//       if (response.success) {
//         List data = response.data["data"];
//         var fetched =
//         data.map((e) => ProgramVideoModel.fromJson(e)).toList();
//
//         if (fetched.length < limit) {
//           hasMore = false;
//         }
//         videos.addAll(fetched);
//         start += limit;
//       }
//     } finally {
//       isLoading.value = false;
//       isMoreLoading.value = false;
//     }
//   }
// }
