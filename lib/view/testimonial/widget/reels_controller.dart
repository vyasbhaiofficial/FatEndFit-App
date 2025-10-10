//
// // reels_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../model/video_model.dart';

// class ReelsController extends GetxController {
//   final List<VideoModel> videoList;
//   final int initialIndex;
//   final RxMap<int, bool> isInitialized = <int, bool>{}.obs;
//
//   ReelsController({
//     required this.videoList,
//     this.initialIndex = 0,
//   });
//
//   // Observable variables
//   final RxInt currentIndex = 0.obs;
//   final RxBool isPlaying = true.obs;
//   final RxBool isLoading = false.obs;
//   final RxDouble currentPosition = 0.0.obs;
//   final RxDouble videoDuration = 0.0.obs;
//
//   // Video controllers cache
//   final Map<int, VideoPlayerController> videoControllers = {};
//   VideoPlayerController? get currentController =>
//       videoControllers[currentIndex.value];
//
//   @override
//   void onInit() {
//     super.onInit();
//     currentIndex.value = initialIndex;
//     _initializeVideos();
//   }
//
//   // Initialize current and nearby videos
//   void _initializeVideos() async {
//     isLoading.value = true;
//
//     // Initialize current video
//     await _initializeVideoAt(currentIndex.value);
//
//     // Preload next 2 and previous 2 videos
//     _preloadNearbyVideos();
//
//     isLoading.value = false;
//
//     // Start playing current video
//     playVideo();
//   }
//
//   // Initialize video at specific index
//   // Future<void> _initializeVideoAt(int index) async {
//   //   if (index < 0 || index >= videoList.length) return;
//   //   if (_videoControllers.containsKey(index)) return;
//   //
//   //   try {
//   //     final controller = VideoPlayerController.networkUrl(
//   //       Uri.parse(videoList[index].videoUrl),
//   //     );
//   //
//   //     await controller.initialize();
//   //
//   //     controller.addListener(() {
//   //       if (index == currentIndex.value) {
//   //         currentPosition.value = controller.value.position.inMilliseconds.toDouble();
//   //         videoDuration.value = controller.value.duration.inMilliseconds.toDouble();
//   //       }
//   //     });
//   //
//   //     _videoControllers[index] = controller;
//   //
//   //     // Auto-loop
//   //     controller.setLooping(true);
//   //
//   //   } catch (e) {
//   //     print('Error initializing video at index $index: $e');
//   //   }
//   // }
//   Future<void> _initializeVideoAt(int index) async {
//     if (index < 0 || index >= videoList.length) return;
//     if (videoControllers.containsKey(index)) return;
//
//     try {
//       final controller = VideoPlayerController.networkUrl(
//         Uri.parse(videoList[index].videoUrl),
//       );
//       await controller.initialize();
//
//       controller.addListener(() {
//         if (index == currentIndex.value) {
//           currentPosition.value = controller.value.position.inMilliseconds.toDouble();
//           videoDuration.value = controller.value.duration.inMilliseconds.toDouble();
//         }
//       });
//
//       videoControllers[index] = controller;
//       isInitialized[index] = true; // 🔥 live change trigger
//
//       controller.setLooping(true);
//     } catch (e) {
//       print('Error initializing video at index $index: $e');
//       isInitialized[index] = false;
//     }
//   }
//
//   // Preload nearby videos
//   void _preloadNearbyVideos() {
//     final current = currentIndex.value;
//
//     // Preload next 2 videos
//     for (int i = 1; i <= 2; i++) {
//       _initializeVideoAt(current + i);
//     }
//
//     // Preload previous 2 videos
//     for (int i = 1; i <= 2; i++) {
//       _initializeVideoAt(current - i);
//     }
//   }
//
//   // Clean up distant videos to free memory
//   void _cleanupDistantVideos() {
//     final current = currentIndex.value;
//     final keysToRemove = <int>[];
//
//     videoControllers.forEach((index, controller) {
//       // Keep current video and 2 videos on each side
//       if ((index - current).abs() > 2) {
//         controller.dispose();
//         keysToRemove.add(index);
//       }
//     });
//
//     for (final key in keysToRemove) {
//       videoControllers.remove(key);
//     }
//   }
//
//   // Navigate to next video
//   void nextVideo() {
//     if (currentIndex.value < videoList.length - 1) {
//       _pauseCurrentVideo();
//       currentIndex.value++;
//       onVideoChanged();
//     }
//   }
//
//
//
//   // Navigate to previous video
//   void previousVideo() {
//     if (currentIndex.value > 0) {
//       _pauseCurrentVideo();
//       currentIndex.value--;
//       onVideoChanged();
//     }
//   }
//
//   // Handle video change
//   // void _onVideoChanged() {
//   //   _preloadNearbyVideos();
//   //   _cleanupDistantVideos();
//   //   playVideo();
//   // }
//   void onVideoChanged() {
//     _preloadNearbyVideos();
//     _cleanupDistantVideos();
//
//     // stop all other videos
//     videoControllers.forEach((i, c) {
//       if (i == currentIndex.value) {
//         c.play();
//         isPlaying.value = true;
//       } else {
//         c.pause();
//       }
//     });
//   }
//
//
//   // Play current video
//   void playVideo() {
//     currentController?.play();
//     isPlaying.value = true;
//   }
//
//   // Pause current video
//   void pauseVideo() {
//     currentController?.pause();
//     isPlaying.value = false;
//   }
//
//   // Toggle play/pause
//   void togglePlayPause() {
//     if (isPlaying.value) {
//       pauseVideo();
//     } else {
//       playVideo();
//     }
//   }
//
//   // Pause current video without changing state
//   void _pauseCurrentVideo() {
//     currentController?.pause();
//   }
//
//   // Seek to position
//   void seekTo(double position) {
//     final duration = currentController?.value.duration;
//     if (duration != null) {
//       final seekPosition = Duration(
//         milliseconds: (position * duration.inMilliseconds).toInt(),
//       );
//       currentController?.seekTo(seekPosition);
//     }
//   }
//
//   @override
//   void onClose() {
//     // Dispose all video controllers
//     videoControllers.values.forEach((controller) {
//       controller.dispose();
//     });
//     videoControllers.clear();
//     super.onClose();
//   }
// }
//
//
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsController extends GetxController {
  final List<VideoModel> videoList;
  final int initialIndex;

  ReelsController({
    required this.videoList,
    this.initialIndex = 0,
  });

  // Observable variables
  final RxInt currentIndex = 0.obs;
  final RxBool isPlaying = true.obs;
  final RxBool isLoading = true.obs;
  final RxDouble currentPosition = 0.0.obs;
  final RxDouble videoDuration = 0.0.obs;
  final RxMap<int, bool> isInitialized = <int, bool>{}.obs;

  // Video controllers cache
  final Map<int, VideoPlayerController> videoControllers = {};
  VideoPlayerController? get currentController =>
      videoControllers[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = initialIndex;
    _initializeInitialVideos();
  }

  // Initialize initial videos
  Future<void> _initializeInitialVideos() async {
    isLoading.value = true;

    try {
      // Initialize current video first
      await initializeVideoAt(currentIndex.value);

      // Initialize nearby videos
      await _preloadNearbyVideos();

      isLoading.value = false;

      // Start playing current video
      if (currentController != null) {
        playCurrentVideo();
      }
    } catch (e) {
      print('Error in initial setup: $e');
      isLoading.value = false;
    }
  }

  // Initialize video at specific index
  Future<void> initializeVideoAt(int index) async {
    if (index < 0 || index >= videoList.length) return;
    if (videoControllers.containsKey(index)) return;

    try {
      final videoUrl = videoList[index].videoUrl;
      print('Initializing video $index: $videoUrl');

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
        },
      );

      // Set a timeout for initialization
      await controller.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      // Add position listener only for current video
      controller.addListener(() {
        if (index == currentIndex.value && controller.value.isInitialized) {
          currentPosition.value = controller.value.position.inMilliseconds.toDouble();
          videoDuration.value = controller.value.duration.inMilliseconds.toDouble();
        }
      });

      // Set looping
      controller.setLooping(true);

      // Store controller and mark as initialized
      videoControllers[index] = controller;
      isInitialized[index] = true;

      print('Video $index initialized successfully');
    } catch (e) {
      print('Error initializing video at index $index: $e');
      isInitialized[index] = false;

      // Show user-friendly error
      // Get.snackbar(
      //   'Video Error',
      //   'Failed to load video ${index + 1}',
      //   backgroundColor: Colors.red.withOpacity(0.8),
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  // Preload nearby videos
  Future<void> _preloadNearbyVideos() async {
    final current = currentIndex.value;
    final List<Future<void>> initTasks = [];

    // Preload next 2 videos
    for (int i = 1; i <= 2; i++) {
      if (current + i < videoList.length) {
        initTasks.add(initializeVideoAt(current + i));
      }
    }

    // Preload previous 2 videos
    for (int i = 1; i <= 2; i++) {
      if (current - i >= 0) {
        initTasks.add(initializeVideoAt(current - i));
      }
    }

    // Wait for all preload tasks to complete
    await Future.wait(initTasks);
  }

  // Clean up distant videos
  void _cleanupDistantVideos() {
    final current = currentIndex.value;
    final keysToRemove = <int>[];

    videoControllers.forEach((index, controller) {
      // Keep current video and 2 videos on each side
      if ((index - current).abs() > 2) {
        controller.dispose();
        keysToRemove.add(index);
      }
    });

    for (final key in keysToRemove) {
      videoControllers.remove(key);
      isInitialized.remove(key);
    }

    print('Cleaned up ${keysToRemove.length} distant videos');
  }

  // Handle video change
  Future<void> onVideoChanged(int newIndex) async {
    final oldIndex = currentIndex.value;
    currentIndex.value = newIndex;

    // Pause old video
    if (videoControllers.containsKey(oldIndex)) {
      videoControllers[oldIndex]?.pause();
    }

    // Reset position and duration
    currentPosition.value = 0.0;
    videoDuration.value = 0.0;

    // Check if new video is initialized
    if (!(isInitialized[newIndex] ?? false)) {
      isLoading.value = true;
      await initializeVideoAt(newIndex);
      isLoading.value = false;
    }

    // Play new video
    playCurrentVideo();

    // Preload nearby videos and cleanup
    _preloadNearbyVideos();
    _cleanupDistantVideos();
  }

  // Play current video
  void playCurrentVideo() {
    final controller = currentController;
    if (controller != null && controller.value.isInitialized) {
      controller.play();
      isPlaying.value = true;
    }
  }

  // Pause current video
  void pauseCurrentVideo() {
    final controller = currentController;
    if (controller != null && controller.value.isInitialized) {
      controller.pause();
      isPlaying.value = false;
    }
  }

  // Toggle play/pause
  void togglePlayPause() {
    if (isPlaying.value) {
      pauseCurrentVideo();
    } else {
      playCurrentVideo();
    }
  }

  // Seek to position (0.0 to 1.0)
  void seekTo(double position) {
    final controller = currentController;
    if (controller != null && controller.value.isInitialized) {
      final duration = controller.value.duration;
      final seekPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).toInt(),
      );
      controller.seekTo(seekPosition);
    }
  }

  // Check if current video is ready
  bool get isCurrentVideoReady {
    final controller = currentController;
    return controller != null &&
        controller.value.isInitialized &&
        (isInitialized[currentIndex.value] ?? false);
  }

  @override
  void onClose() {
    // Dispose all video controllers
    videoControllers.values.forEach((controller) {
      controller.dispose();
    });
    videoControllers.clear();
    isInitialized.clear();
    super.onClose();
  }
}