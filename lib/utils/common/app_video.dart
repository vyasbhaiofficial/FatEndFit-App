import 'dart:async';
import 'package:fat_end_fit/utils/app_color.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;

import 'app_image.dart';

class CustomVideoPlayerController extends GetxController {
  late vp.VideoPlayerController _controller;
  RxBool isPlaying = false.obs;
  RxBool isShowControls = true.obs;
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxDouble progress = 0.0.obs;
  RxString currentTime = '00:00'.obs;
  RxString totalTime = '00:00'.obs;
  RxBool isFullscreen = false.obs;

  // New properties for seek restriction
  RxDouble maxWatchedSeconds = 0.0.obs;
  double initialSeconds;
  bool hasInitialSeekDone = false;

  Timer? _hideControlsTimer;
  Timer? _progressTimer;
  Function(Duration current, Duration total, bool isFullScreen, double maxWatchedSeconds)? onChange;
  String videoUrl;
  bool seekVideoEnabled;

  CustomVideoPlayerController({
    this.onChange,
    this.videoUrl = '',
    this.seekVideoEnabled = true,
    this.initialSeconds = 0.0,
    double maxWatchedSeconds = 0.0,
  }) {
    this.maxWatchedSeconds.value = maxWatchedSeconds;
  }

  @override
  void onInit() {
    super.onInit();
    AppLogs.log(" ON INIT CALL: CustomVideoPlayerController initialized with videoUrl: $videoUrl, initialSeconds: $initialSeconds");
    initializePlayer();
  }

  void initializePlayer() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      hasInitialSeekDone = false;

      _controller = vp.VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        // viewType: vp.VideoViewType.platformView,
        videoPlayerOptions: vp.VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      _controller.addListener(_videoListener);
      await _controller.initialize();

      // Set up listeners

      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        return !_controller.value.isInitialized ||
            _controller.value.duration == Duration.zero;
      });

      isLoading.value = false;
      AppLogs.log("isLoading set to false");

      totalTime.value = _formatDuration(_controller.value.duration);
      AppLogs.log("totalTime updated = ${totalTime.value} (video duration = ${_controller.value.duration})");

      AppLogs.log("Controller initialSeconds. initialSeconds = ${initialSeconds}");

      // Seek to initial seconds if provided
      if (initialSeconds > 0) {
        AppLogs.log("initialSeconds provided = $initialSeconds");

        final initialDuration = Duration(seconds: initialSeconds.toInt());
        AppLogs.log("initialDuration = $initialDuration");

        final videoDuration = _controller.value.duration;
        AppLogs.log("videoDuration = $videoDuration");

        if (initialDuration <= videoDuration) {
          AppLogs.log("Initial duration is within video length → Seeking to $initialDuration");
          await _controller.seekTo(initialDuration);
          AppLogs.log("Seek complete to $initialDuration");

          hasInitialSeekDone = true;
          AppLogs.log("hasInitialSeekDone set to $hasInitialSeekDone");
        } else {
          AppLogs.log("initialDuration > videoDuration → Seek skipped");
        }
      } else {
        AppLogs.log("No initialSeconds provided (=$initialSeconds), skipping seek");
      }


      _startProgressTimer();
      _startHideControlsTimer();

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load video: ${e.toString()}';
      isLoading.value = false;
    }
  }

  void _videoListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_controller.value.hasError) {
      hasError.value = true;
      errorMessage.value = _controller.value.errorDescription ?? 'Unknown error';
      return;
    }

    isPlaying.value = _controller.value.isPlaying;

    if (_controller.value.duration.inMilliseconds > 0) {
      progress.value = _controller.value.position.inMilliseconds /
          _controller.value.duration.inMilliseconds;
      currentTime.value = _formatDuration(_controller.value.position);

      // Update max watched seconds
      double currentSeconds = _controller.value.position.inSeconds.toDouble();
      if (currentSeconds > maxWatchedSeconds.value) {
        maxWatchedSeconds.value = currentSeconds;
      }

      // 🔥 Fire callback with max watched seconds
      onChange?.call(
        _controller.value.position,
        _controller.value.duration,
        isFullscreen.value,
        maxWatchedSeconds.value,
      );
    }
      });
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_controller.value.isInitialized && _controller.value.isPlaying) {
        if (_controller.value.duration.inMilliseconds > 0) {
          progress.value = _controller.value.position.inMilliseconds /
              _controller.value.duration.inMilliseconds;
          currentTime.value = _formatDuration(_controller.value.position);

          // Update max watched seconds during playback
          double currentSeconds = _controller.value.position.inSeconds.toDouble();
          if (currentSeconds > maxWatchedSeconds.value) {
            maxWatchedSeconds.value = currentSeconds;
          }
        }
      }
      if (_controller.value.isInitialized) {
        onChange?.call(
          _controller.value.position,
          _controller.value.duration,
          isFullscreen.value,
          maxWatchedSeconds.value,
        );
      }
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 5), () {
      if (isShowControls.value) {
        hideControls();
      }
    });
  }

  void _resetHideControlsTimer() {
    if (isShowControls.value) {
      _startHideControlsTimer();
    }
  }

  void togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      isPlaying.value = false;
    } else {
      _controller.play();
      isPlaying.value = true;
    }
    _resetHideControlsTimer();
  }

  void toggleControls() {
    if (isShowControls.value) {
      hideControls();
    } else {
      isShowControls.value = true;
      _startHideControlsTimer();
    }
  }

  void showControls() {
    isShowControls.value = true;
    _startHideControlsTimer();
  }

  void hideControls() {
    isShowControls.value = false;
    _hideControlsTimer?.cancel();
  }

  bool _canSeekToPosition(double value) {
    if (!seekVideoEnabled) return false;

    final totalDuration = _controller.value.duration;
    final requestedSeconds = totalDuration.inSeconds * value;
    final totalSeconds = totalDuration.inSeconds.toDouble();

    // If user has watched the complete video, allow seeking anywhere
    if (maxWatchedSeconds.value >= totalSeconds) {
      return true;
    }

    // Otherwise, only allow seeking up to max watched seconds
    return requestedSeconds <= maxWatchedSeconds.value;
  }

  void seekTo(double value) {
    if (!_canSeekToPosition(value)) {
      return;
    }

    final duration = _controller.value.duration;
    final position = duration * value;
    _controller.seekTo(position);
    _resetHideControlsTimer();
  }

  void seekForward() {
    if (!seekVideoEnabled) return;

    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + Duration(seconds: 10);
    final maxPosition = _controller.value.duration;
    final totalSeconds = maxPosition.inSeconds.toDouble();

    Duration targetPosition;
    if (newPosition < maxPosition) {
      targetPosition = newPosition;
    } else {
      targetPosition = maxPosition;
    }

    // Check if we can seek to this position
    double targetSeconds = targetPosition.inSeconds.toDouble();
    if (maxWatchedSeconds.value >= totalSeconds || targetSeconds <= maxWatchedSeconds.value) {
      _controller.seekTo(targetPosition);
    } else {
      // Seek to max watched position instead
      _controller.seekTo(Duration(seconds: maxWatchedSeconds.value.toInt()));
    }

    _resetHideControlsTimer();
  }

  void seekBackward() {
    if (!seekVideoEnabled) return;

    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - Duration(seconds: 10);

    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(Duration.zero);
    }
    _resetHideControlsTimer();
  }

  // Method to update max watched seconds externally if needed
  void updateMaxWatchedSeconds(double seconds) {
    if (seconds > maxWatchedSeconds.value) {
      maxWatchedSeconds.value = seconds;
    }
  }

  // Method to check if user can seek to a specific time
  bool canSeekToTime(double seconds) {
    if (!seekVideoEnabled) return false;

    final totalSeconds = _controller.value.duration.inSeconds.toDouble();

    // If user has watched the complete video, allow seeking anywhere
    if (maxWatchedSeconds.value >= totalSeconds) {
      return true;
    }

    // Otherwise, only allow seeking up to max watched seconds
    return seconds <= maxWatchedSeconds.value;
  }

  changeNext() {
    print('Change to next video');
  }

  changePrevious() {
    print('Change to previous video');
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;

    if (isFullscreen.value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    _resetHideControlsTimer();
  }

  void retry() {
    hasError.value = false;
    errorMessage.value = '';
    initializePlayer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  void onClose() {
    _hideControlsTimer?.cancel();
    _progressTimer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.onClose();
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final String? anyMessage;
  final double height;
  final bool seekVideoEnabled;
  final bool showNextButton;
  final bool showFullScreenButton;
  final Function()? onNext;
  final Function()? onPrevious;
  final Function(Duration current, Duration total, bool isFullScreen, double maxWatchedSeconds)? onChange;
  final Function(bool isplay)? onPlayPauseChange;
  final double initialSeconds;
  final double maxWatchedSeconds;
  final double spaceUperCenterControlls;
  final double radius;

  const CustomVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.height = 250,
    this.onChange,
    this.onPlayPauseChange,
    this.thumbnailUrl,
    this.anyMessage,
    this.onNext,
    this.onPrevious,
    this.seekVideoEnabled = true,
    this.showNextButton = true,
    this.showFullScreenButton = true,
    this.initialSeconds = 0.0,
    this.maxWatchedSeconds = 0.0,
    this.spaceUperCenterControlls = 70.0,
    this.radius = 10.0,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late CustomVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CustomVideoPlayerController(
        videoUrl: widget.videoUrl,
        seekVideoEnabled: widget.seekVideoEnabled,
        initialSeconds: widget.initialSeconds,
        maxWatchedSeconds: widget.maxWatchedSeconds,
        onChange: (current, total, isFullScreen, maxWatched) {
          widget.onChange?.call(current, total, isFullScreen, maxWatched);
        },
      ),
      tag: widget.videoUrl,
    );
  }
  @override
  void dispose() {
    // 🔴 Important: Stop and dispose video
    // controller.();
    // Get.delete<CustomVideoPlayerController>(tag: widget.videoUrl);
    AppLogs.log("CALL DISPOSE VIDEO PLAYER : ${controller.isPlaying.value}");
    if(controller.isPlaying.value) {
      controller.togglePlayPause();
      if(widget.onPlayPauseChange != null) widget.onPlayPauseChange!(controller.isPlaying.value);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLogs.log("Call By Screen CustomVideoPlayer url: ${widget.videoUrl} : initialSeconds=${widget.initialSeconds}, maxWatchedSeconds=${widget.maxWatchedSeconds} [ anyMessage ] : [ ${widget.anyMessage} ]");
    // final controller = Get.put(CustomVideoPlayerController(
    //   videoUrl: videoUrl,
    //   seekVideoEnabled: seekVideoEnabled,
    //   initialSeconds: initialSeconds,
    //   maxWatchedSeconds: maxWatchedSeconds,
    //   onChange: (current, total, isFullScreen, maxWatched) {
    //     onChange?.call(current, total, isFullScreen, maxWatched);
    //   },
    // ));
    // final controller = Get.put(
    //   CustomVideoPlayerController(
    //     videoUrl: widget.videoUrl,
    //     seekVideoEnabled: widget.seekVideoEnabled,
    //     initialSeconds: widget.initialSeconds,
    //     maxWatchedSeconds: widget.maxWatchedSeconds,
    //     onChange: (current, total, isFullScreen, maxWatched) {
    //       widget.onChange?.call(current, total, isFullScreen, maxWatched);
    //     },
    //   ),
    //   tag: widget.videoUrl, // 👈 unique tag for each instance
    // );


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          if (controller.hasError.value) {
            return _buildErrorWidget(controller);
          }

          if (controller.isLoading.value) {
            return _buildLoadingWidget();
          }

          return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildVideoPlayer(controller)
          );
        }),
      ),
    );
  }

  Widget _buildErrorWidget(CustomVideoPlayerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          SizedBox(height: 10),
          Text(
            'Video Error',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              maxLines: 2,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: controller.retry,
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty) {
      // 👇 Thumbnail available => show image + loader
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
                enableCaching: true,
              )
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.black26, // overlay
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ],
      );
    } else {
      // 👇 Thumbnail not available => show blur bg + loader
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildVideoPlayer(CustomVideoPlayerController controller) {
    return Center(
      child: GestureDetector(
        onTap: controller.toggleControls,
        child: AspectRatio(
          aspectRatio: controller._controller.value.aspectRatio,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            child: Stack(alignment: Alignment.center,
              children: [
                // Video Player
                Center(
                  child: ClipRRect(borderRadius: BorderRadius.circular(widget.radius),
                    child: AspectRatio(
                      aspectRatio: controller._controller.value.aspectRatio,
                      child: vp.VideoPlayer(controller._controller),
                    ),
                  ),
                ),

                // Controls Overlay
                Obx(() => AnimatedOpacity(
                  opacity: controller.isShowControls.value ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: controller.isShowControls.value
                      ? _buildControlsOverlay(controller)
                      : SizedBox.shrink(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(CustomVideoPlayerController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
            // Colors.black54,
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Top Controls
          SizedBox(height: widget.spaceUperCenterControlls),

          // Center Controls
          Expanded(
            child: _buildCenterControls(controller),
          ),

          // Bottom Controls
          _buildBottomControls(controller),
        ],
      ),
    );
  }

  Widget _buildCenterControls(CustomVideoPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        if(widget.showNextButton)
        _buildControlButton(
          icon: Icons.skip_previous,
          onTap: widget.onPrevious ?? () {},
        ),

        // Play/Pause
        Obx(() => _buildControlButton(
          icon: controller.isPlaying.value ? Icons.pause : Icons.play_arrow_rounded,
          onTap: () {
            controller.togglePlayPause();
            if(widget.onPlayPauseChange != null) widget.onPlayPauseChange!(controller.isPlaying.value);
          },
          size: 64,
        )),

        if(widget.showNextButton)
        _buildControlButton(
          icon: Icons.skip_next,
          onTap: widget.onNext ?? () {},
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size - 24,
        ),
      ),
    );
  }

  Widget _buildBottomControls(CustomVideoPlayerController controller) {
    return Container(
      padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
      child: Column(
        children: [

          if(widget.showFullScreenButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              GestureDetector(
                onTap: controller.toggleFullscreen,
                child: Container(
                  child: Obx(() => Icon(
                    controller.isFullscreen.value
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 25,
                  )),
                ),
              ),
            ],
          ),
          // Progress Bar with restricted seeking
          Obx(() {
            final totalSeconds = controller._controller.value.duration.inSeconds.toDouble();
            final maxWatchedRatio = totalSeconds > 0 ? controller.maxWatchedSeconds.value / totalSeconds : 0.0;
            final hasWatchedFull = controller.maxWatchedSeconds.value >= totalSeconds;

            return SliderTheme(
              data: SliderTheme.of(Get.context!).copyWith(
                // padding: EdgeInsets.only(top: 8,bottom: 3),
                activeTrackColor: AppColor.yellow,
                inactiveTrackColor: Colors.white24,
                thumbColor: AppColor.yellow,
                overlayColor: AppColor.yellow.withOpacity(0.2),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Stack(
                children: [
                  // Main progress slider
                  Slider(
                    value: controller.progress.value.clamp(0.0, 1.0),
                    onChanged: (value) {
                      controller.seekTo(value);
                    },
                    onChangeStart: (value) {
                      if (widget.seekVideoEnabled) {
                        controller._hideControlsTimer?.cancel();
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.seekVideoEnabled) {
                        controller._resetHideControlsTimer();
                      }
                    },
                  ),
                  // Visual indicator for max watched position (if not watched full video)
                  // if (!hasWatchedFull && maxWatchedRatio > 0)
                  //   Positioned(
                  //     left: MediaQuery.of(Get.context!).size.width * maxWatchedRatio - 100,
                  //     top: 0,
                  //     child: Container(
                  //       width: 2,
                  //       height: 20,
                  //       color: Colors.orange.withOpacity(0.8),
                  //     ),
                  //   ),
                ],
              ),
            );
          }),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                controller.currentTime.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )),

              Obx(() => Text(
                controller.totalTime.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:async';
// import 'package:fat_end_fit/utils/app_color.dart';
// import 'package:fat_end_fit/utils/app_print.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart' as vp;
//
// import 'app_image.dart';
//
// class CustomVideoPlayerController extends GetxController {
//   late vp.VideoPlayerController _controller;
//   RxBool isPlaying = false.obs;
//   RxBool isShowControls = true.obs;
//   RxBool isLoading = true.obs;
//   RxBool hasError = false.obs;
//   RxString errorMessage = ''.obs;
//   RxDouble progress = 0.0.obs;
//   RxString currentTime = '00:00'.obs;
//   RxString totalTime = '00:00'.obs;
//   RxBool isFullscreen = false.obs;
//
//   Timer? _hideControlsTimer;
//   Timer? _progressTimer;
//   Function(Duration current, Duration total, bool isFullScreen)? onChange;
//   String videoUrl;
//   bool seekVideoEnabled;
//   CustomVideoPlayerController({this.onChange,this.videoUrl = '',this.seekVideoEnabled = true});
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializePlayer();
//   }
//
//   void initializePlayer() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;
//
//       _controller = vp.VideoPlayerController.networkUrl(
//        Uri.parse(videoUrl),
//         videoPlayerOptions: vp.VideoPlayerOptions(
//           mixWithOthers: true,
//           allowBackgroundPlayback: false,
//         ),
//       );
//
//       await _controller.initialize();
//
//       // Set up listeners
//       _controller.addListener(_videoListener);
//
//       isLoading.value = false;
//       totalTime.value = _formatDuration(_controller.value.duration);
//
//       _startProgressTimer();
//       _startHideControlsTimer();
//
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = 'Failed to load video: ${e.toString()}';
//       isLoading.value = false;
//     }
//   }
//
//   void _videoListener() {
//     if (_controller.value.hasError) {
//       hasError.value = true;
//       errorMessage.value = _controller.value.errorDescription ?? 'Unknown error';
//       return;
//     }
//
//     isPlaying.value = _controller.value.isPlaying;
//
//     if (_controller.value.duration.inMilliseconds > 0) {
//       progress.value = _controller.value.position.inMilliseconds /
//           _controller.value.duration.inMilliseconds;
//       currentTime.value = _formatDuration(_controller.value.position);
//
//       // 🔥 Fire callback
//       onChange?.call(
//         _controller.value.position,
//         _controller.value.duration,
//         isFullscreen.value,
//       );
//     }
//   }
//
//   void _startProgressTimer() {
//     _progressTimer?.cancel();
//     _progressTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
//       if (_controller.value.isInitialized && _controller.value.isPlaying) {
//         if (_controller.value.duration.inMilliseconds > 0) {
//           progress.value = _controller.value.position.inMilliseconds /
//               _controller.value.duration.inMilliseconds;
//           currentTime.value = _formatDuration(_controller.value.position);
//         }
//       }
//       if (_controller.value.isInitialized) {
//         onChange?.call(
//           _controller.value.position,
//           _controller.value.duration,
//           isFullscreen.value,
//         );
//       }
//     });
//   }
//
//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(Duration(seconds: 5), () {
//       if (isShowControls.value) {
//         hideControls();
//       }
//     });
//   }
//
//   void _resetHideControlsTimer() {
//     if (isShowControls.value) {
//       _startHideControlsTimer();
//     }
//   }
//
//   void togglePlayPause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//     _resetHideControlsTimer();
//   }
//
//   void toggleControls() {
//     if (isShowControls.value) {
//       hideControls();
//     } else {
//       isShowControls.value = true;
//       _startHideControlsTimer();
//     }
//   }
//
//   void showControls() {
//     isShowControls.value = true;
//     _startHideControlsTimer();
//   }
//
//   void hideControls() {
//     isShowControls.value = false;
//     _hideControlsTimer?.cancel();
//   }
//
//   void seekTo(double value) {
//     if(seekVideoEnabled == false) {
//       return;
//     }
//     final duration = _controller.value.duration;
//     final position = duration * value;
//     _controller.seekTo(position);
//     _resetHideControlsTimer();
//   }
//
//   void seekForward() {
//     if(seekVideoEnabled == false) {
//       return;
//     }
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition + Duration(seconds: 10);
//     final maxPosition = _controller.value.duration;
//
//     if (newPosition < maxPosition) {
//       _controller.seekTo(newPosition);
//     } else {
//       _controller.seekTo(maxPosition);
//     }
//     _resetHideControlsTimer();
//   }
//
//   void seekBackward() {
//     if(seekVideoEnabled == false) {
//       return;
//     }
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition - Duration(seconds: 10);
//
//     if (newPosition > Duration.zero) {
//       _controller.seekTo(newPosition);
//     } else {
//       _controller.seekTo(Duration.zero);
//     }
//     _resetHideControlsTimer();
//   }
//
//   changeNext() {
//     // Implement logic to change to the next video
//     // This could be a list of videos or a stream
//     // For now, just print a message
//     print('Change to next video');
//   }
//
//   changePrevious() {
//     // Implement logic to change to the previous video
//     // This could be a list of videos or a stream
//     // For now, just print a message
//     print('Change to previous video');
//   }
//
//   void toggleFullscreen() {
//     isFullscreen.value = !isFullscreen.value;
//
//     if (isFullscreen.value) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//     }
//
//     _resetHideControlsTimer();
//   }
//
//   void retry() {
//     hasError.value = false;
//     errorMessage.value = '';
//     initializePlayer();
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//
//     if (duration.inHours > 0) {
//       return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//     } else {
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
//
//   @override
//   void onClose() {
//     _hideControlsTimer?.cancel();
//     _progressTimer?.cancel();
//     _controller.removeListener(_videoListener);
//     _controller.dispose();
//     super.onClose();
//   }
// }
//
// class CustomVideoPlayer extends StatelessWidget {
//   final String videoUrl;
//   final String? thumbnailUrl;
//   final double height;
//   final bool seekVideoEnabled;
//   final Function()? onNext;
//   final Function()? onPrevious;
//   final Function(Duration current, Duration total, bool isFullScreen)? onChange;
//
//   const CustomVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     this.height = 250,
//     this.onChange,
//     this.thumbnailUrl,
//     this.onNext,
//     this.onPrevious,
//     this.seekVideoEnabled = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     AppLogs.log("CustomVideoPlayer url: $videoUrl");
//     final controller = Get.put(CustomVideoPlayerController(videoUrl: videoUrl,seekVideoEnabled: seekVideoEnabled,onChange: (current, total, isFullScreen) {
//       onChange!(current, total, isFullScreen);
//     },));
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.hasError.value) {
//             return _buildErrorWidget(controller);
//           }
//
//           if (controller.isLoading.value) {
//             return _buildLoadingWidget();
//           }
//
//           return ClipRRect(borderRadius: BorderRadius.circular(12),child: _buildVideoPlayer(controller));
//         }),
//       ),
//     );
//   }
//
//   Widget _buildErrorWidget(CustomVideoPlayerController controller) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             color: Colors.red,
//             size: 50,
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Video Error',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               controller.errorMessage.value,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 12,
//               ),
//               maxLines: 2,
//             ),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton.icon(
//             onPressed: controller.retry,
//             icon: Icon(Icons.refresh),
//             label: Text('Retry'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingWidget() {
//     if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
//       // 👇 Thumbnail available => show image + loader
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//       ClipRRect(borderRadius: BorderRadius.circular(12),
//           child: AppImage.network(
//             thumbnailUrl!,
//             fit: BoxFit.cover,enableCaching: true,
//           )),
//           ClipRRect(borderRadius: BorderRadius.circular(12),
//             child: Container(
//               color: Colors.black26, // overlay
//             ),
//           ),
//           Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 3,
//             ),
//           ),
//         ],
//       );
//     } else {
//       // 👇 Thumbnail not available => show blur bg + loader
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               gradient: LinearGradient(
//                 colors: [Colors.black87, Colors.black54],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 3,
//             ),
//           ),
//         ],
//       );
//     }
//   }
//
//
//   Widget _buildVideoPlayer(CustomVideoPlayerController controller) {
//     return GestureDetector(
//       onTap: controller.toggleControls,
//       child: Container(
//         color: Colors.transparent,
//         width: double.infinity,
//         height: double.infinity,
//         child: Stack(
//           children: [
//             // Video Player
//             Center(
//               child: AspectRatio(
//                 aspectRatio: controller._controller.value.aspectRatio,
//                 child: vp.VideoPlayer(controller._controller),
//               ),
//             ),
//
//             // Controls Overlay
//             Obx(() => AnimatedOpacity(
//               opacity: controller.isShowControls.value ? 1.0 : 0.0,
//               duration: Duration(milliseconds: 300),
//               child: controller.isShowControls.value
//                   ? _buildControlsOverlay(controller)
//                   : SizedBox.shrink(),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildControlsOverlay(CustomVideoPlayerController controller) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.black54,
//             Colors.transparent,
//             Colors.transparent,
//             Colors.black54,
//           ],
//           stops: [0.0, 0.3, 0.7, 1.0],
//         ),
//       ),
//       child: Column(
//         children: [
//           // Top Controls
//           // _buildTopControls(controller),
//           SizedBox(height: 70,),
//
//           // Center Controls
//           Expanded(
//             child: _buildCenterControls(controller),
//           ),
//
//           // Bottom Controls
//           _buildBottomControls(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCenterControls(CustomVideoPlayerController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // Seek Backward
//         // _buildControlButton(
//         //   icon: Icons.replay_10,
//         //   onTap: controller.seekBackward,
//         // ),
//         _buildControlButton(
//           icon: Icons.skip_previous,
//           onTap: onPrevious ?? (){
//
//           },
//         ),
//
//         // Play/Pause
//         Obx(() => _buildControlButton(
//           icon: controller.isPlaying.value ? Icons.pause : Icons.play_arrow_rounded,
//           onTap: controller.togglePlayPause,
//           size: 64,
//         )),
//
//         _buildControlButton(
//           icon: Icons.skip_next,
//           onTap: onNext ?? (){
//
//           },
//         ),
//
//         // Seek Forward
//         // _buildControlButton(
//         //   icon: Icons.forward_10,
//         //   onTap: controller.seekForward,
//         // ),
//       ],
//     );
//   }
//
//   Widget _buildControlButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     double size = 56,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           // color: Colors.black54,
//           borderRadius: BorderRadius.circular(size / 2),
//         ),
//         child: Icon(
//           icon,
//           color: Colors.white,
//           size: size - 24,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomControls(CustomVideoPlayerController controller) {
//     return Container(
//       padding: EdgeInsets.only(right: 16,left: 16,top: 16,bottom: 10),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//             SizedBox(),
//             GestureDetector(
//               onTap: controller.toggleFullscreen,
//               child: Container(
//                 // padding: EdgeInsets.all(3),
//                 child: Obx(() => Icon(
//                   controller.isFullscreen.value
//                       ? Icons.fullscreen_exit
//                       : Icons.fullscreen,
//                   color: Colors.white,
//                   size: 25,
//                 )),
//               ),
//             ),
//           ],),
//           // Progress Bar
//           Obx(() => SliderTheme(
//             data: SliderTheme.of(Get.context!).copyWith(
//               activeTrackColor: AppColor.yellow,
//               inactiveTrackColor: Colors.white24,
//               thumbColor: AppColor.yellow,
//               // padding: EdgeInsets.zero,
//               overlayColor: AppColor.yellow.withOpacity(0.2),
//               thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
//               overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
//             ),
//             child: Slider(
//               // padding: EdgeInsets.zero,
//               value: controller.progress.value.clamp(0.0, 1.0),
//               onChanged: (value) {
//                 controller.seekTo(value);
//               },
//               onChangeStart: (value) {
//                 if(seekVideoEnabled) {
//                   controller._hideControlsTimer?.cancel();
//                 }
//               },
//               onChangeEnd: (value) {
//                 if(seekVideoEnabled) {
//                   controller._resetHideControlsTimer();
//                 }
//               },
//             ),
//           )),
//
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Obx(() => Text(
//                 controller.currentTime.value,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,fontWeight: FontWeight.bold
//                 ),
//               )),
//
//               Obx(() => Text(
//                 controller.totalTime.value,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,fontWeight: FontWeight.bold
//                 ),
//               )),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
