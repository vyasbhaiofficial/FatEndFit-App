import 'package:fat_end_fit/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/app_loader.dart';
import '../../../utils/common/app_video.dart';
import '../../../utils/common_function.dart';
import '../../program_video/model/program_video_model.dart';
import '../../program_video/program_video_details/program_video_details_controller.dart';
class WebinarVideoScreen extends StatelessWidget {
  final ProgramVideoModel data;
  final bool isUpdateProgress;
  WebinarVideoScreen({super.key, required this.data,this.isUpdateProgress = true});

  final RxBool isFullScreen = false.obs;

  @override
  Widget build(BuildContext context) {
    final videoCtrl = Get.put(ProfileDetailsController(data.id,isUpdateProgress: isUpdateProgress));

    return WillPopScope(
      onWillPop: () async {
        // if (isFullScreen.value) {
        //   // 👇 Exit fullscreen first instead of popping screen
        //   isFullScreen.value = false;
        //   SystemChrome.setPreferredOrientations([
        //     DeviceOrientation.portraitUp,
        //     DeviceOrientation.portraitDown,
        //   ]);
        //   return false; // stop back navigation
        // }
        return false; // allow back navigation
      },
      child: Obx(() {
        if (videoCtrl.isLoading.value) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: AppLoaderWidget()),
          );
        }

        // ✅ FULLSCREEN VIDEO
        if (isFullScreen.value) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: SizedBox.expand(
                child: CustomVideoPlayer(
                  radius: 0,
                  anyMessage: "WEBINAR FULLSCREEN",
                  onPlayPauseChange: (isPlay) {
                    if (!isPlay) {
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

        // ✅ NORMAL VIDEO (HALF SCREEN)
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: Get.width,
                child: CustomVideoPlayer(
                  spaceUperCenterControlls: Get.height * 0.09,
                  anyMessage: "WEBINAR HALF SCREEN",
                  onPlayPauseChange: (isPlay) {
                    if (!isPlay) {
                      videoCtrl.saveProgress();
                      videoCtrl.updateProgress();
                    }
                  },
                  maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
                  initialSeconds: videoCtrl.totalSecond.value == videoCtrl.initialSeconds ? 0 : videoCtrl.initialSeconds.toDouble(),
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
          ),
        );
      }),
    );
  }
}

// class WebinarVideoScreen extends StatelessWidget {
//   final ProgramVideoModel data;
//   final bool isUpdateProgress;
//   WebinarVideoScreen({super.key, required this.data,this.isUpdateProgress = true});
//
//   final RxBool isFullScreen = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final videoCtrl = Get.put(ProfileDetailsController(data.id,isUpdateProgress: isUpdateProgress));
//
//     return Obx(() {
//       if (videoCtrl.isLoading.value) {
//         return const Scaffold(
//           backgroundColor: Colors.black,
//           body: Center(child: AppLoaderWidget()),
//         );
//       }
//
//       // ✅ FULLSCREEN VIDEO
//       if (isFullScreen.value) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: SafeArea(
//             child: SizedBox.expand(
//               child: CustomVideoPlayer(radius: 0,
//                 anyMessage: "WEBINAR FULLSCREEN",
//                 onPlayPauseChange: (isPlay) {
//                   if (!isPlay) {
//                     videoCtrl.saveProgress();
//                     videoCtrl.updateProgress();
//                   }
//                 },
//                 maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
//                 initialSeconds: videoCtrl.initialSeconds.toDouble(),
//                 thumbnailUrl: getImageUrl(data.thumbnail),
//                 videoUrl: getImageUrl(data.video),
//                 onChange: (current, total, isFull, maxWatchedSeconds) {
//                   isFullScreen.value = isFull;
//                   videoCtrl.updateCurrentTime(current.inSeconds.toDouble());
//                   if (isFull) {
//                     SystemChrome.setPreferredOrientations([
//                       DeviceOrientation.landscapeLeft,
//                       DeviceOrientation.landscapeRight,
//                     ]);
//                   } else {
//                     SystemChrome.setPreferredOrientations([
//                       DeviceOrientation.portraitUp,
//                       DeviceOrientation.portraitDown,
//                     ]);
//                   }
//                 },
//               ),
//             ),
//           ),
//         );
//       }
//
//       AppLogs.log("APP VIDEO: TOTAL SECOND: ${videoCtrl.totalSecond.value} = INIT SEC = ${videoCtrl.initialSeconds} videoCtrl.initialSeconds?0:videoCtrl.initialSeconds.toDouble()");
//       // ✅ NORMAL VIDEO (HALF SCREEN)
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Container(
//               // height: 220,
//               width: Get.width,
//               child: CustomVideoPlayer(
//                 spaceUperCenterControlls: Get.height * 0.09,
//                 anyMessage: "WEBINAR HALF SCREEN",
//                 onPlayPauseChange: (isPlay) {
//                   if (!isPlay) {
//                     videoCtrl.saveProgress();
//                     videoCtrl.updateProgress();
//                   }
//                 },
//                 maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
//                 initialSeconds: videoCtrl.totalSecond.value == videoCtrl.initialSeconds?0:videoCtrl.initialSeconds.toDouble(),
//                 // thumbnailUrl: getImageUrl(data.thumbnail),
//                 videoUrl: getImageUrl(data.video),
//                 onChange: (current, total, isFull, maxWatchedSeconds) {
//                   // videoCtrl.totalSecond.value = total.inSeconds;
//                   isFullScreen.value = isFull;
//                   videoCtrl.saveTotalSecond(total.inSeconds);
//                   videoCtrl.updateCurrentTime(current.inSeconds.toDouble());
//                   if (isFull) {
//                     SystemChrome.setPreferredOrientations([
//                       DeviceOrientation.landscapeLeft,
//                       DeviceOrientation.landscapeRight,
//                     ]);
//                   } else {
//                     SystemChrome.setPreferredOrientations([
//                       DeviceOrientation.portraitUp,
//                       DeviceOrientation.portraitDown,
//                     ]);
//                   }
//                 },
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
