import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/common/app_video.dart';
import '../../../utils/app_print.dart';
import '../../program_video/program_video_details/program_video_details_controller.dart';

Future<void> showResumeVideoDialog({
  required String planId,
  required String videoUrl,
  required String thumbnailUrl,
  required ProfileDetailsController videoCtrl,
}) async {
  bool _isResumed = false;
  videoCtrl.getTotalSecond();
  AppLogs.log("APP VIDEO: TOTAL SECOND: ${videoCtrl.totalSecond.value} = INIT SEC = ${videoCtrl.initialSeconds} videoCtrl.initialSeconds?0:videoCtrl.initialSeconds.toDouble()");

  Get.dialog(
    WillPopScope(
      onWillPop: () async => false, // ❌ prevent back button
      child: Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          height: Get.height * 0.65, // 65% screen height
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: Text(
              //     "Compulsory Video",
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),

              // 🔹 Video Player
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomVideoPlayer(
                    radius: 0,
                    showFullScreenButton: false,
                    spaceUperCenterControlls: Get.height * 0.07,
                    videoUrl: getImageUrl(videoUrl),
                    thumbnailUrl: thumbnailUrl,
                    anyMessage: "COMPULSORY VIDEO",
                    maxWatchedSeconds: videoCtrl.maxWatchedSeconds.value,
                    initialSeconds: videoCtrl.totalSecond.value == videoCtrl.initialSeconds.toInt()?0:videoCtrl.initialSeconds.toDouble(),
                    onPlayPauseChange: (isPlay) {
                      if (!isPlay) {
                        videoCtrl.saveProgress();
                        videoCtrl.updateProgress();
                      }
                    },
                    onChange: (current, total, isFull, maxWatchedSeconds) async {
                      videoCtrl.currentTime.value = current.inSeconds.toDouble();
                      videoCtrl.totalSecond.value = total.inSeconds;
                      videoCtrl.saveTotalSecond(total.inSeconds);

                      // if (total.inSeconds > 0 &&
                      //     current.inSeconds >= total.inSeconds) {
                      //   // 🎯 Video finished
                      //   await Future.delayed(const Duration(seconds: 1));
                      //   if (Get.isDialogOpen ?? false) {
                      //     Get.back(result: true); // close dialog
                      //   }
                      //
                      //   HomeController home = Get.find();
                      //   await home.holdOrResumePlan(
                      //     planId: planId,
                      //     type: 2,
                      //   ); // resume
                      // }
                      if (!_isResumed && total.inSeconds > 0 && current.inSeconds >= total.inSeconds) {
                        _isResumed = true; // ✅ prevent multiple calls
                        await Future.delayed(const Duration(seconds: 1));
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                          HomeController home = Get.find();
                        await home.holdOrResumePlan(planId: planId, type: 2);
                      }
                    },
                  ),
                ),
              ),

              // 🔹 Footer Note
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "⚠️ You must watch the full video to resume your plan.",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
