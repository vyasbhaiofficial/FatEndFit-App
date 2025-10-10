import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';
import 'package:fat_end_fit/utils/common/app_video.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/program_question/widget/question_result_dialog.dart';
import 'package:fat_end_fit/view/program_video/program_video_details/program_video_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/common/app_button_v1.dart';
import '../../../utils/common/app_common_back_button.dart';
import '../../../utils/app_print.dart';
import '../../edit_program/edit_program_screen.dart';
import '../../program_question/program_question_controller.dart';
import '../../program_question/program_question_screen.dart';
import '../model/program_video_model.dart';
// class ProgramVideoDetailsScreen extends StatelessWidget {
//   ProgramVideoDetailsScreen({super.key});
//
//   final RxBool isFullScreen = false.obs; // ✅ fullscreen state manage karva
//
//   @override
//   Widget build(BuildContext context) {
//     ProgramVideoModel data = Get.arguments;
//     return Obx(() {
//       // ✅ Fullscreen hoy to ONLY video show karse
//       if (isFullScreen.value) {
//
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: SafeArea(
//             child: SizedBox.expand(
//               child: CustomVideoPlayer(
//                 thumbnailUrl: getImageUrl(data.thumbnail) ?? "http://static.vecteezy.com/system/resources/thumbnails/005/048/106/small_2x/black-and-yellow-grunge-modern-thumbnail-background-free-vector.jpg",
//                 videoUrl:
//                 getImageUrl(data.video) ?? "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_5mb.mp4",
//                 onChange: (current, total, isFull) {
//                   isFullScreen.value = isFull; // 🔄 update state
//                 },
//
//               ),
//             ),
//           ),
//         );
//       }
//
//       // ✅ Normal UI with AppBar + Content
//       return Scaffold(
//         backgroundColor: AppColor.white,
//         body: SafeArea(
//           child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button + Title
//               Row(
//                 children: [
//                   backButton(),
//                   Expanded(
//                     child: Text(
//                       AppString.programVideo.replaceAll("-", ""),
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColor.black),
//                     ),
//                   ),
//                   const SizedBox(width: 32), // balance spacing
//                 ],
//               ),
//
//               // 🎥 Video Player
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: SizedBox(
//                   height: 200,
//                   width: Get.width,
//                   child: /*CustomVideoPlayer(
//                     thumbnailUrl: "http://static.vecteezy.com/system/resources/thumbnails/005/048/106/small_2x/black-and-yellow-grunge-modern-thumbnail-background-free-vector.jpg",
//                     videoUrl: "https://www.w3schools.com/tags/mov_bbb.mp4",
//                     onChange: (current, total, isFull) {
//                       // AppLogs.log(
//                       //     "=========== Current: $current, Total: $total, FullScreen: $isFull");
//                       isFullScreen.value = isFull; // 🔄 update state
//                     },
//                   ),*/
//                   CustomVideoPlayer(
//                     thumbnailUrl: getImageUrl(data.thumbnail) ?? "http://static.vecteezy.com/system/resources/thumbnails/005/048/106/small_2x/black-and-yellow-grunge-modern-thumbnail-background-free-vector.jpg",
//                     videoUrl:
//                     getImageUrl(data.video) ?? "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_5mb.mp4",
//                     onChange: (current, total, isFull) {
//                       isFullScreen.value = isFull; // 🔄 update state
//                     },
//                   ),
//                 ),
//               ),
//
//               // 📊 Progress Row
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: AppColor.black,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Row(
//                     children: [
//
//                       Expanded(
//                         child: Padding(padding: EdgeInsets.only(left: getSize(14)),child: AppText(AppString.myProgress,color: AppColor.textWhite,fontSize: getSize(12,isFont: true),))
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: CommonButton(
//                             height: getSize(34,isHeight: true),
//                             radius: 8,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             text: AppString.editProgress,
//                             onTap: () {
//                               Get.to(()=>EditProgramScreen());
//
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // 📄 Description
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(data.title ?? ''
//                         /*AppString.programVideo.replaceAll("-", "")*/,
//                         style: TextStyle(
//                             fontSize: getSize(16,isFont: true),
//                             fontWeight: FontWeight.bold,
//                             color: AppColor.black),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                        /* AppString.loremIpsum*/data.description,
//                         style: TextStyle(
//                             fontSize: getSize(13,isFont: true),
//                             color: AppColor.black,
//                             height: 1.5),
//                       ),
//                       const SizedBox(height: 80),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // ⏭️ Next Button
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: CommonButton(
//                   text: AppString.next,
//                   isBlackButton: true,
//                   onTap: () {
//                     Get.to(()=>ProgramQuestionsScreen());
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


import 'package:flutter/services.dart';

class ProgramVideoDetailsScreen extends StatelessWidget {
  final ProgramVideoModel data;
  ProgramVideoDetailsScreen({super.key,required this.data});

  final RxBool isFullScreen = false.obs;

  @override
  Widget build(BuildContext context) {
    // ProgramVideoModel data = Get.arguments;
    final videoCtrl = Get.put(ProfileDetailsController(data.id));
    final questionScreen = Get.put(QuestionController());
    return Obx(() {
      if(videoCtrl.isLoading.value){
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: AppLoaderWidget(),),
        );
      }

      if (isFullScreen.value) {
        // ✅ FULLSCREEN UI
        return Scaffold(
          backgroundColor: Colors.black,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              // if (isFullScreen.value) {
              //   // Step 1: Just exit fullscreen
              //   isFullScreen.value = false;
              //   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              //   await SystemChrome.setPreferredOrientations([
              //     DeviceOrientation.portraitUp,
              //     DeviceOrientation.portraitDown,
              //   ]);
              // } else {
              //   // Step 2: Now allow popping the screen
              //   Future.microtask(() => Get.back());
              //   // use Future.microtask or Future.delayed to avoid `_debugLocked` error
              // }
            },
            child: SafeArea(
              child: CustomVideoPlayer(
                radius: 0,
                spaceUperCenterControlls: Get.height * 0.2,
                anyMessage: "CALL BY FULL HORIZONTAL SCREEN",
                onPlayPauseChange: (isPlay) {
                  AppLogs.log("Video is playing: $isPlay");
                  if (isPlay == false) {
                    AppLogs.log("Video is Push, saving progress...", color: Colors.green);
                    videoCtrl.saveProgress();
                    videoCtrl.updateProgress();
                  }
                },
                maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
                initialSeconds: videoCtrl.initialSeconds.toDouble(),
                thumbnailUrl: getImageUrl(data.thumbnail),
                videoUrl: getImageUrl(data.video),
                onChange: (current, total, isFull, maxWatchedSeconds) {
                  isFullScreen.value = isFull;
                  videoCtrl.saveTotalSecond(total.inSeconds);
                  videoCtrl.updateCurrentTime(current.inSeconds.toDouble());

                  if (isFull) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  }
                },
              ),
            ),
          ),
        );
      }


      // ✅ NORMAL UI
      return MediaQuery(
        // 🔒 Reset karine text zoom problem solve
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isFullScreen.value)
                  Row(
                    children: [
                      backButton(),
                      Expanded(
                        child: Text(
                          AppString.programVideo.replaceAll("-", ""),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                // 🎥 Video 222
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   child: SizedBox(
                //     // height: 200,
                //     width: Get.width,
                //     child: CustomVideoPlayer(
                //       anyMessage: "CALL BY HALF SCREEN",
                //       onPlayPauseChange: (isPlay) {
                //         AppLogs.log("Video is playing: $isPlay");
                //         if(isPlay == false){
                //           AppLogs.log("Video is Push, saving progress...",color: Colors.green);
                //           videoCtrl.saveProgress();
                //           videoCtrl.updateProgress();
                //         }
                //       },
                //       initialSeconds: videoCtrl.totalSecond.value == videoCtrl.initialSeconds?0:videoCtrl.initialSeconds.toDouble(),
                //       maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
                //       // initialSeconds: videoCtrl.initialSeconds.toDouble(),
                //       thumbnailUrl: getImageUrl(data.thumbnail),
                //       videoUrl: getImageUrl(data.video),
                //       onChange: (current, total, isFull, maxWatchedSeconds) {
                //         isFullScreen.value = isFull;
                //         videoCtrl.saveTotalSecond();
                //         videoCtrl.updateCurrentTime(current.inSeconds.toDouble());
                //         // AppLogs.log("=========== Current: $current, Total: $total, FullScreen: $isFull, maxWatchedSeconds: $maxWatchedSeconds");
                //         if (isFull) {
                //           SystemChrome.setPreferredOrientations([
                //             DeviceOrientation.landscapeLeft,
                //             DeviceOrientation.landscapeRight,
                //           ]);
                //         } else {
                //           SystemChrome.setPreferredOrientations([
                //             DeviceOrientation.portraitUp,
                //             DeviceOrientation.portraitDown,
                //           ]);
                //         }
                //       },
                //     ),
                //   ),
                // ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                  child: SizedBox(
                    height: Get.height * 0.24,
                    width: Get.width,
                    child: CustomVideoPlayer(
                      anyMessage: "CALL BY HALF SCREEN",
                      onPlayPauseChange: (isPlay) {
                        AppLogs.log("Video is playing: $isPlay");
                        if(isPlay == false){
                          AppLogs.log("Video is Push, saving progress...",color: Colors.green);
                          videoCtrl.saveProgress();
                          videoCtrl.updateProgress();
                        }
                      },
                      initialSeconds: videoCtrl.totalSecond.value == videoCtrl.initialSeconds?0:videoCtrl.initialSeconds.toDouble(),
                      maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
                      // initialSeconds: videoCtrl.initialSeconds.toDouble(),
                      thumbnailUrl: getImageUrl(data.thumbnail),
                      videoUrl: getImageUrl(data.video),
                      onChange: (current, total, isFull, maxWatchedSeconds) {
                        isFullScreen.value = isFull;
                        videoCtrl.saveTotalSecond(total.inSeconds);
                        videoCtrl.updateCurrentTime(current.inSeconds.toDouble());
                        // AppLogs.log("=========== Current: $current, Total: $total, FullScreen: $isFull, maxWatchedSeconds: $maxWatchedSeconds");
                        if (isFull) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                        } else {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        }
                      },
                    ),
                  ),
                ),
                
                
                // 📊 Progress Row
                // if (!isFullScreen.value)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: AppColor.black,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Row(
                //         children: [
                //
                //           Expanded(
                //               child: Padding(padding: EdgeInsets.only(left: getSize(14)),child: AppText(AppString.myProgress,color: AppColor.textWhite,fontSize: getSize(12,isFont: true),))
                //           ),
                //           const SizedBox(width: 10),
                //           Expanded(
                //             child: Padding(
                //               padding: const EdgeInsets.all(3.0),
                //               child: CommonButton(
                //                 height: getSize(34,isHeight: true),
                //                 radius: 8,
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 10, vertical: 5),
                //                 text: AppString.editProgress,
                //                 onTap: () {
                //                   final controller = Get.find<CustomVideoPlayerController>(tag: getImageUrl(data.video));
                //                   if(controller.isPlaying.value) {
                //                     controller.togglePlayPause();
                //                   }
                //                   Get.to(()=>EditProgramScreen(day: data.day.toString(),));
                //
                //                 },
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),

                if(!isFullScreen.value)
                  Container(
                    height: Get.height * 0.056,width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColor.buttonBlack222222,borderRadius: BorderRadius.circular(20)),child: AppText("Monthly Mega Section",color: AppColor.textWhite,fontWeight: FontWeight.w700,fontSize: 15,maxLines: 1,),),
                
                const SizedBox(height: 16),

                // 📄 Description
                if (!isFullScreen.value)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.title ?? ''
                            /*AppString.programVideo.replaceAll("-", "")*/,
                            style: TextStyle(
                                fontSize: getSize(16,isFont: true),
                                fontWeight: FontWeight.bold,
                                color: AppColor.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            /* AppString.loremIpsum*/data.description,
                            style: TextStyle(
                                fontSize: getSize(13,isFont: true),
                                color: AppColor.black,
                                height: 1.5),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),

                // ⏭️ Next Button
                if (!isFullScreen.value && data.userVideoProgress?.isCompleted == true)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CommonButton(
                      buttonColor: AppColor.yellow,
                      buttonTextColor: AppColor.textBlack,
                      text: AppString.next,
                      // isBlackButton: true,
                      onTap: () async {
                        final controller = Get.find<CustomVideoPlayerController>(tag: getImageUrl(data.video));
                        if(controller.isPlaying.value) {
                          controller.togglePlayPause();
                        }
                          AppLogs.log("PROGRAM =========== ${data.userAnswer}");
                        if(data.userAnswer == false) {
                         final fetchData = await Get.to(()=>ProgramQuestionsScreen(),arguments: data);

                         if(fetchData != null) {
                           if(fetchData is bool && fetchData == true) {
                             data.userAnswer = true;
                           }
                         }
                        } else {

                          final int correct = data.answerStats?.correctAnswers ?? 0;
                          final int total = data.answerStats?.totalAnswers ?? 0;
                          final int wrong = data.answerStats?.wrongAnswers ?? 0;

                          double percent = (correct / total) * 100;
                          questionScreen.showResultBottomSheet(correct: correct,wrong: wrong,percent: percent);

                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// old code
// class ProgramVideoDetailsScreen extends StatelessWidget {
//   const ProgramVideoDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // 🔙 Back Button + Title
//             Row(
//               children: [
//                 backButton(),
//                 Expanded(
//                   child: Text(
//                     AppString.programVideo,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.black),
//                   ),
//                 ),
//                 const SizedBox(width: 32), // balance spacing
//               ],
//             ),
//
//             // 🎥 Thumbnail with Play button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: SizedBox(height: 200,width: Get.width,child: CustomVideoPlayer(
//                 videoUrl: "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_5mb.mp4",onChange: (current, total, isFullScreen) {
//                 AppLogs.log("=========== Current: $current, Total: $total, FullScreen: $isFullScreen");
//               },)),
//             ),
//
//             // 📊 Progress Row
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 decoration: BoxDecoration(color: AppColor.black,borderRadius: BorderRadius.circular(10)),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CommonButton(
//                         text: AppString.myProgress,
//                         isBlackButton: true,
//                         onTap: () {  },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(3.0),
//                         child: CommonButton(height: 36,radius: 8,padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
//                           text: AppString.editProgress,
//                           onTap: () {},
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // 📄 Description
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AppString.programVideo.replaceAll("-", ""),
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColor.black),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       AppString.loremIpsum,
//                       style: const TextStyle(
//                           fontSize: 14, color: AppColor.black, height: 1.5),
//                     ),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ⏭️ Next Button
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: CommonButton(
//                 text: AppString.next,
//                 isBlackButton: true,
//                 onTap: () {},
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
