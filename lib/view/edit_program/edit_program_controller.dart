import 'package:get/get.dart';
import '../../utils/app_loader.dart';
import '../../utils/app_print.dart';
import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_toast.dart';
import 'model/edit_question_model.dart';
class EditProgramController extends GetxController {
  final isLoading = false.obs;

  /// Dynamic Questions
  var counterQuestions = <QuestionData>[].obs;
  var textFieldQuestions = <QuestionData>[].obs;

  Future<void> fetchDailyQuestions({String day = ''}) async {
    try {
      isLoading.value = true;

      day = extractDayNumber(day);

      final response = await AppApi.getInstance().get<Map<String, dynamic>>("${ApiConfig.getDailyQuestions}?day=$day");

      if (response.success && response.data != null) {
        AppLogs.log("Fetch: [ fetchDailyQuestions ] START TO ASSIGN DATA...");
        final parsed = DailyQuestionResponse.fromJson(response.data!);
        AppLogs.log("Fetch: [ fetchDailyQuestions ] QUESTION: ${parsed.data.firstQuestions} TEXT FIELD QUESTION: ${parsed.data.lastQuestions} questions");
        counterQuestions.assignAll(parsed.data.firstQuestions);
        textFieldQuestions.assignAll(parsed.data.lastQuestions);
        AppLogs.log("Fetched: [ fetchDailyQuestions ] QUESTION: ${counterQuestions.length} TEXT FIELD QUESTION: $textFieldQuestions questions");
      } else {
        counterQuestions.clear();
        textFieldQuestions.clear();
      }
    } catch (e) {
      counterQuestions.clear();
      textFieldQuestions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String extractDayNumber(String input) {
    final match = RegExp(r'(\d+)$').firstMatch(input);
    if (match != null) {
      return match.group(0)!; // digits (e.g., "01", "10")
    }
    return ""; // fallback if no number found
  }

  /// For counters (increase/decrease)
  void increase(QuestionData q) {
    int current = int.tryParse(q.answer?.value ?? "0") ?? 0;
    q.answer?.value = (current + 1).toString();
    counterQuestions.refresh();
  }

  void decrease(QuestionData q) {
    int current = int.tryParse(q.answer?.value ?? "0") ?? 0;
    if (current > 0) {
      q.answer?.value = (current - 1).toString();
      counterQuestions.refresh();
    }
  }

  Future<void> submitDailyQuestions({required String day}) async {
    if (counterQuestions.isEmpty && textFieldQuestions.isEmpty) {
      AppToast.error("No answers to submit");
      return;
    }

    day = extractDayNumber(day);

    try {
      AppLoader.show(); // 🔹 Show loader

      // Collect answers from both types
      final allAnswers = [
        ...counterQuestions.map((q) => {
          "questionId": q.id,
          "answer": int.tryParse(q.answer.value) ?? q.answer.value,
        }),
        ...textFieldQuestions.map((q) => {
          "questionId": q.id,
          "answer": q.answer.value,
        }),
      ]
      // remove empty answers
          .where((ans) =>
      ans["answer"] != null &&
          ans["answer"].toString().trim().isNotEmpty)
          .toList();

      final body = {
        "answers": allAnswers,
      };


      AppLogs.log("EDIT PROGRAM BODY: $body");

      final response = await AppApi.getInstance().post<Map<String, dynamic>>(
        "${ApiConfig.submitDailyReports}?day=$day",
        data: body,
      );

      if (response.success) {
        // Get.back();
        AppToast.success(response.data?["message"] ?? "Submitted successfully");
      } else {
        AppToast.error("${response.message}" ?? "Failed to submit answers");
      }
    } catch (e) {
      AppLoader.hide(); // 🔹 Hide loader
      AppToast.error("Error: $e");
    } finally {
      AppLoader.hide(); // 🔹 Hide loader
      Get.back();

    }
  }
}




// class EditProgramController extends GetxController {
//   /// Loader
//   final isLoading = false.obs;
//
//   /// Daily Question Data
//   var questions = <QuestionData>[].obs;
//   var textFieldQuestions = <QuestionData>[].obs;
//   @override
//   onInit(){
//     super.onInit();
//     fetchDailyQuestions();
//   }
//
//   /// Fetch Daily Questions API
//   Future<void> fetchDailyQuestions() async {
//     try {
//       isLoading.value = true;
//
//       final response =
//       await AppApi.getInstance().get<Map<String, dynamic>>(ApiConfig.getDailyQuestions);
//
//       if (response.success && response.data != null) {
//         AppLogs.log("[ Fetched ] = [ fetchDailyQuestions ] = response.data = = ${response.data }");
//         final parsed = DailyQuestionResponse.fromJson(response.data!);
//
//         questions.assignAll(parsed.data.firstQuestions);
//         textFieldQuestions.assignAll(parsed.data.lastQuestions);
//
//         AppLogs.log("Fetched: [ fetchDailyQuestions ] QUESTION: ${questions.length} TEXT FIELD QUESTION: $textFieldQuestions questions");
//         AppLogs.log("Daily Questions: ${parsed.data}", tag: "DAILY_Q");
//       } else {
//         AppLogs.log("Failed to fetch daily questions", tag: "DAILY_Q");
//       }
//     } catch (e) {
//       AppLogs.log("Error fetching daily questions: $e", tag: "DAILY_Q");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
// }
