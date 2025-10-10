import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/view/program_question/program_question_controller.dart';
import 'package:fat_end_fit/view/program_question/widget/question_result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_print.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_button_v1.dart';
import '../../utils/common_function.dart';
import '../program_video/model/program_video_model.dart';





class ProgramQuestionsScreen extends StatefulWidget {
  ProgramQuestionsScreen({super.key});

  @override
  State<ProgramQuestionsScreen> createState() => _ProgramQuestionsScreenState();
}

class _ProgramQuestionsScreenState extends State<ProgramQuestionsScreen> {
  final QuestionController controller = Get.put(QuestionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProgramVideoModel data = Get.arguments;

    controller.fetchQuestions(data.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 16, bottom: 16),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(marginBottom: 0,marginTop: 0,marginRight: 0),
                  Text(
                    AppString.programQuestions,
                    style:  TextStyle(
                      fontSize: getSize(15,isFont: true),
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.1,)
                ],
              ),
            ),

            // Question List
            // Expanded(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.symmetric(horizontal: 22),
            //     itemCount: controller.questions.length,
            //     itemBuilder: (context, index) {
            //       final q = controller.questions[index];
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 8),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "${index + 1}. ${q.question}",
            //               style: const TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //                 color: AppColor.black,
            //               ),
            //             ),
            //             const SizedBox(height: 10),
            //             Row(
            //               children: [
            //                 SizedBox(width: Get.width * 0.05), // Spacing between options
            //
            //                 // A Option
            //                 Expanded(
            //                   child: GestureDetector(
            //                     onTap: () => controller.selectAnswer(q.id, "yes", "A",onSelected: ()=> setState(() {})),
            //                     child: Container(
            //                       height: 45,
            //                       decoration: BoxDecoration(
            //                         color: AppColor.yellow.withOpacity(0.5),
            //                         borderRadius: BorderRadius.circular(30),
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //
            //                         children: [
            //                           CircleAvatar(maxRadius: 16,child: controller.isSelected(q.id, "A")
            //                               ? const Icon(Icons.check, color: AppColor.white)
            //                               : const Text(
            //                             "A",
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                               color: AppColor.white,
            //                             ),
            //                           ),backgroundColor: AppColor.black,),
            //                           const Text("Yes",
            //                               style: TextStyle(color: AppColor.black)),
            //                           const SizedBox(width: 6),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                  SizedBox(width: Get.width * 0.1), // Spacing between options
            //                 // B Option
            //                 Expanded(
            //                   child: GestureDetector(
            //                     onTap: () => controller.selectAnswer(q.id, "no", "B",onSelected: ()=> setState(() {})),
            //                     child: Container(
            //                       height: 45,
            //                       decoration: BoxDecoration(
            //                         color: AppColor.yellow.withOpacity(0.5),
            //                         borderRadius: BorderRadius.circular(30),
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                         children: [
            //                           CircleAvatar(maxRadius: 16,child: controller.isSelected(q.id, "B")
            //                               ? const Icon(Icons.check, color: AppColor.white)
            //                               : const Text(
            //                             "B",
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                               color: AppColor.white,
            //                             ),
            //                           ),backgroundColor: AppColor.black,),
            //                           const Text("No",
            //                               style: TextStyle(color: AppColor.black)),
            //                           const SizedBox(width: 6),
            //                           // SizedBox(),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(width: Get.width * 0.05), // Spacing between options
            //
            //               ],
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   )
            // ),
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(child: const Center(child: AppLoaderWidget()));
              }

              if (controller.questions.isEmpty) {
                return Expanded(
                  child: const Center(
                    child: Text(
                      "No questions available",
                      style: TextStyle(color: AppColor.black, fontSize: 16),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: controller.questions.length,
                  itemBuilder: (context, index) {
                    final q = controller.questions[index];
                    // return Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "${index + 1}. ${q.question}",
                    //         style: const TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColor.black,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 10),
                    //
                    //       // Options row
                    //       Row(
                    //         children: [
                    //           SizedBox(width: Get.width * 0.05),
                    //
                    //           // A Option
                    //           Expanded(
                    //             child: GestureDetector(
                    //               onTap: () => controller.selectAnswer(
                    //                 q.id,
                    //                 "yes",
                    //                 "A",
                    //                 onSelected: () => setState(() {}),
                    //               ),
                    //               child: Container(
                    //                 height: 45,
                    //                 decoration: BoxDecoration(
                    //                   color: AppColor.yellow.withOpacity(0.5),
                    //                   borderRadius: BorderRadius.circular(30),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                   children: [
                    //                     CircleAvatar(
                    //                       maxRadius: 16,
                    //                       backgroundColor: AppColor.black,
                    //                       child: controller.isSelected(q.id, "A")
                    //                           ? const Icon(Icons.check,
                    //                           color: AppColor.white)
                    //                           : const Text(
                    //                         "A",
                    //                         style: TextStyle(
                    //                             fontWeight: FontWeight.bold,
                    //                             color: AppColor.white),
                    //                       ),
                    //                     ),
                    //                     const Text("Yes",
                    //                         style: TextStyle(color: AppColor.black)),
                    //                     const SizedBox(width: 6),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //
                    //           SizedBox(width: Get.width * 0.1),
                    //
                    //           // B Option
                    //           Expanded(
                    //             child: GestureDetector(
                    //               onTap: () => controller.selectAnswer(
                    //                 q.id,
                    //                 "no",
                    //                 "B",
                    //                 onSelected: () => setState(() {}),
                    //               ),
                    //               child: Container(
                    //                 height: 45,
                    //                 decoration: BoxDecoration(
                    //                   color: AppColor.yellow.withOpacity(0.5),
                    //                   borderRadius: BorderRadius.circular(30),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                   children: [
                    //                     CircleAvatar(
                    //                       maxRadius: 16,
                    //                       backgroundColor: AppColor.black,
                    //                       child: controller.isSelected(q.id, "B")
                    //                           ? const Icon(Icons.check,
                    //                           color: AppColor.white)
                    //                           : const Text(
                    //                         "B",
                    //                         style: TextStyle(
                    //                             fontWeight: FontWeight.bold,
                    //                             color: AppColor.white),
                    //                       ),
                    //                     ),
                    //                     const Text("No",
                    //                         style: TextStyle(color: AppColor.black)),
                    //                     const SizedBox(width: 6),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //
                    //           SizedBox(width: Get.width * 0.05),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white,
                         borderRadius: BorderRadius.circular(20),
                         boxShadow: [
                           BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                           )
                         ]
                        ),
                        padding: EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question
                            Text(
                              q.question,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Options Row
                            Row(
                              children: [
                                const SizedBox(width: 8),

                                // YES option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.selectAnswer(
                                      q.id,
                                      "yes",
                                      "A",
                                      onSelected: () => setState(() {}),
                                    ),
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        // border: Border.all(
                                        //   color: controller.isSelected(q.id, "A")
                                        //       ? AppColor.yellow
                                        //       : AppColor.primary,
                                        //   width: 2,
                                        // ),
                                        // color: controller.isSelected(q.id, "A")
                                        //     ? AppColor.yellow
                                        //     : Colors.transparent,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            controller.isSelected(q.id, "A")
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: controller.isSelected(q.id, "A")
                                                ? AppColor.yellow
                                                : AppColor.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          // Text(
                                          //   "Yes",
                                          //   style: TextStyle(
                                          //     fontWeight: FontWeight.w600,
                                          //     color: controller.isSelected(q.id, "A")
                                          //         ? AppColor.black
                                          //         : AppColor.primary,
                                          //   ),
                                          // ),
                                          Container(
                                            // width: 100,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: controller.isSelected(q.id, "A")
                                                  ? AppColor.yellow
                                                  : AppColor.primary,
                                            ),
                                            padding: EdgeInsets.only(left: Get.width * 0.06,right: Get.width * 0.06,top: 4,bottom: 5),
                                            child: Text(
                                              AppString.yes.capitalizeFirst ?? "Yes",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: controller.isSelected(q.id, "A")
                                                    ? AppColor.textBlack
                                                    : AppColor.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // NO option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.selectAnswer(
                                      q.id,
                                      "no",
                                      "B",
                                      onSelected: () => setState(() {}),
                                    ),
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        // border: Border.all(
                                        //   color: controller.isSelected(q.id, "B")
                                        //       ? AppColor.yellow
                                        //       : AppColor.primary,
                                        //   width: 2,
                                        // ),
                                        // color: controller.isSelected(q.id, "B")
                                        //     ? AppColor.primary
                                        //     : Colors.transparent,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            controller.isSelected(q.id, "B")
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: controller.isSelected(q.id, "B")
                                                ? AppColor.yellow
                                                : AppColor.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            // width: 100,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: controller.isSelected(q.id, "B")
                                                  ? AppColor.yellow
                                                  : AppColor.primary,
                                            ),
                                            padding: EdgeInsets.only(left: Get.width * 0.06,right: Get.width * 0.06,top: 4,bottom: 5),
                                            child: Text(
                                              AppString.no.capitalizeFirst ?? 'No',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: controller.isSelected(q.id, "B")
                                                    ? AppColor.textBlack
                                                    : AppColor.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                ),
              );
            }),

            // Submit Button
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: CommonButton(
            //     text: AppString.submit,
            //     isBlackButton: true,
            //     onTap: () {
            //       // if (!controller.isAllAnswered()) {
            //       //   // Get.snackbar("Error", "Please answer all questions",
            //       //   //     backgroundColor: Colors.red.withOpacity(0.8),
            //       //   //     colorText: Colors.white);
            //       // } else {
            //       //   print(controller.selectedAnswers.values.toList());
            //       //   // Get.snackbar("Success", "Answers submitted successfully!",
            //       //   //     backgroundColor: Colors.green.withOpacity(0.8),
            //       //   //     colorText: Colors.white);
            //       // }
            //     },
            //   ),
            // ),
            
            Obx(() => controller.isLoading.value || controller.questions.isEmpty?SizedBox():Padding(
              padding: const EdgeInsets.all(16),
              child: CommonButton(
                text: AppString.submit,
                // isBlackButton: true,
                buttonColor: AppColor.yellow,
                buttonTextColor: AppColor.textBlack,
                onTap: () async {
                  if (!controller.isAllAnswered()) {
                    AppToast.error("Please answer all questions.");
                    return;
                  }

                  AppLogs.log("ALL QUESTION ANSWERED: ${controller.selectedAnswers}");
                  // ✅ Calculate score
                  int total = controller.questions.length;
                  int correct = 0;
                  int wrong = 0;

                  for (var q in controller.questions) {
                    final selected = controller.selectedAnswers[q.id];
                    if (selected == null) continue;

                    // Suppose selected = "A" / "B" → map to Yes/No (base meaning)
                    final selectedText = selected == "A" ? "Yes" : "No";

                    // 🔹 Define multi-language synonyms
                    final yesList = ["yes", "संपर्क संख्या", "हाँ", "હા", "હા છે", "ha", "haan"];
                    final noList = ["no", "नहीं", "ना", "ના", "nahi"];

                    // convert correctAnswer into lowercase
                    final correctAnswer = q.correctAnswer.toLowerCase();

                    bool isCorrect = false;

                    if (yesList.contains(selectedText.toLowerCase()) &&
                        yesList.contains(correctAnswer)) {
                      isCorrect = true;
                    } else if (noList.contains(selectedText.toLowerCase()) &&
                        noList.contains(correctAnswer)) {
                      isCorrect = true;
                    }

                    if (isCorrect) {
                      correct++;
                    } else {
                      wrong++;
                    }
                  }


                  double percent = (correct / total) * 100;
                  ProgramVideoModel data = Get.arguments;

                  bool isContinue = await controller.submit(videoId: data.id);
                  if(isContinue) {
                    data.userAnswer = true;
                    controller.showResultBottomSheet(correct: correct,wrong: wrong,percent: percent);
                  }
                },
              ),
            ),)

          ],
        ),
      ),
    );
  }
}
