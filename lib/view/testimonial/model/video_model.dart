// video_model.dart
class VideoModel {
  final String videoUrl;
  final String title;
  final String description;

  VideoModel({
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoUrl: json['videoUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['dec'] ?? '',
    );
  }
}
