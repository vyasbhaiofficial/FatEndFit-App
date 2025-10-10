// // import 'package:fat_end_fit/view/testimonial/widget/reels_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../model/video_model.dart';
// //
// // // class ReelsPlayerScreen extends StatelessWidget {
// // //   final List<VideoModel> videoList;
// // //   final int initialIndex;
// // //   final String heroTag;
// // //
// // //   const ReelsPlayerScreen({
// // //     Key? key,
// // //     required this.videoList,
// // //     this.initialIndex = 0,
// // //     required this.heroTag,
// // //   }) : super(key: key);
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final controller = Get.put(
// // //       ReelsController(
// // //         videoList: videoList,
// // //         initialIndex: initialIndex,
// // //       ),
// // //       tag: heroTag,
// // //     );
// // //
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       body: PageView.builder(
// // //         scrollDirection: Axis.vertical,
// // //         controller: PageController(initialPage: initialIndex),
// // //         onPageChanged: (index) {
// // //           controller.currentIndex.value = index;
// // //           controller.onVideoChanged();
// // //         },
// // //         itemCount: videoList.length,
// // //         itemBuilder: (context, index) {
// // //           return Obx(() {
// // //             final isReady = controller.isInitialized[index] ?? false;
// // //             final videoController = controller.videoControllers[index];
// // //
// // //             if (!isReady || videoController == null || !videoController.value.isInitialized) {
// // //               return const Center(
// // //                 child: CircularProgressIndicator(color: Colors.white),
// // //               );
// // //             }
// // //
// // //             return Stack(
// // //               children: [
// // //                 Center(
// // //                   child: AspectRatio(
// // //                     aspectRatio: videoController.value.aspectRatio,
// // //                     child: VideoPlayer(videoController),
// // //                   ),
// // //                 ),
// // //
// // //                 // Play/pause button overlay
// // //                 Center(
// // //                   child: Obx(() => AnimatedOpacity(
// // //                     opacity: controller.isPlaying.value ? 0.0 : 1.0,
// // //                     duration: const Duration(milliseconds: 300),
// // //                     child: Icon(
// // //                       controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
// // //                       color: Colors.white,
// // //                       size: 70,
// // //                     ),
// // //                   )),
// // //                 ),
// // //               ],
// // //             );
// // //           });
// // //         },
// // //       ),
// // //     );
// // //
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:video_player/video_player.dart';
// //
// // class ReelsPlayerScreen extends StatefulWidget {
// //   final List<VideoModel> videoList;
// //   final int initialIndex;
// //   final String heroTag;
// //
// //   const ReelsPlayerScreen({
// //     Key? key,
// //     required this.videoList,
// //     this.initialIndex = 0,
// //     required this.heroTag,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ReelsPlayerScreen> createState() => _ReelsPlayerScreenState();
// // }
// //
// // class _ReelsPlayerScreenState extends State<ReelsPlayerScreen> {
// //   late PageController _pageController;
// //   late ReelsController _reelsController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController(initialPage: widget.initialIndex);
// //     _reelsController = Get.put(
// //       ReelsController(
// //         videoList: widget.videoList,
// //         initialIndex: widget.initialIndex,
// //       ),
// //       tag: widget.heroTag,
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     Get.delete<ReelsController>(tag: widget.heroTag);
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Hero(
// //         tag: widget.heroTag,
// //         child: SafeArea(
// //           child: Stack(
// //             children: [
// //               // PageView for videos
// //               PageView.builder(
// //                 controller: _pageController,
// //                 scrollDirection: Axis.vertical,
// //                 onPageChanged: (index) {
// //                   _reelsController.onVideoChanged(index);
// //                 },
// //                 itemCount: widget.videoList.length,
// //                 itemBuilder: (context, index) {
// //                   return _buildVideoPlayer(index);
// //                 },
// //               ),
// //
// //               // Close button
// //               Positioned(
// //                 top: 16,
// //                 left: 16,
// //                 child: GestureDetector(
// //                   onTap: () => Get.back(),
// //                   child: Container(
// //                     padding: const EdgeInsets.all(8),
// //                     decoration: BoxDecoration(
// //                       color: Colors.black.withOpacity(0.5),
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: const Icon(
// //                       Icons.close,
// //                       color: Colors.white,
// //                       size: 24,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Video counter
// //               Positioned(
// //                 top: 16,
// //                 right: 16,
// //                 child: Obx(() {
// //                   return Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: Colors.black.withOpacity(0.5),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       '${_reelsController.currentIndex.value + 1}/${widget.videoList.length}',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   );
// //                 }),
// //               ),
// //
// //               // Bottom progress bar
// //               // Positioned(
// //               //   bottom: 20,
// //               //   left: 20,
// //               //   right: 20,
// //               //   child: Obx(() {
// //               //     if (!_reelsController.isCurrentVideoReady) {
// //               //       return const SizedBox.shrink();
// //               //     }
// //               //
// //               //     final duration = _reelsController.videoDuration.value;
// //               //     final position = _reelsController.currentPosition.value;
// //               //
// //               //     if (duration == 0) return const SizedBox.shrink();
// //               //
// //               //     return SliderTheme(
// //               //       data: SliderTheme.of(context).copyWith(
// //               //         activeTrackColor: Colors.white,
// //               //         inactiveTrackColor: Colors.white.withOpacity(0.3),
// //               //         thumbColor: Colors.white,
// //               //         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
// //               //         trackHeight: 2,
// //               //         overlayShape: SliderComponentShape.noOverlay,
// //               //       ),
// //               //       child: Slider(
// //               //         value: duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0,
// //               //         onChanged: (value) {
// //               //           _reelsController.seekTo(value);
// //               //         },
// //               //       ),
// //               //     );
// //               //   }),
// //               // ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildVideoPlayer(int index) {
// //     return Obx(() {
// //       final controller = _reelsController.videoControllers[index];
// //       final isReady = _reelsController.isInitialized[index] ?? false;
// //       final isCurrent = _reelsController.currentIndex.value == index;
// //
// //       // Show loading for current video
// //       if (isCurrent && (_reelsController.isLoading.value || !isReady || controller == null)) {
// //         return Container(
// //           color: Colors.black,
// //           child: const Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 CircularProgressIndicator(
// //                   color: Colors.white,
// //                   strokeWidth: 2,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'Loading video...',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       }
// //
// //       // Show error state if video failed to load
// //       if (isCurrent && isReady == false) {
// //         return Container(
// //           color: Colors.black,
// //           child: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Icon(
// //                   Icons.error_outline,
// //                   color: Colors.red,
// //                   size: 60,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 const Text(
// //                   'Failed to load video',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 const Text(
// //                   'Please check your internet connection',
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     _reelsController.initializeVideoAt(index);
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.white,
// //                     foregroundColor: Colors.black,
// //                   ),
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       }
// //
// //       // Show placeholder for non-current videos that aren't ready
// //       if (!isReady || controller == null || !controller.value.isInitialized) {
// //         return Container(
// //           color: Colors.grey[900],
// //           child: const Center(
// //             child: Icon(
// //               Icons.video_library,
// //               color: Colors.white54,
// //               size: 50,
// //             ),
// //           ),
// //         );
// //       }
// //
// //       return GestureDetector(
// //         onTap: () {
// //           if (isCurrent) {
// //             _reelsController.togglePlayPause();
// //           }
// //         },
// //         child: Container(
// //           color: Colors.black,
// //           child: Stack(
// //             fit: StackFit.expand,
// //             children: [
// //               // Video player
// //               Center(
// //                 child: AspectRatio(
// //                   aspectRatio: controller.value.aspectRatio,
// //                   child: VideoPlayer(controller),
// //                 ),
// //               ),
// //
// //               // Play/pause overlay - only show for current video
// //               if (isCurrent)
// //                 Center(
// //                   child: Obx(() {
// //                     return AnimatedOpacity(
// //                       opacity: _reelsController.isPlaying.value ? 0.0 : 1.0,
// //                       duration: const Duration(milliseconds: 300),
// //                       child: Container(
// //                         padding: const EdgeInsets.all(20),
// //                         decoration: BoxDecoration(
// //                           color: Colors.black.withOpacity(0.5),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Icon(
// //                           _reelsController.isPlaying.value
// //                               ? Icons.pause
// //                               : Icons.play_arrow,
// //                           color: Colors.white,
// //                           size: 50,
// //                         ),
// //                       ),
// //                     );
// //                   }),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       );
// //     });
// //   }
// // }
//
// // =============================
// // Flutter + GetX Reels with HeroTag + VideoModel
// // =============================
// //
// // pubspec.yaml deps:
// //   get, video_player, flutter_cache_manager, visibility_detector, get_storage
// // =============================
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../../utils/app_storage.dart';
// import '../model/video_model.dart';
//
// // -----------------------------
// // Data Model
// // -----------------------------
// // class VideoModel {
// //   final String videoUrl;
// //   final String title;
// //   final String description;
// //
// //   VideoModel({
// //     required this.videoUrl,
// //     required this.title,
// //     required this.description,
// //   });
// //
// //   factory VideoModel.fromJson(Map<String, dynamic> json) {
// //     return VideoModel(
// //       videoUrl: json['videoUrl'] ?? '',
// //       title: json['title'] ?? '',
// //       description: json['dec'] ?? '',
// //     );
// //   }
// // }
//
// // -----------------------------
// // ReelsPlayerScreen (common screen with hero tag)
// // -----------------------------
// class ReelsPlayerScreen extends StatefulWidget {
//   final List<VideoModel> videoList;
//   final int initialIndex;
//   final String heroTag;
//
//   const ReelsPlayerScreen({super.key, required this.videoList, required this.initialIndex, required this.heroTag});
//
//   @override
//   State<ReelsPlayerScreen> createState() => _ReelsPlayerScreenState();
// }
//
// class _ReelsPlayerScreenState extends State<ReelsPlayerScreen> with WidgetsBindingObserver {
//   late final ReelsController c;
//   late final PageController pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     c = Get.put(ReelsController(videoList: widget.videoList));
//     pageController = PageController(initialPage: widget.initialIndex);
//     c.initPool(initialIndex: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     c.disposeSafely();
//     pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       c.pauseCurrent();
//     } else if (state == AppLifecycleState.resumed) {
//       c.playCurrent();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         bottom: false,
//         child: Hero(
//           tag: widget.heroTag,
//           child: Obx(() {
//             return PageView.builder(
//               scrollDirection: Axis.vertical,
//               controller: pageController,
//               itemCount: widget.videoList.length,
//               onPageChanged: (i) => c.onPageChanged(i),
//               itemBuilder: (_, i) => ReelItem(index: i, model: widget.videoList[i]),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // ReelItem
// // -----------------------------
// class ReelItem extends StatelessWidget {
//   final int index;
//   final VideoModel model;
//   const ReelItem({super.key, required this.index, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ReelsController>();
//     return VisibilityDetector(
//       key: ValueKey('reel-$index'),
//       onVisibilityChanged: (info) {
//         if (info.visibleFraction >= 0.6) c.ensureCurrent(index);
//       },
//       child: SizedBox.expand(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Obx(() {
//               final vc = c.controllerFor(index);
//               if (vc == null || !vc.value.isInitialized) return const Center(child: CircularProgressIndicator());
//               return GestureDetector(
//                 onTap: c.togglePlayPause,
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: vc.value.size.width,
//                     height: vc.value.size.height,
//                     child: VideoPlayer(vc),
//                   ),
//                 ),
//               );
//             }),
//             Positioned(
//               left: 12,
//               bottom: 28,
//               right: 12,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const CircleAvatar(radius: 22, child: Icon(Icons.person)),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(model.title, style: const TextStyle(fontWeight: FontWeight.w600)),
//                         const SizedBox(height: 6),
//                         Text(model.description, maxLines: 2, overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // GetX Controller
// // -----------------------------
// class ReelsController extends GetxController {
//   final List<VideoModel> videoList;
//   ReelsController({required this.videoList});
//
//   final currentIndex = 0.obs;
//   final isMuted = true.obs;
//   final isPlaying = true.obs;
//   final Map<int, VideoPlayerController> _pool = {};
//   final _cache = DefaultCacheManager();
//   bool _isSwitching = false;
//
//   Future<void> initPool({int initialIndex = 0}) async {
//     currentIndex.value = initialIndex;
//     await _prepareForIndex(initialIndex);
//     playCurrent();
//   }
//
//   Future<void> onPageChanged(int i) async {
//     if (_isSwitching) return;
//     _isSwitching = true;
//     try {
//       currentIndex.value = i;
//       await AppStorage().save('lastIndex', i);
//       await _prepareForIndex(i);
//       playCurrent();
//     } finally {
//       _isSwitching = false;
//     }
//   }
//
//   void ensureCurrent(int i) {
//     if (i == currentIndex.value) playCurrent();
//   }
//
//   VideoPlayerController? controllerFor(int i) => _pool[i];
//
//   Future<void> _prepareForIndex(int i) async {
//     await _ensureController(i);
//     await Future.wait([
//       if (i - 1 >= 0) _ensureController(i - 1) else Future.value(),
//       if (i + 1 < videoList.length) _ensureController(i + 1) else Future.value(),
//     ]);
//     final allowed = {i - 1, i, i + 1};
//     final toRemove = _pool.keys.where((k) => !allowed.contains(k)).toList();
//     for (final k in toRemove) {
//       await _disposeAt(k);
//     }
//     for (final vc in _pool.values) {
//       await vc.setVolume(isMuted.value ? 0 : 1);
//     }
//   }
//
//   Future<void> _ensureController(int i) async {
//     if (_pool.containsKey(i) || i < 0 || i >= videoList.length) return;
//     final url = videoList[i].videoUrl;
//     VideoPlayerController controller;
//     if (_isMp4(url)) {
//       final file = await _tryGetCachedFile(url);
//       controller = file != null ? VideoPlayerController.file(file) : VideoPlayerController.networkUrl(Uri.parse(url));
//       unawaited(_cache.getSingleFile(url));
//     } else {
//       controller = VideoPlayerController.networkUrl(Uri.parse(url));
//     }
//     await controller.initialize();
//     await controller.setLooping(true);
//     await controller.setVolume(isMuted.value ? 0 : 1);
//     _pool[i] = controller;
//     if (i == currentIndex.value) {
//       await controller.play();
//       isPlaying.value = true;
//     }
//   }
//
//   Future<File?> _tryGetCachedFile(String url) async {
//     try {
//       final cached = await _cache.getFileFromCache(url);
//       return cached?.file;
//     } catch (_) {
//       return null;
//     }
//   }
//
//   bool _isMp4(String url) => url.toLowerCase().endsWith('.mp4');
//
//   Future<void> _disposeAt(int i) async {
//     final vc = _pool.remove(i);
//     if (vc != null) {
//       try {
//         await vc.pause();
//         await vc.dispose();
//       } catch (_) {}
//     }
//   }
//
//   Future<void> playCurrent() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null || !vc.value.isInitialized) return;
//     await vc.play();
//     isPlaying.value = true;
//   }
//
//   Future<void> pauseCurrent() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null) return;
//     await vc.pause();
//     isPlaying.value = false;
//   }
//
//   Future<void> togglePlayPause() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null) return;
//     if (vc.value.isPlaying) {
//       await vc.pause();
//       isPlaying.value = false;
//     } else {
//       await vc.play();
//       isPlaying.value = true;
//     }
//   }
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     for (final vc in _pool.values) {
//       await vc.setVolume(isMuted.value ? 0 : 1);
//     }
//     await AppStorage().save('isMuted', isMuted.value);
//   }
//
//   void disposeSafely() {
//     for (final vc in _pool.values) {
//       try {
//         vc.dispose();
//       } catch (_) {}
//     }
//     _pool.clear();
//   }
// }
// =============================
// Flutter + GetX Reels with HeroTag + VideoModel (fixed Obx usage)
// =============================

import 'dart:async';
import 'dart:io';

import 'package:fat_end_fit/utils/app_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/app_storage.dart';
import '../../../utils/common/app_text.dart';
import '../model/video_model.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'dart:io';

// -----------------------------
// Enhanced ReelsPlayerScreen with Amazing UI
// -----------------------------
class ReelsPlayerScreen extends StatefulWidget {
  final List<VideoModel> videoList;
  final int initialIndex;
  final String heroTag;

  const ReelsPlayerScreen({
    super.key,
    required this.videoList,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  State<ReelsPlayerScreen> createState() => _ReelsPlayerScreenState();
}

class _ReelsPlayerScreenState extends State<ReelsPlayerScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final ReelsController c;
  late final PageController pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    c = Get.put(ReelsController(videoList: widget.videoList));
    pageController = PageController(initialPage: widget.initialIndex);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    c.initPool(initialIndex: widget.initialIndex);
    _fadeController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    c.disposeSafely();
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      c.pauseCurrent();
    } else if (state == AppLifecycleState.resumed) {
      c.playCurrent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Obx(() => IconButton(
              icon: Icon(
                c.isMuted.value ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
              onPressed: c.toggleMute,
            )),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Hero(
          tag: widget.heroTag,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: pageController,
            itemCount: widget.videoList.length,
            onPageChanged: (i) => c.onPageChanged(i),
            itemBuilder: (_, i) => ReelItem(
              index: i,
              model: widget.videoList[i],
              isActive: i == c.currentIndex.value,
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------
// Enhanced ReelItem with Amazing UI
// -----------------------------
class ReelItem extends StatefulWidget {
  final int index;
  final VideoModel model;
  final bool isActive;

  const ReelItem({
    super.key,
    required this.index,
    required this.model,
    this.isActive = false,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showPlayButton = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    AppLogs.log("model - - ${widget.model.videoUrl}");
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showPlayButtonTemporary() {
    setState(() => _showPlayButton = true);
    _animationController.forward();
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) setState(() => _showPlayButton = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ReelsController>();

    return VisibilityDetector(
      key: ValueKey('reel-${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= 0.6) c.ensureCurrent(widget.index);
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Colors.transparent, Colors.black26],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player
            _buildVideoPlayer(c),

            // Play/Pause Button Overlay
            if (_showPlayButton) _buildPlayButtonOverlay(c),

            // Bottom Gradient
            _buildBottomGradient(),

            // User Info and Actions
            _buildBottomContent(),

            // Side Actions
            // _buildSideActions(c),

            // Loading Indicator
            _buildLoadingIndicator(c),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(ReelsController c) {
    return Obx(() {
      c.isPlaying.value; // Reactive dependency
      final vc = c.controllerFor(widget.index);

      if (vc == null || !vc.value.isInitialized) {
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      return GestureDetector(
        onTap: () {
          c.togglePlayPause();
          _showPlayButtonTemporary();
        },
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: vc.value.size.width,
            height: vc.value.size.height,
            child: VideoPlayer(vc),
          ),
        ),
      );
    });
  }

  Widget _buildPlayButtonOverlay(ReelsController c) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Obx(() => Icon(
                  c.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.4),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Positioned(
      left: 16,
      bottom: 20,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Info
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  widget.model.title,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          // Text(
          //   widget.model.title,
          //   style: const TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //   ),
          // ),
          // const SizedBox(height: 8),

          // Description
          Text(
            widget.model.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ReelsController c) {
    return Obx(() {
      c.isPlaying.value; // reactive rebuild
      final vc = c.controllerFor(widget.index);
      final isLoading = vc == null || !vc.value.isInitialized;

      if (!isLoading) return const SizedBox.shrink();

      return Positioned.fill( // 👈 covers the entire screen
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade900,
          highlightColor: Colors.grey.shade700,
          child: Container(
            color: Colors.black, // fallback background
          ),
        ),
      );
    });
  }
}

// -----------------------------
// Enhanced GetX Controller with Performance Optimizations
// -----------------------------
class ReelsController extends GetxController {
  final List<VideoModel> videoList;
  ReelsController({required this.videoList});

  final currentIndex = 0.obs;
  final isMuted = true.obs;
  final isPlaying = true.obs;
  final isLoading = false.obs;
  final Map<int, VideoPlayerController> _pool = {};
  final _cache = DefaultCacheManager();
  bool _isSwitching = false;

  // Performance optimization: Preload range
  static const int _preloadRange = 2;

  Future<void> initPool({int initialIndex = 0}) async {
    currentIndex.value = initialIndex;
    isLoading.value = true;
    await _prepareForIndex(initialIndex);
    await playCurrent();
    isLoading.value = false;
  }

  Future<void> onPageChanged(int i) async {
    if (_isSwitching) return;
    _isSwitching = true;
    try {
      // Pause current before switching
      await pauseCurrent();
      currentIndex.value = i;

      // Save state
      await AppStorage().save('lastIndex', i);

      // Prepare new index
      await _prepareForIndex(i);

      // Start playing new video
      await playCurrent();
    } finally {
      _isSwitching = false;
    }
  }

  void ensureCurrent(int i) {
    if (i == currentIndex.value) playCurrent();
  }

  VideoPlayerController? controllerFor(int i) => _pool[i];

  Future<void> _prepareForIndex(int i) async {
    // Ensure current video is ready first (priority)
    await _ensureController(i);

    // Preload adjacent videos in background
    final futures = <Future>[];

    for (int offset = 1; offset <= _preloadRange; offset++) {
      // Previous videos
      if (i - offset >= 0) {
        futures.add(_ensureController(i - offset));
      }
      // Next videos
      if (i + offset < videoList.length) {
        futures.add(_ensureController(i + offset));
      }
    }

    // Wait for adjacent videos to load
    await Future.wait(futures);

    // Clean up distant videos to save memory
    final allowedIndices = <int>{};
    for (int offset = 0; offset <= _preloadRange; offset++) {
      if (i - offset >= 0) allowedIndices.add(i - offset);
      if (i + offset < videoList.length) allowedIndices.add(i + offset);
    }

    final toRemove = _pool.keys.where((k) => !allowedIndices.contains(k)).toList();
    for (final k in toRemove) {
      await _disposeAt(k);
    }

    // Update volume for all controllers
    for (final vc in _pool.values) {
      await vc.setVolume(isMuted.value ? 0 : 1);
    }
  }

  Future<void> _ensureController(int i) async {
    if (_pool.containsKey(i) || i < 0 || i >= videoList.length) return;

    final url = videoList[i].videoUrl;
    VideoPlayerController controller;

    try {
      // Try to use cached file for MP4s
      if (_isMp4(url)) {
        final file = await _tryGetCachedFile(url);
        if (file != null) {
          controller = VideoPlayerController.file(file);
        } else {
          controller = VideoPlayerController.networkUrl(Uri.parse(url));
          // Start caching in background
          unawaited(_cache.getSingleFile(url));
        }
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }

      // Initialize with optimizations
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(isMuted.value ? 0 : 1);

      // Set playback speed for smooth performance
      await controller.setPlaybackSpeed(1.0);

      _pool[i] = controller;

      // Auto-play if this is the current video
      if (i == currentIndex.value) {
        await controller.play();
        isPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error initializing video at index $i: $e');
    }
  }

  Future<File?> _tryGetCachedFile(String url) async {
    try {
      final cached = await _cache.getFileFromCache(url);
      return cached?.file;
    } catch (_) {
      return null;
    }
  }

  bool _isMp4(String url) => url.toLowerCase().endsWith('.mp4');

  Future<void> _disposeAt(int i) async {
    final vc = _pool.remove(i);
    if (vc != null) {
      try {
        await vc.pause();
        await vc.dispose();
      } catch (_) {
        // Ignore disposal errors
      }
    }
  }

  Future<void> playCurrent() async {
    final vc = _pool[currentIndex.value];
    if (vc == null || !vc.value.isInitialized) return;

    try {
      await vc.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  Future<void> pauseCurrent() async {
    final vc = _pool[currentIndex.value];
    if (vc == null) return;

    try {
      await vc.pause();
      isPlaying.value = false;
    } catch (e) {
      debugPrint('Error pausing video: $e');
    }
  }

  Future<void> togglePlayPause() async {
    final vc = _pool[currentIndex.value];
    if (vc == null) return;

    try {
      if (vc.value.isPlaying) {
        await vc.pause();
        isPlaying.value = false;
      } else {
        await vc.play();
        isPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }

  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;

    // Update all controllers
    for (final vc in _pool.values) {
      try {
        await vc.setVolume(isMuted.value ? 0 : 1);
      } catch (e) {
        debugPrint('Error updating volume: $e');
      }
    }

    // Save state
    await AppStorage().save('isMuted', isMuted.value);
  }

  void disposeSafely() {
    for (final vc in _pool.values) {
      try {
        vc.dispose();
      } catch (_) {
        // Ignore disposal errors
      }
    }
    _pool.clear();
  }
}

// -----------------------------
// ReelsPlayerScreen (common screen with hero tag)
// // -----------------------------
// class ReelsPlayerScreen extends StatefulWidget {
//   final List<VideoModel> videoList;
//   final int initialIndex;
//   final String heroTag;
//
//   const ReelsPlayerScreen({super.key, required this.videoList, required this.initialIndex, required this.heroTag});
//
//   @override
//   State<ReelsPlayerScreen> createState() => _ReelsPlayerScreenState();
// }
//
// class _ReelsPlayerScreenState extends State<ReelsPlayerScreen> with WidgetsBindingObserver {
//   late final ReelsController c;
//   late final PageController pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     c = Get.put(ReelsController(videoList: widget.videoList));
//     pageController = PageController(initialPage: widget.initialIndex);
//     c.initPool(initialIndex: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     c.disposeSafely();
//     pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       c.pauseCurrent();
//     } else if (state == AppLifecycleState.resumed) {
//       c.playCurrent();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         bottom: false,
//         child: Hero(
//           tag: widget.heroTag,
//           // FIX: Obx was wrapping entire PageView unnecessarily.
//           // Only rebuild on currentIndex changes.
//           child: PageView.builder(
//             scrollDirection: Axis.vertical,
//             controller: pageController,
//             itemCount: widget.videoList.length,
//             onPageChanged: (i) => c.onPageChanged(i),
//             itemBuilder: (_, i) => ReelItem(index: i, model: widget.videoList[i]),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // ReelItem
// // -----------------------------
// class ReelItem extends StatelessWidget {
//   final int index;
//   final VideoModel model;
//   const ReelItem({super.key, required this.index, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ReelsController>();
//     return VisibilityDetector(
//       key: ValueKey('reel-$index'),
//       onVisibilityChanged: (info) {
//         if (info.visibleFraction >= 0.6) c.ensureCurrent(index);
//       },
//       child: SizedBox.expand(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // FIX: Obx wraps only the widget that needs reactive updates (VideoPlayer)
//             Obx(() {
//               c.isPlaying.value;
//               final vc = c.controllerFor(index);
//               if (vc == null || !vc.value.isInitialized) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return GestureDetector(
//                 onTap: c.togglePlayPause,
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: vc.value.size.width,
//                     height: vc.value.size.height,
//                     child: VideoPlayer(vc),
//                   ),
//                 ),
//               );
//             }),
//             Positioned(
//               left: 12,
//               bottom: 28,
//               right: 12,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const CircleAvatar(radius: 22, child: Icon(Icons.person)),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(model.title, style: const TextStyle(fontWeight: FontWeight.w600)),
//                         const SizedBox(height: 6),
//                         Text(model.description, maxLines: 2, overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // GetX Controller
// // -----------------------------
// class ReelsController extends GetxController {
//   final List<VideoModel> videoList;
//   ReelsController({required this.videoList});
//
//   final currentIndex = 0.obs;
//   final isMuted = true.obs;
//   final isPlaying = true.obs;
//   final Map<int, VideoPlayerController> _pool = {};
//   final _cache = DefaultCacheManager();
//   bool _isSwitching = false;
//
//   Future<void> initPool({int initialIndex = 0}) async {
//     currentIndex.value = initialIndex;
//     await _prepareForIndex(initialIndex);
//     playCurrent();
//   }
//
//   Future<void> onPageChanged(int i) async {
//     if (_isSwitching) return;
//     _isSwitching = true;
//     try {
//       currentIndex.value = i;
//       await AppStorage().save('lastIndex', i);
//       await _prepareForIndex(i);
//       playCurrent();
//     } finally {
//       _isSwitching = false;
//     }
//   }
//
//   void ensureCurrent(int i) {
//     if (i == currentIndex.value) playCurrent();
//   }
//
//   VideoPlayerController? controllerFor(int i) => _pool[i];
//
//   Future<void> _prepareForIndex(int i) async {
//     await _ensureController(i);
//     await Future.wait([
//       if (i - 1 >= 0) _ensureController(i - 1) else Future.value(),
//       if (i + 1 < videoList.length) _ensureController(i + 1) else Future.value(),
//     ]);
//     final allowed = {i - 1, i, i + 1};
//     final toRemove = _pool.keys.where((k) => !allowed.contains(k)).toList();
//     for (final k in toRemove) {
//       await _disposeAt(k);
//     }
//     for (final vc in _pool.values) {
//       await vc.setVolume(isMuted.value ? 0 : 1);
//     }
//   }
//
//   Future<void> _ensureController(int i) async {
//     if (_pool.containsKey(i) || i < 0 || i >= videoList.length) return;
//     final url = videoList[i].videoUrl;
//     VideoPlayerController controller;
//     if (_isMp4(url)) {
//       final file = await _tryGetCachedFile(url);
//       controller = file != null ? VideoPlayerController.file(file) : VideoPlayerController.networkUrl(Uri.parse(url));
//       unawaited(_cache.getSingleFile(url));
//     } else {
//       controller = VideoPlayerController.networkUrl(Uri.parse(url));
//     }
//     await controller.initialize();
//     await controller.setLooping(true);
//     await controller.setVolume(isMuted.value ? 0 : 1);
//     _pool[i] = controller;
//     if (i == currentIndex.value) {
//       await controller.play();
//       isPlaying.value = true;
//     }
//   }
//
//   Future<File?> _tryGetCachedFile(String url) async {
//     try {
//       final cached = await _cache.getFileFromCache(url);
//       return cached?.file;
//     } catch (_) {
//       return null;
//     }
//   }
//
//   bool _isMp4(String url) => url.toLowerCase().endsWith('.mp4');
//
//   Future<void> _disposeAt(int i) async {
//     final vc = _pool.remove(i);
//     if (vc != null) {
//       try {
//         await vc.pause();
//         await vc.dispose();
//       } catch (_) {}
//     }
//   }
//
//   Future<void> playCurrent() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null || !vc.value.isInitialized) return;
//     await vc.play();
//     isPlaying.value = true;
//   }
//
//   Future<void> pauseCurrent() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null) return;
//     await vc.pause();
//     isPlaying.value = false;
//   }
//
//   Future<void> togglePlayPause() async {
//     final vc = _pool[currentIndex.value];
//     if (vc == null) return;
//     if (vc.value.isPlaying) {
//       await vc.pause();
//       isPlaying.value = false;
//     } else {
//       await vc.play();
//       isPlaying.value = true;
//     }
//   }
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     for (final vc in _pool.values) {
//       await vc.setVolume(isMuted.value ? 0 : 1);
//     }
//     await AppStorage().save('isMuted', isMuted.value);
//   }
//
//   void disposeSafely() {
//     for (final vc in _pool.values) {
//       try {
//         vc.dispose();
//       } catch (_) {}
//     }
//     _pool.clear();
//   }
// }