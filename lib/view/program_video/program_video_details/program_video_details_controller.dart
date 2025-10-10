// import 'dart:io';
// import 'package:fat_end_fit/service/api_config.dart';
// import 'package:fat_end_fit/utils/app_print.dart';
// import 'package:fat_end_fit/utils/app_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../service/api_service.dart';

// class ProfileDetailsController extends GetxController with WidgetsBindingObserver {
//   final String videoId;
//   final RxDouble currentTime = 0.0.obs; // current played seconds
//
//   ProfileDetailsController(this.videoId);
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//
//     // 🔹 Load saved progress
//     _loadProgress();
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _saveProgress(); // save to storage
//     _updateProgress(); // send to API
//     super.onClose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.detached) {
//       _saveProgress();   // save locally
//       _updateProgress(); // update server
//     }
//   }
//
//   // ⏱ update from player
//   void updateCurrentTime(double seconds) {
//     currentTime.value = seconds;
//   }
//
//   // 📂 Save progress locally
//   Future<void> _saveProgress() async {
//     if (videoId.isNotEmpty) {
//       await AppStorage().save("video_progress_$videoId", currentTime.value.toInt());
//       AppLogs.log("Saved local progress: ${currentTime.value}", tag: "VIDEO_PROGRESS");
//     }
//   }
//
//   // 📂 Load progress from local storage
//   Future<void> _loadProgress() async {
//     if (videoId.isNotEmpty) {
//       final savedTime = await AppStorage().read("video_progress_$videoId");
//       if (savedTime != null) {
//         currentTime.value = savedTime.toDouble();
//         AppLogs.log("Loaded local progress: $savedTime", tag: "VIDEO_PROGRESS");
//       }
//     }
//   }
//
//   // 🌐 Update API with latest progress
//   Future<void> _updateProgress() async {
//     if (videoId.isEmpty) return;
//
//     final body = {
//       "videoId": videoId,
//       "currentTime": currentTime.value.toInt(),
//     };
//
//     final response = await AppApi.getInstance()
//         .post<Map<String, dynamic>>(ApiConfig.videoProgress, data: body);
//
//     if (response.success) {
//       AppLogs.log("Progress updated ✅ ${response.data}", tag: "VIDEO_PROGRESS");
//     } else {
//       AppLogs.log("Failed to update progress ❌ ${response.message}",
//           tag: "VIDEO_PROGRESS", color: Colors.red);
//     }
//   }
// }
import 'dart:io';
import 'package:fat_end_fit/service/api_config.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/api_service.dart';

class ProfileDetailsController extends GetxController with WidgetsBindingObserver {
  final String videoId;

  final RxDouble currentTime = 0.0.obs; // current played seconds
  final RxDouble maxWatchedSeconds = 0.0.obs; // restrict seek
  RxInt totalSecond = 0.obs; // restrict seek
  var isLoading = true.obs; // restrict seek
  final bool isUpdateProgress; // restrict seek

  ProfileDetailsController(this.videoId, {this.isUpdateProgress = true});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getTotalSecond();
    // 🔹 Load saved progress
    loadProgress();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    saveProgress();
    if(isUpdateProgress) updateProgress(); // send to server
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached && isUpdateProgress) {
      saveProgress();
      updateProgress();
    }
  }

/// Save the total seconds of a video to local storage

  saveTotalSecond(int total){
    // Create a unique key using the video ID
    final keyTotal = "video_total_second_$videoId";
    // Read the saved total seconds from storage
    final savedTotal = AppStorage().read(keyTotal);
    // If no saved value exists, save the current total seconds value
    if (savedTotal == null || savedTotal == 0) {
      print("savedTotal--[ getTotalSecond ]->${savedTotal}");

      AppStorage().save(keyTotal, total);
    }
  }

  getTotalSecond(){
    final keyTotal = "video_total_second_$videoId";
    AppStorage().remove(keyTotal);
    final savedTotal = AppStorage().read(keyTotal);
    print("savedTotal--[ getTotalSecond ]->${savedTotal}");
    if (savedTotal != null) {
      totalSecond.value = savedTotal;
    }
  }

  // ⏱ update from player
  void updateCurrentTime(double seconds) {
    currentTime.value = seconds;

    // ✅ Update max watched if user goes further
    if (seconds > maxWatchedSeconds.value) {
      maxWatchedSeconds.value = seconds;
    }
  }

  // 📂 Load progress from local storage
  Future<void> loadProgress() async {
    isLoading(true);
    AppLogs.log("_loadProgress() called", tag: "VIDEO_PROGRESS");

    if (videoId.isNotEmpty) {
      AppLogs.log("VideoId is not empty: $videoId", tag: "VIDEO_PROGRESS");

      final savedTime = await AppStorage().read("video_progress_$videoId");
      AppLogs.log("Read savedTime: $savedTime", tag: "VIDEO_PROGRESS");

      final savedMax = await AppStorage().read("video_max_progress_$videoId");
      AppLogs.log("Read savedMax: $savedMax", tag: "VIDEO_PROGRESS");

      if (savedTime != null) {
        currentTime.value = savedTime.toDouble();
        AppLogs.log(
          "Set currentTime.value = ${currentTime.value}",
          tag: "VIDEO_PROGRESS",
        );
      } else {
        AppLogs.log("No savedTime found", tag: "VIDEO_PROGRESS");
      }

      if (savedMax != null) {
        maxWatchedSeconds.value = savedMax.toDouble();
        AppLogs.log(
          "Set maxWatchedSeconds.value = ${maxWatchedSeconds.value}",
          tag: "VIDEO_PROGRESS",
        );
      } else {
        AppLogs.log("No savedMax found", tag: "VIDEO_PROGRESS");
      }

      AppLogs.log(
        "Loaded local progress completed: current=${currentTime.value}, max=${maxWatchedSeconds.value}",
        tag: "VIDEO_PROGRESS",
      );
    } else {
      AppLogs.log("videoId is empty → skipping load", tag: "VIDEO_PROGRESS");
    }

    isLoading(false);
  }

  // 📂 Save progress locally
  // Future<void> saveProgress() async {
  //   if (videoId.isNotEmpty) {
  //     await AppStorage().save("video_progress_$videoId", currentTime.value.toInt());
  //     await AppStorage().save("video_max_progress_$videoId", maxWatchedSeconds.value.toInt());
  //
  //     AppLogs.log(
  //       "Saved local progress: current=${currentTime.value}, max=${maxWatchedSeconds.value}",
  //       tag: "VIDEO_PROGRESS",
  //     );
  //   }
  // }
  Future<void> saveProgress() async {
    if (videoId.isNotEmpty && isUpdateProgress) {
      final keyCurrent = "video_progress_$videoId";
      final keyMax = "video_max_progress_$videoId";

      // 🔎 Load previous saved max
      final prevMax = await AppStorage().read(keyMax) ?? 0;

      // ✅ Save only if current > prevMax
      if (currentTime.value.toInt() > prevMax) {
        await AppStorage().save(keyCurrent, currentTime.value.toInt());
        await AppStorage().save(keyMax, currentTime.value.toInt());

        AppLogs.log(
          "Saved local progress: current=${currentTime.value}, prevMax=$prevMax",
          tag: "VIDEO_PROGRESS",
        );

        // 🌐 Update API also
        await updateProgress();
      } else {
        AppLogs.log(
          "Skipped saving progress (current=${currentTime.value}, prevMax=$prevMax)",
          tag: "VIDEO_PROGRESS",
          color: Colors.orange,
        );
      }
    }
  }

  // 🌐 Update API with latest progress
  Future<void> updateProgress() async {
    if (videoId.isEmpty) return;

    final current = currentTime.value.toInt();
    final keyMax = "video_max_progress_$videoId";
    // final maxSaved = maxWatchedSeconds.value.toInt();
    final prevMax = await AppStorage().read(keyMax) ?? 0;

    AppLogs.log("[ updateProgress ] START CURRENT: $current MAX: $prevMax");
    // 🔒 Only update if user has progressed beyond previous max
    if (current > prevMax) {
      final body = {
        "videoId": videoId,
        "currentTime": current,
      };

      final response = await AppApi.getInstance()
          .post<Map<String, dynamic>>(ApiConfig.videoProgress, data: body);

      if (response.success) {
        AppLogs.log(
          "Progress updated ✅ current=$current (oldMax=$prevMax) ${response.data}",
          tag: "VIDEO_PROGRESS",
        );
      } else {
        AppLogs.log(
          "Failed to update progress ❌ ${response.message}",
          tag: "VIDEO_PROGRESS",
          color: Colors.red,
        );
      }
    } else {
      AppLogs.log(
        "⏩ Skipped API update: current=$current ≤ max=$prevMax",
        tag: "VIDEO_PROGRESS",
        color: Colors.orange,
      );
    }
  }

  // // 🌐 Update API with latest progress
  // Future<void> updateProgress() async {
  //   if (videoId.isEmpty) return;
  //
  //   final body = {
  //     "videoId": videoId,
  //     "currentTime": currentTime.value.toInt(),
  //   };
  //
  //   final response = await AppApi.getInstance()
  //       .post<Map<String, dynamic>>(ApiConfig.videoProgress, data: body);
  //
  //   if (response.success) {
  //     AppLogs.log("Progress updated ✅ ${response.data}", tag: "VIDEO_PROGRESS");
  //   } else {
  //     AppLogs.log("Failed to update progress ❌ ${response.message}",
  //         tag: "VIDEO_PROGRESS", color: Colors.red);
  //   }
  // }

  /// 🟢 Get initial start time for player
  int get initialSeconds => currentTime.value.toInt();

  /// 🟢 Get max allowed seek time
  int get allowedMaxSeconds => maxWatchedSeconds.value.toInt();
}

// import 'dart:io';
// import 'package:fat_end_fit/service/api_config.dart';
// import 'package:fat_end_fit/utils/app_print.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../service/api_service.dart';
//
// class ProfileDetailsController extends GetxController with WidgetsBindingObserver{
//   final String videoId;
//   final RxDouble currentTime = 0.0.obs; // current played seconds
//
//   ProfileDetailsController(this.videoId);
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this); // observe lifecycle
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _updateProgress(); // call API when controller disposed
//     super.onClose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.detached) {
//       _updateProgress(); // API call when app goes background / screen off
//     }
//   }
//
//   // ⏱ update from player
//   void updateCurrentTime(double seconds) {
//     currentTime.value = seconds;
//   }
//
//   // 🌐 API Call
//   Future<void> _updateProgress() async {
//     if (videoId.isEmpty) return;
//
//     final body = {
//       "videoId": videoId,
//       "currentTime": currentTime.value.toInt(),
//     };
//
//     final response = await AppApi.getInstance()
//         .post<Map<String, dynamic>>(ApiConfig.videoProgress, data: body);
//
//     if (response.success) {
//       AppLogs.log("Progress updated ✅ ${response.data}", tag: "VIDEO_PROGRESS");
//     } else {
//       AppLogs.log("Failed to update progress ❌ ${response.message}",
//           tag: "VIDEO_PROGRESS", color: Colors.red);
//     }
//   }
// }
