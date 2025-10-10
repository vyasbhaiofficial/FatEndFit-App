class HomeProgressResponse {
  final bool success;
  final String message;
  final HomeProgressData? data;

  HomeProgressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory HomeProgressResponse.fromJson(Map<String, dynamic> json) {
    return HomeProgressResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? HomeProgressData.fromJson(json['data'])
          : null,
    );
  }
}

class HomeProgressData {
  final List<DayProgress> progress;
  final bool isHold;

  HomeProgressData({
    required this.progress,
    required this.isHold,
  });

  factory HomeProgressData.fromJson(Map<String, dynamic> json) {
    return HomeProgressData(
      progress: (json['progress'] as List<dynamic>?)
          ?.map((e) => DayProgress.fromJson(e))
          .toList() ??
          [],
      isHold: json['isHold'] ?? false,
    );
  }
}

// class DayProgress {
//   final Thumbnail? firstThumbnail;
//   final int dayProgressPercent;
//   final int day;
//
//   DayProgress({
//     required this.firstThumbnail,
//     required this.dayProgressPercent,
//     required this.day,
//   });
//
//   factory DayProgress.fromJson(Map<String, dynamic> json) {
//     return DayProgress(
//       firstThumbnail: json['firstThumbnail'] != null
//           ? Thumbnail.fromJson(json['firstThumbnail'])
//           : null,
//       dayProgressPercent: json['dayProgressPercent'] ?? 0,
//       day: json['day'] ?? 0,
//     );
//   }
// }
//
// class Thumbnail {
//   final String? english;
//   final String? gujarati;
//   final String? hindi;
//
//   Thumbnail({this.english, this.gujarati, this.hindi});
//
//   factory Thumbnail.fromJson(Map<String, dynamic> json) {
//     return Thumbnail(
//       english: json['english'],
//       gujarati: json['gujarati'],
//       hindi: json['hindi'],
//     );
//   }
// }

class DayProgress {
  final String firstThumbnail;
  final int dayProgressPercent;
  final int day;

  DayProgress({
    required this.firstThumbnail,
    required this.dayProgressPercent,
    required this.day,
  });

  factory DayProgress.fromJson(Map<String, dynamic> json) {
    return DayProgress(
      firstThumbnail: json['firstThumbnail'] ?? '',
      dayProgressPercent: json['dayProgressPercent'] ?? 0,
      day: json['day'] ?? 0,
    );
  }
}
