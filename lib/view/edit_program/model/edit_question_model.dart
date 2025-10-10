// class DailyQuestionResponse {
//   final bool success;
//   final String message;
//   final List<QuestionData> data;
//
//   DailyQuestionResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory DailyQuestionResponse.fromJson(Map<String, dynamic> json) {
//     return DailyQuestionResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => QuestionData.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class QuestionData {
//   final String id;
//   final String questionText;
//   final int type;
//   final int? v; // optional __v
//
//   QuestionData({
//     required this.id,
//     required this.questionText,
//     required this.type,
//     this.v,
//   });
//
//   factory QuestionData.fromJson(Map<String, dynamic> json) {
//     return QuestionData(
//       id: json['_id'] ?? '',
//       questionText: json['questionText'] ?? '',
//       type: json['type'] ?? 0,
//       v: json['__v'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'questionText': questionText,
//       'type': type,
//       '__v': v,
//     };
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyQuestionResponse {
  final bool success;
  final String message;
  final QuestionSection data;

  DailyQuestionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DailyQuestionResponse.fromJson(Map<String, dynamic> json) {
    return DailyQuestionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: QuestionSection.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class QuestionSection {
  final List<QuestionData> firstQuestions;
  final List<QuestionData> lastQuestions;

  QuestionSection({
    required this.firstQuestions,
    required this.lastQuestions,
  });

  factory QuestionSection.fromJson(Map<String, dynamic> json) {
    return QuestionSection(
      firstQuestions: (json['firstQuestions'] as List<dynamic>? ?? [])
          .map((e) => QuestionData.fromJson(e))
          .toList(),
      lastQuestions: (json['lastQuestions'] as List<dynamic>? ?? [])
          .map((e) => QuestionData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstQuestions': firstQuestions.map((e) => e.toJson()).toList(),
      'lastQuestions': lastQuestions.map((e) => e.toJson()).toList(),
    };
  }
}

// class QuestionData {
//   final String id;
//   final String questionText;
//   final int type;
//   final String section;
//   RxString answer;  // 👈 observable
//   late TextEditingController controller;
//
//   QuestionData({
//     required this.id,
//     required this.questionText,
//     required this.type,
//     required this.section,
//     String? answer,
//   }) : answer = (answer ?? "0").obs;
//
//   factory QuestionData.fromJson(Map<String, dynamic> json) {
//     return QuestionData(
//       id: json['_id'] ?? '',
//       questionText: json['questionText'] ?? '',
//       type: json['type'] ?? 0,
//       section: json['section'] ?? '',
//       answer: json['answer'] ?? "0",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'questionText': questionText,
//       'type': type,
//       'section': section,
//       'answer': answer.value,
//     };
//   }
// }

class QuestionData {
  final String id;
  final String questionText;
  final int type;
  final String section;
  final RxString answer;
  late TextEditingController controller;

  QuestionData({
    required this.id,
    required this.questionText,
    required this.type,
    required this.section,
    String? answer,
  }) : answer = (answer ?? "").obs {
    // 👇 initialize controller once
    controller = TextEditingController(text: this.answer.value);

    // keep controller and answer in sync
    controller.addListener(() {
      this.answer.value = controller.text;
    });
  }

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['_id'] ?? '',
      questionText: json['questionText'] ?? '',
      type: json['type'] ?? 0,
      section: json['section'] ?? '',
      answer: json['answer'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'type': type,
      'section': section,
      'answer': answer.value,
    };
  }
}
