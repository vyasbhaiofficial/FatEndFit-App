import 'package:fat_end_fit/utils/app_print.dart';

class TestimonialResponse {
  final String titleVideo;
  final String urlVideo;
  final String thumUrl;
  final List<TestimonialCategory> category;

  TestimonialResponse({
    required this.titleVideo,
    required this.urlVideo,
    required this.thumUrl,
    required this.category,
  });

  factory TestimonialResponse.fromJson(Map<String, dynamic> json) {
    AppLogs.log("json = = = $json");
    return TestimonialResponse(
      titleVideo: json['title'] ?? '',
      urlVideo: json['urlVideo'] ?? '',
      thumUrl: json['thumUrl'] ?? '',
      category: (json['category'] as List? ?? [])
          .map((e) => TestimonialCategory.fromJson(e))
          .toList(),
    );
  }
}

class TestimonialCategory {
  final String categoryId;
  final String categoryTitle;
  final List<TestimonialVideo> list;

  TestimonialCategory({
    required this.categoryId,
    required this.categoryTitle,
    required this.list,
  });

  factory TestimonialCategory.fromJson(Map<String, dynamic> json) {
    return TestimonialCategory(
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      list: (json['list'] as List? ?? [])
          .map((e) => TestimonialVideo.fromJson(e))
          .toList(),
    );
  }
}

class TestimonialVideo {
  final String title;
  final String dec;
  final String thubnail;
  final String videoid;
  final String videoUrl;

  TestimonialVideo({
    required this.title,
    required this.dec,
    required this.thubnail,
    required this.videoid,
    required this.videoUrl,
  });

  factory TestimonialVideo.fromJson(Map<String, dynamic> json) {
    return TestimonialVideo(
      title: json['title'] ?? '',
      dec: json['dec'] ?? '',
      thubnail: json['thubnail'] ?? '',
      videoid: json['videoid'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
