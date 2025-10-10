import 'package:get/get.dart';

import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../program_video/model/program_video_model.dart';


class WebinarVideoController extends GetxController {
  var videos = <ProgramVideoModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;

  int start = 0;
  final int limit = 10;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

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
          "type": 2, // 👈 Webinar videos
          "start": start,
          "limit": limit,
        },
      );

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
