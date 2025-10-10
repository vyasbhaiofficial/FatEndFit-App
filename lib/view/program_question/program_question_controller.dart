import 'dart:ui';

import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_color.dart';
import '../../utils/app_print.dart';
import '../../utils/app_toast.dart';
import 'model/question_model.dart';
import 'program_question_screen.dart';

// class QuestionController extends GetxController {
//   var selectedAnswers = <String, Map<String, dynamic>>{}.obs;
//   var isLoading = false.obs;
//
//   // Static data (future ma API aavse)
//   List<QuestionModel> questions = [
//     // QuestionModel(id: "v3542366vweby234", question: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
//     // QuestionModel(id: "v3542366vweby235", question: "Second question text goes here."),
//     // QuestionModel(id: "v3542366vweby236", question: "Third question text goes here."),
//     // QuestionModel(id: "v3542366vweby237", question: "Fourth question text goes here."),
//     // QuestionModel(id: "v3542366vweby238", question: "Fifth question text goes here."),
//   ];
//
//   Future<void> fetchQuestions(String videoId) async {
//     try {
//       isLoading.value = true;
//
//       final response = await AppApi.getInstance().get<Map<String, dynamic>>(
//         ApiConfig.getQuestions,
//         queryParameters: {
//           "videoId": videoId,
//         },
//       );
//
//       if (response.success && response.data != null) {
//         AppLogs.log("✅ Questions fetched: ${response.data}", tag: "QUESTIONS");
//       } else {
//         AppLogs.log("❌ Failed to fetch questions: ${response.message}", tag: "QUESTIONS");
//       }
//     } catch (e) {
//       AppLogs.log("🔥 Exception in fetchQuestions: $e", tag: "QUESTIONS");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   void selectAnswer(String qId, String ans, String option,{Function? onSelected}) {
//     selectedAnswers[qId] = {
//       "questionId": qId,
//       "questionAns": ans,
//       "selectedOption": option,
//     };
//     selectedAnswers.refresh();
//     update();
//     if( onSelected!= null)onSelected();
//   }
//
//   bool isSelected(String qId, String option) {
//     return selectedAnswers[qId]?['selectedOption'] == option;
//   }
//
//   // Validation
//   bool isAllAnswered() {
//     return selectedAnswers.length == questions.length;
//   }
// }
class QuestionController extends GetxController {
  var isLoading = false.obs;
  var questions = <QuestionModel>[].obs;

  Future<void> fetchQuestions(String videoId) async {
    try {
      isLoading.value = true;

      final response = await AppApi.getInstance().get<Map<String, dynamic>>(
        ApiConfig.getQuestions,
        queryParameters: {"videoId": videoId},
      );

      if (response.success && response.data != null) {
        final List<dynamic> list = response.data!["data"] ?? [];
        questions.value = list.map((e) => QuestionModel.fromJson(e)).toList();
        AppLogs.log("✅ Questions fetched: ${questions.length}",
            tag: "QUESTIONS");
      } else {
        questions.clear();
        AppLogs.log("❌ Failed: ${response.message}", tag: "QUESTIONS");
      }
    } catch (e) {
      questions.clear();
      AppLogs.log("🔥 Exception: $e", tag: "QUESTIONS");
    } finally {
      isLoading.value = false;
    }
  }

  // selection logic (you already wrote this)
  var selectedAnswers = <String, String>{}.obs; // {questionId: option}
  void selectAnswer(String qId, String value, String option,
      {VoidCallback? onSelected}) {
    selectedAnswers[qId] = option;
    onSelected?.call();
  }

  bool isSelected(String qId, String option) {
    return selectedAnswers[qId] == option;
  }

  bool isAllAnswered() {
    return selectedAnswers.length == questions.length;
  }

  Future<bool> submit({required String videoId}) async {
    AppLoader.show();
    final answers = selectedAnswers.entries.map((entry) {
      final questionId = entry.key;
      final selected = entry.value;

      // Map "A" → true (Yes), "B" → false (No)
      final bool answerValue = selected == "A";

      return {
        "questionId": questionId,
        "answer": answerValue,
      };
    }).toList();

    final body = {
      "videoId": videoId,
      "answers": answers,
    };

    AppLogs.log("SUBMIT BODY: $body", tag: "VIDEO_PROGRESS");

    final response = await AppApi.getInstance()
        .post<Map<String, dynamic>>(ApiConfig.userAnswerSubmit, data: body);
    AppLogs.log("SUBMIT MESSAGE: ${response.message}", tag: "VIDEO_PROGRESS");

    if (response.success) {
      AppLoader.hide();

      AppLogs.log(
        "✅ Answers submitted successfully: ${response.data}",
        tag: "VIDEO_PROGRESS",
      );
      return true;
      // 🔹 Call your result bottom sheet or API here
    } else if(response.message.toLowerCase() == "User Report already exists".toLowerCase()){
      AppLoader.hide();
      AppToast.error("User Report already exists");
      return false;
    } else {
      AppLoader.hide();
      AppLogs.log(
        "❌ Failed to submit answers: ${response.message}",
        tag: "VIDEO_PROGRESS",
        color: Colors.red,
      );
      AppToast.error("Failed to submit answers");
      return false;
    }
    // AppLoader.hide();
  }


}


