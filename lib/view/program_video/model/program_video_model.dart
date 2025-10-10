class ProgramVideoModel {
  final String id;
  final String title;
  final String video;
  final String description;
  final String thumbnail;
  final int day;
  final int type;
  final int videoSec;
  final double videoSize;
  final UserVideoProgress? userVideoProgress;
  bool userAnswer;
  final List<UserAnswerData> userAnswerData;
  final AnswerStats? answerStats;

  ProgramVideoModel({
    required this.id,
    required this.title,
    required this.video,
    required this.description,
    required this.thumbnail,
    required this.day,
    required this.type,
    required this.videoSec,
    required this.videoSize,
    required this.userVideoProgress,
    required this.userAnswer,
    required this.userAnswerData,
    required this.answerStats,
  });

  factory ProgramVideoModel.fromJson(Map<String, dynamic> json) {
    return ProgramVideoModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      video: json["video"] ?? "",
      description: json["description"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      day: json["day"] is int ? json["day"] : 0,
      type: json["type"] is int ? json["type"] : 0,
      videoSec: json["videoSec"] is int ? json["videoSec"] : 0,
      videoSize: (json["videoSize"] ?? 0).toDouble(),
      userVideoProgress: json["userVideoProgress"] != null
          ? UserVideoProgress.fromJson(json["userVideoProgress"])
          : null,
      userAnswer: json["userAnswer"] ?? false,
      userAnswerData: (json["userAnswerData"] as List<dynamic>?)
          ?.map((e) => UserAnswerData.fromJson(e))
          .toList() ??
          [],
      answerStats: json["answerStats"] != null
          ? AnswerStats.fromJson(json["answerStats"])
          : null,
    );
  }
}

class UserVideoProgress {
  final int watchedSeconds;
  final int lastWatchedAt;
  final bool isCompleted;

  UserVideoProgress({
    required this.watchedSeconds,
    required this.lastWatchedAt,
    required this.isCompleted,
  });

  factory UserVideoProgress.fromJson(Map<String, dynamic> json) {
    return UserVideoProgress(
      watchedSeconds:
      json["watchedSeconds"] is int ? json["watchedSeconds"] : 0,
      lastWatchedAt:
      json["lastWatchedAt"] is int ? json["lastWatchedAt"] : 0,
      isCompleted: json["isCompleted"] ?? false,
    );
  }
}

class UserAnswerData {
  final String id;
  final List<Answer> answers;

  UserAnswerData({
    required this.id,
    required this.answers,
  });

  factory UserAnswerData.fromJson(Map<String, dynamic> json) {
    return UserAnswerData(
      id: json["_id"] ?? "",
      answers: (json["answers"] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Answer {
  final String questionId;
  final dynamic answer; // can be bool/int/string
  final bool isCorrect;
  final String id;

  Answer({
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    required this.id,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json["questionId"] ?? "",
      answer: json["answer"],
      isCorrect: json["isCorrect"] ?? false,
      id: json["_id"] ?? "",
    );
  }
}

class AnswerStats {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalAnswers;

  AnswerStats({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalAnswers,
  });

  factory AnswerStats.fromJson(Map<String, dynamic> json) {
    return AnswerStats(
      correctAnswers:
      json["correctAnswers"] is int ? json["correctAnswers"] : 0,
      wrongAnswers:
      json["wrongAnswers"] is int ? json["wrongAnswers"] : 0,
      totalAnswers:
      json["totalAnswers"] is int ? json["totalAnswers"] : 0,
    );
  }
}

// class ProgramVideoModel {
//   final String id;
//   final String title;
//   final String video;
//   final String description;
//   final String thumbnail;
//   final int day;
//   final int type;
//   final int videoSec;
//   final double videoSize;
//   final UserVideoProgress? userVideoProgress;
//   bool userAnswer;
//
//   ProgramVideoModel({
//     required this.id,
//     required this.title,
//     required this.video,
//     required this.description,
//     required this.thumbnail,
//     required this.day,
//     required this.type,
//     required this.videoSec,
//     required this.videoSize,
//     required this.userVideoProgress,
//     required this.userAnswer,
//   });
//
//   factory ProgramVideoModel.fromJson(Map<String, dynamic> json) {
//     return ProgramVideoModel(
//       id: json["_id"] ?? "",
//       title: json["title"] ?? "",
//       video: json["video"] ?? "",
//       description: json["description"] ?? "",
//       thumbnail: json["thumbnail"] ?? "",
//       day: json["day"] is int ? json["day"] : 0,
//       type: json["type"] is int ? json["type"] : 0,
//       videoSec: json["videoSec"] is int ? json["videoSec"] : 0,
//       videoSize: (json["videoSize"] ?? 0).toDouble(),
//       userVideoProgress: json["userVideoProgress"] != null
//           ? UserVideoProgress.fromJson(json["userVideoProgress"])
//           : null,
//       userAnswer: json["userAnswer"] ?? false,
//     );
//   }
//
// }
//
// class UserVideoProgress {
//   final int watchedSeconds;
//   final int lastWatchedAt;
//   final bool isCompleted;
//
//   UserVideoProgress({
//     required this.watchedSeconds,
//     required this.lastWatchedAt,
//     required this.isCompleted,
//   });
//
//   factory UserVideoProgress.fromJson(Map<String, dynamic> json) {
//     return UserVideoProgress(
//       watchedSeconds: json["watchedSeconds"] is int ? json["watchedSeconds"] : 0,
//       lastWatchedAt: json["lastWatchedAt"] is int ? json["lastWatchedAt"] : 0,
//       isCompleted: json["isCompleted"] ?? false,
//     );
//   }
//
// }
// class ProgramVideoModel {
//   final String id;
//   final MultiLangText? title;
//   final MultiLangText? video;
//   final MultiLangText? description;
//   final MultiLangText? thumbnail;
//   final int day;
//   final int type;
//   final int videoSec;
//   final double videoSize;
//   final UserVideoProgress? userVideoProgress;
//   final bool userAnswer;
//
//   ProgramVideoModel({
//     required this.id,
//     required this.title,
//     required this.video,
//     required this.description,
//     required this.thumbnail,
//     required this.day,
//     required this.type,
//     required this.videoSec,
//     required this.videoSize,
//     required this.userVideoProgress,
//     required this.userAnswer,
//   });
//
//   factory ProgramVideoModel.fromJson(Map<String, dynamic> json) {
//     return ProgramVideoModel(
//       id: json["_id"] ?? "",
//       title: json["title"] != null ? MultiLangText.fromJson(json["title"]) : null,
//       video: json["video"] != null ? MultiLangText.fromJson(json["video"]) : null,
//       description: json["description"] != null ? MultiLangText.fromJson(json["description"]) : null,
//       thumbnail: json["thumbnail"] != null ? MultiLangText.fromJson(json["thumbnail"]) : null,
//       day: json["day"] is int ? json["day"] : 0,
//       type: json["type"] is int ? json["type"] : 0,
//       videoSec: json["videoSec"] is int ? json["videoSec"] : 0,
//       videoSize: (json["videoSize"] ?? 0).toDouble(),
//       userVideoProgress: json["userVideoProgress"] != null
//           ? UserVideoProgress.fromJson(json["userVideoProgress"])
//           : null,
//       userAnswer: json["userAnswer"] ?? false,
//     );
//   }
// }
//
// /// 🔹 For handling language-wise fields
// class MultiLangText {
//   final String? english;
//   final String? gujarati;
//   final String? hindi;
//
//   MultiLangText({this.english, this.gujarati, this.hindi});
//
//   factory MultiLangText.fromJson(Map<String, dynamic> json) {
//     return MultiLangText(
//       english: json["english"],
//       gujarati: json["gujarati"],
//       hindi: json["hindi"],
//     );
//   }
// }
//
// class UserVideoProgress {
//   final int watchedSeconds;
//   final int lastWatchedAt;
//   final bool isCompleted;
//
//   UserVideoProgress({
//     required this.watchedSeconds,
//     required this.lastWatchedAt,
//     required this.isCompleted,
//   });
//
//   factory UserVideoProgress.fromJson(Map<String, dynamic> json) {
//     return UserVideoProgress(
//       watchedSeconds: json["watchedSeconds"] is int ? json["watchedSeconds"] : 0,
//       lastWatchedAt: json["lastWatchedAt"] is int ? json["lastWatchedAt"] : 0,
//       isCompleted: json["isCompleted"] ?? false,
//     );
//   }
// }
