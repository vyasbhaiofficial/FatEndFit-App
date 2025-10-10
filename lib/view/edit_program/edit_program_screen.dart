import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/common/app_textfield.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_print.dart';

import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_button_v1.dart';
import '../../utils/common/app_common_back_button.dart';
import '../../utils/common/app_image.dart';
import '../../utils/common/app_text.dart';
import '../../utils/common/common_line.dart';
import 'edit_program_controller.dart';
import 'model/edit_question_model.dart';

// Expanded(
//   child: Obx(() {
//     if (controller.isLoading.value) {
//       return const Center(child: AppLoaderWidget());
//     }
//     if (controller.questions.isEmpty) {
//       return const Center(child: Text("No questions found"));
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       itemCount: controller.questions.length,
//       itemBuilder: (context, index) {
//         final q = controller.questions[index];
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Question Text
//               Row(
//                 children: [
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: AppText(
//                       q.questionText ?? "",
//                       fontSize: getSize(14, isFont: true),
//                     ),
//                   ),
//                 ],
//               ),
//
//               /// Answer Field
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                 child: SizedBox(
//                   height: 45,
//                   child: CommonTextField(
//                     textColor: AppColor.black,
//                     hintText: "",
//                     fillColor: AppColor.yellow,
//                     enabledBorderColor: AppColor.black,
//                     borderRadius: 12,
//                     verticalPadding: 3,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }),
// ),
/// ========================== EDIT PROGRESS =========================///
// class EditProgramScreen extends StatelessWidget {
//   EditProgramScreen({super.key});
//   EditProgramController controller = Get.put(EditProgramController());
//   @override
//   Widget build(BuildContext context) {
//     final RxInt water = 0.obs;
//     final RxInt exercise = 0.obs;
//     final RxInt walk = 0.obs;
//     final RxInt pranayama = 0.obs;
//     final RxInt sleep = 0.obs;
//     final RxInt junk = 0.obs;
//
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Back + Logo
//             Row(
//               children: [
//                 backButton(marginTop: 12, marginBottom: 12, marginRight: 7),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Center(
//                       child: AppImage.svg(
//                         AppImages.fatEndFitIcon,
//                         height: 50,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 32),
//               ],
//             ),
//
//
//
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     /// Each Question
//                     _buildCounterRow(AppString.waterIntake, water),
//                     _buildCounterRow(AppString.exercise, exercise),
//                     _buildCounterRow(AppString.walk, walk),
//                     _buildCounterRow(AppString.pranayama, pranayama),
//                     _buildCounterRow(AppString.sleep, sleep),
//                     _buildCounterRow(AppString.currentWeight, junk),
//                     // _buildCounterRow(AppString.avoidJunkFood, junk),
//
//                     /// Note Box
//                     Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 10,),
//                         Expanded(child: AppText(AppString.whatIsMistakeInEatingHabits,fontSize: getSize(14,isFont: true),)),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
//                       child: SizedBox(height: 45,child: CommonTextField(textColor: AppColor.black,hintText: "",fillColor: AppColor.yellow,enabledBorderColor: AppColor.black,borderRadius: 12,verticalPadding: 3,)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// Submit Button
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: CommonButton(
//                 text: AppString.submit,
//                 isBlackButton: true,
//                 onTap: () {
//                   // TODO: submit logic
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCounterRow(String title, RxInt value) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double screenWidth = constraints.maxWidth;
//
//         // 🔹 Dynamic sizes based on width
//         double buttonSize = screenWidth * 0.12; // circle button size
//         double counterWidth = screenWidth * 0.3; // counter box width
//         double fontSize = screenWidth < 350 ? 12 : 14; // smaller on tiny screens
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.02,
//               vertical: screenWidth * 0.015,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   title,
//                   color: AppColor.black,
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.w500,
//                   maxLines: 2,
//                 ),
//                 SizedBox(height: screenWidth * 0.02),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _circleButton("-", () {
//                       if (value.value > 0) value.value--;
//                     }, buttonSize),
//                     Obx(() => Container(
//                       width: counterWidth,
//                       height: buttonSize,
//                       margin: const EdgeInsets.symmetric(horizontal: 6),
//                       decoration: BoxDecoration(
//                         color: AppColor.yellow,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(color: AppColor.black, width: 1),
//                       ),
//                       alignment: Alignment.center,
//                       child: AppText(
//                         "${value.value}",
//                         color: AppColor.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontSize,
//                       ),
//                     )),
//                     _circleButton("+", () {
//                       value.value++;
//                     }, buttonSize),
//                   ],
//                 ),
//                 SizedBox(height: screenWidth * 0.03),
//                 CustomLine(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   Widget _circleButton(String text, VoidCallback onTap, double buttonSize) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Container(
//         width: 28,
//         height: 28,
//         // decoration: const BoxDecoration(
//         //   color: AppColor.black,
//         //   shape: BoxShape.circle,
//         // ),
//         alignment: Alignment.center,
//         child: text == "-"?Icon(Icons.remove,size: getSize(23,isFont: true),):Icon(Icons.add,size: getSize(23,isFont: true),),
//       ),
//     );
//   }
// }
/// ========================== END ===================================///
class EditProgramScreen extends StatefulWidget {
  final String day;

  EditProgramScreen({super.key,required this.day});

  @override
  State<EditProgramScreen> createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  final EditProgramController controller = Get.put(EditProgramController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchDailyQuestions(day: widget.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            customHeader(),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: AppLoaderWidget());
                }

                if (controller.counterQuestions.isEmpty &&
                    controller.textFieldQuestions.isEmpty) {
                  return const Center(child: Text("No questions available"));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      /// Counter type questions
                      ...controller.counterQuestions.map((q) {
                        return customCounterRow(q);
                      }),

                      /// Text field type questions
                      ...controller.textFieldQuestions.map((q) {
                        return customTextFieldRow(q);
                      }),
                    ],
                  ),
                );
              }),
            ),

            /// Submit Button
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: CommonButton(
            //     text: AppString.submit,
            //     isBlackButton: true,
            //     onTap: () {
            //       // 🔹 Later: Call submit API with controller.counterQuestions + controller.textFieldQuestions
            //       AppLogs.log("Answers: ${controller.counterQuestions.map((e) => e.answer)} ${controller.textFieldQuestions.map((e) => e.answer)}");
            //     },
            //   ),
            // ),
            Padding(
            padding: const EdgeInsets.all(16),
            child: CommonButton(
              buttonTextColor: AppColor.textBlack,
              buttonColor: AppColor.yellow,
                text: AppString.submit,
                // isBlackButton: true,
                onTap: () {
                  controller.submitDailyQuestions(day: widget.day);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget customHeader() {
    return Row(
      children: [
        backButton(marginTop: 12, marginBottom: 12, marginRight: 7),
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 12),
        //     child: Center(
        //       child: AppImage.svg(
        //         AppImages.fatEndFitIcon,
        //         height: 50,
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: AppText("My Activity",fontWeight: FontWeight.w700,fontSize: 18,)
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }

  /// For counter-type questions
  // Widget customCounterRow(QuestionData q) {
  //   // final value = int.tryParse(q.answer.value ?? "0") ?? 0;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Container(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           AppText(q.questionText,
  //               color: AppColor.black,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               maxLines: 10),
  //           const SizedBox(height: 8),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               _circleButton(Icons.remove, () {
  //                 controller.decrease(q);
  //               }),
  //               Obx(() {
  //                 final current =
  //                     int.tryParse(q.answer.value ?? "0") ?? 0; // refresh when list changes
  //                 return Container(
  //                   width: 60,
  //                   height: 40,
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: AppColor.yellow,
  //                     borderRadius: BorderRadius.circular(6),
  //                     border: Border.all(color: AppColor.black),
  //                   ),
  //                   child: AppText("$current",
  //                       fontWeight: FontWeight.bold, color: AppColor.black),
  //                 );
  //               }),
  //               _circleButton(Icons.add, () {
  //                 controller.increase(q);
  //               }),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           CustomLine(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget customCounterRow(QuestionData q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade400, // background grey
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Question text
            Expanded(
              child: AppText(
                q.questionText,
                color: AppColor.blackColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                maxLines: 10,
              ),
            ),

            // Minus button
            GestureDetector(
              onTap: () => controller.decrease(q),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.remove, color: AppColor.black),
              ),
            ),

            // Counter value box
            Obx(() {
              final current = int.tryParse(q.answer.value ?? "0") ?? 0;
              return Container(
                width: 50,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.yellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: AppText(
                  "$current",
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                  fontSize: 16,
                ),
              );
            }),

            // Plus button
            GestureDetector(
              onTap: () => controller.increase(q),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.add, color: AppColor.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// For text-field type questions
  // Widget _buildTextFieldRow(QuestionData q) {
  //   final textController = TextEditingController(text: q.answer?.value ?? "");
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         AppText(q.questionText,
  //             fontSize: 14, color: AppColor.black, fontWeight: FontWeight.w500),
  //         const SizedBox(height: 6),
  //         CommonTextField(
  //           controller: textController,
  //           textColor: AppColor.black,
  //           hintText: "Type here...",
  //           fillColor: AppColor.yellow,
  //           enabledBorderColor: AppColor.black,
  //           borderRadius: 12,
  //           verticalPadding: 3,
  //           onChanged: (val) {
  //             q.answer?.value = val; // bind back to model
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget customTextFieldRow(QuestionData q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            q.questionText,
            fontSize: 14,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w700,
            maxLines: 10,
          ),
          const SizedBox(height: 6),
          CommonTextField(

            controller: q.controller,
            textColor: AppColor.white,
            hintText: "Type here...",
            fillColor: Colors.grey.shade400,
            enabledBorderColor: AppColor.black,
            borderRadius: 12,
            verticalPadding: 3,
          ),
        ],
      ),
    );
  }


  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        child: Icon(icon, size: 22),
      ),
    );
  }
}

// Widget _buildCounterRow(String title, RxInt value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 0),
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         // border: Border.all(color: AppColor.black.withOpacity(0.2)),
//       ),
//       child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             title,
//             color: AppColor.black,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             maxLines: 2,
//           ),
//           SizedBox(height: 6,),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _circleButton("-", () {
//                 if (value.value > 0) value.value--;
//               }),
//               Obx(() => Container(
//                 width: Get.width * 0.3,
//                 height: 32,
//                 margin: const EdgeInsets.symmetric(horizontal: 6),
//                 decoration: BoxDecoration(
//                   color: AppColor.yellow,
//                   borderRadius: BorderRadius.circular(6),
//                   border: Border.all(color: AppColor.black,width: 1),
//                 ),
//                 alignment: Alignment.center,
//                 child: AppText(
//                   "${value.value}",
//                   color: AppColor.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//               _circleButton("+", () {
//                 value.value++;
//               }),
//             ],
//           ),
//           SizedBox(height: 10,),
//           CustomLine(),
//         ],
//       ),
//     ),
//   );
// }