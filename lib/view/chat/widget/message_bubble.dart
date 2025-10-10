// chat_widgets.dart
import 'dart:io';

import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/chat/widget/full_screen_image.dart';
import 'package:fat_end_fit/view/chat/widget/pick_media_bottom_sheet.dart';
import 'package:fat_end_fit/view/program_video/model/program_video_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/common/app_video_thumbnail.dart';
import '../../live_section/webinar_video/webinar_video_screen.dart';
import '../chat_customer_support_controller.dart';
import '../model/chat_message_model.dart';

// class MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final bool isFirstOfGroup;
//
//   const MessageBubble({
//     super.key,
//     required this.message,
//     required this.isFirstOfGroup,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final left = !message.isMe;
//     final bg = left ? AppColor.yellow : AppColor.black;
//     final fg = left ? AppColor.black : AppColor.white;
//
//     final radius = Radius.circular(18);
//     return Align(
//       alignment: left ? Alignment.centerLeft : Alignment.centerRight,
//       child: Container(
//         margin: EdgeInsets.only(
//           top: isFirstOfGroup ? 10 : 6,
//           left: left ? 12 : 60,
//           right: left ? 60 : 12,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.only(
//             topLeft: radius,
//             topRight: radius,
//             bottomLeft: left ? Radius.zero : radius,
//             bottomRight: left ? radius : Radius.zero,
//           ),
//         ),
//         child: message.type == MessageType.text
//             ? Text(
//           message.text ?? '',
//           style: TextStyle(color: fg, fontSize: 14, height: 1.3),
//         )
//             : _VoiceBubble(message: message, fg: fg, bg: bg),
//       ),
//     );
//   }
// }
import 'package:open_filex/open_filex.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFirstOfGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isFirstOfGroup,
  });

  @override
  Widget build(BuildContext context) {
    final left = !message.isMe;
    final bg = left ? AppColor.yellow : AppColor.white;
    final fg = left ? AppColor.black : AppColor.blackColor;

    final radius = Radius.circular(18);
    return Align(
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          top: isFirstOfGroup ? 10 : 6,
          left: left ? 12 : 60,
          right: left ? 60 : 12,
        ),
        padding: EdgeInsets.symmetric(horizontal: MessageType.image == message.type || MessageType.video == message.type?5:14, vertical: MessageType.image == message.type?5:10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
            bottomLeft: left ? Radius.zero : radius,
            bottomRight: left ? radius : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,spreadRadius: 3,
              offset: Offset(2, 3),
            ),
          ]
        ),
        child: _buildMessageContent(fg, bg),
      ),
    );
  }

  Widget _buildMessageContent(Color fg, Color bg) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.text ?? '',
          style: TextStyle(color: fg, fontSize: 14, height: 1.3),
        );

      case MessageType.voice:
        return _VoiceBubble(message: message, fg: fg, bg: bg);

      case MessageType.image:
        return GestureDetector(
          onTap: () async {
            AppLogs.log("message.mediaUrl = ${message.mediaUrl}");
            /*if (message.mediaPath != null) {
              await OpenFilex.open(message.mediaPath!);
            } else */if (message.mediaUrl != null) {
              Get.to(()=>FullScreenImageView(imageUrl: getImageUrl(message.mediaUrl)));
              // For network image you can show full-screen preview instead
              // but OpenFilex only works for local paths
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage.network(
              getImageUrl(message.mediaUrl) ?? '',
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              errorWidget:  Icon(Icons.broken_image, color: fg),
            ),
          ),
        );
      case MessageType.video:
        return FutureBuilder<String?>(
          future: getVideoThumbnailPath(
            message.mediaUrl ?? "",
            isPickedFile: message.mediaPath != null,
          ),
          builder: (context, snapshot) {
            final imagePath = snapshot.data;

            return GestureDetector(
              onTap: () async {
               /* if (message.mediaPath != null) {
                  await OpenFilex.open(message.mediaPath!);
                } else */if (message.mediaUrl != null) {
                  Get.to(() =>WebinarVideoScreen(isUpdateProgress: false,data: ProgramVideoModel(id: message.mediaUrl ?? '', title: "", video: getImageUrl(message.mediaUrl), description: "", thumbnail: "", day: 0, type: 0, videoSec: 0, videoSize: 0, userVideoProgress: UserVideoProgress(watchedSeconds: 0, lastWatchedAt: 0, isCompleted: false),answerStats: AnswerStats(correctAnswers: 0, wrongAnswers: 0, totalAnswers: 0), userAnswerData: [], userAnswer: false),),);
                  // TODO: Play remote video via video_player or download
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imagePath != null
                        ? Image.file(
                      File(imagePath),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 160,
                      height: 160,
                      color: Colors.black12,
                      child: const Icon(Icons.videocam_off),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 36),
                  ),
                ],
              ),
            );
          },
        );

      // case MessageType.video:
      //   String? image =  getVideoThumbnailPath(getImageUrl("path"));
      //   return GestureDetector(
      //     onTap: () async {
      //       if (message.mediaPath != null) {
      //         await OpenFilex.open(message.mediaPath!);
      //       } else if (message.mediaUrl != null) {
      //         // Same as above – if remote, either download first or use video_player package
      //       }
      //     },
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         ClipRRect(
      //           borderRadius: BorderRadius.circular(12),
      //           child: Image.file(
      //             // you may want to store & show thumbnail separately
      //             File(image ?? ''),
      //             width: 160,
      //             height: 160,
      //             fit: BoxFit.cover,
      //             errorBuilder: (_, __, ___) => Container(
      //               width: 160,
      //               height: 160,
      //               color: Colors.black12,
      //               child: Icon(Icons.videocam_off, color: fg),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           decoration: BoxDecoration(
      //             color: Colors.black45,
      //             shape: BoxShape.circle,
      //           ),
      //           padding: EdgeInsets.all(8),
      //           child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
      //         ),
      //       ],
      //     ),
      //   );
    }
  }
}

String formatDateHeader(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final msgDate = DateTime(date.year, date.month, date.day);

  if (msgDate == today) return "Today";
  if (msgDate == yesterday) return "Yesterday";
  return DateFormat('dd MMM yyyy').format(date);
}

// class _VoiceBubble extends StatelessWidget {
//   final ChatMessage message;
//   final Color fg;
//   final Color bg;
//   const _VoiceBubble({required this.message, required this.fg, required this.bg});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ChatController>();
//     return GestureDetector(
//       onTap: () => c.togglePlay(message),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Obx(() => Icon(
//             c.playingId.value == message.id ? Icons.pause : Icons.play_arrow,
//             color: fg,
//             size: 22,
//           )),
//           const SizedBox(width: 8),
//           // Animated waveform
//           Expanded(
//             child: SizedBox(
//               width: 180,
//               height: 22,
//               child: Obx(() => WaveformWidget(
//                 isPlaying: c.playingId.value == message.id,
//                 progress: c.playingId.value == message.id
//                     ? c.playingProgress.value.clamp(0.0, 1.0)
//                     : 0.0,
//                 color: fg,
//               )),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             _fmt(message.duration ?? Duration.zero),
//             style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _fmt(Duration d) {
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
// }

class _VoiceBubble extends StatelessWidget {
  final ChatMessage message;
  final Color fg;
  final Color bg;
  const _VoiceBubble({required this.message, required this.fg, required this.bg});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatController>();

    if (message.uploadProgress < 1.0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.upload, size: 20, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              "${(message.uploadProgress * 100).toStringAsFixed(0)}%",
              style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: message.uploadProgress,
                color: Colors.orange,
                backgroundColor: Colors.grey[300],
                minHeight: 4,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ After upload completed, show play button with waveform
    return GestureDetector(
      onTap: () => c.togglePlay(message),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Icon(
            c.playingId.value == message.id ? Icons.pause : Icons.play_arrow,
            color: fg,
            size: 22,
          )),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              width: 180,
              height: 22,
              child: Obx(() => WaveformWidget(
                isPlaying: c.playingId.value == message.id,
                progress: c.playingId.value == message.id
                    ? c.playingProgress.value.clamp(0.0, 1.0)
                    : 0.0,
                color: fg,
              )),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _fmt(message.duration ?? Duration.zero),
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  const ChatInputBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        decoration:  BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, -2))],
        ),
        child: Row(
          children: [
            // Text box
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                // decoration: BoxDecoration(
                //   color: const Color(0xFFF6F6F6),
                //   borderRadius: BorderRadius.circular(24),
                // ),
                child: TextField(
                  onTap: () {
                    // keyboard open thay tyare auto scroll
                    // Future.delayed(const Duration(milliseconds: 300), () {
                    //   c.scrollController.jumpTo(
                    //     c.scrollController.position.maxScrollExtent,
                    //   );
                    // });
                  },
                  cursorColor: Colors.white,

                  controller: controller,
                  onChanged: (v) => c.text.value = v,
                  decoration:  InputDecoration(
                    hintText: AppString.typeSomething,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)), ),
                  minLines: 1,
                  maxLines: 4,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),

            Obx(() {
              final hasText = c.text.value.trim().isNotEmpty;

              return hasText ?SizedBox.shrink():Row(
                children: [
                  _roundBtn(icon: Icons.attach_file,iconColor: Colors.black, onTap: () {
                    showMediaPickerSheet();
                  }),
                  const SizedBox(width: 8),
                ],
              );
            },),


            // Send / Mic
            Obx(() {
              final hasText = c.text.value.trim().isNotEmpty;
              if (hasText) {
                return _roundBtn(
                  icon: Icons.send,
                  onTap: () {
                    c.sendText();
                    controller.clear();
                  },
                  iconColor: AppColor.blackColor,
                  bg: AppColor.yellow,
                );
              }

              // Mic with long press
              return GestureDetector(
                onLongPress: () => c.startRecording(),
                onLongPressEnd: (d) => c.stopRecordingAndSend(),
                onTap: () {
                  AppLogs.log(" IS RECORDING START OR END ? ${c.isRecording.value}");
                  if(c.isRecording.value){
                    c.stopRecordingAndSend();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // pulse while recording
                    Obx(() => AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: c.isRecording.value ? 1.15 : 1.0,
                      child: _roundBtn(
                        icon: !c.isRecording.value?Icons.mic:Icons.record_voice_over,
                        onTap: () {
                          AppLogs.log(" IS RECORDING START OR END ? ${c.isRecording.value}");
                          if(c.isRecording.value){
                            c.stopRecordingAndSend();
                          }
                        },
                        bg: AppColor.yellow,
                        iconColor: AppColor.blackColor,
                      ),
                    )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color bg = AppColor.yellow,
    Color iconColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
// class ChatInputBar extends StatelessWidget {
//   final TextEditingController controller;
//   const ChatInputBar({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ChatController>();
//
//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, -2))],
//         ),
//         child: Row(
//           children: [
//             // Text box
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF6F6F6),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: TextField(
//                   onTap: () {
//                     // keyboard open thay tyare auto scroll
//                     // Future.delayed(const Duration(milliseconds: 300), () {
//                     //   c.scrollController.jumpTo(
//                     //     c.scrollController.position.maxScrollExtent,
//                     //   );
//                     // });
//                   },
//                   controller: controller,
//                   onChanged: (v) => c.text.value = v,
//                   decoration:  InputDecoration(
//                     hintText: AppString.typeSomething,
//                     border: InputBorder.none,
//                   ),
//                   minLines: 1,
//                   maxLines: 4,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Get.bottomSheet(
//             //   Container(
//             //     decoration: BoxDecoration(
//             //       color: Colors.white,
//             //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             //     ),
//             //     padding: EdgeInsets.all(16),
//             //     child: Wrap(
//             //       children: [
//             //         ListTile(
//             //           leading: Icon(Icons.image, color: AppColor.yellow),
//             //           title: Text("Pick Image (Max 5 MB)"),
//             //           onTap: () async {
//             //             // TODO: image picker logic
//             //             XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
//             //             // check file size < 5 MB
//             //             Get.back();
//             //           },
//             //         ),
//             //         ListTile(
//             //           leading: Icon(Icons.video_library, color: AppColor.yellow),
//             //           title: Text("Pick Video (Max 30 MB)"),
//             //           onTap: () async {
//             //             // TODO: video picker logic
//             //             XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
//             //             // check file size < 30 MB
//             //             Get.back();
//             //           },
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // );
//            Obx(() {
//              final hasText = c.text.value.trim().isNotEmpty;
//
//              return hasText ?SizedBox.shrink():Row(
//                children: [
//                  _roundBtn(icon: Icons.attach_file,iconColor: Colors.black, onTap: () {
//                    showMediaPickerSheet();
//                  }),
//                  const SizedBox(width: 8),
//                ],
//              );
//            },),
//
//
//             // Send / Mic
//             Obx(() {
//               final hasText = c.text.value.trim().isNotEmpty;
//               if (hasText) {
//                 return _roundBtn(
//                   icon: Icons.send,
//                   onTap: () {
//                     c.sendText();
//                     controller.clear();
//                   },
//                   bg: AppColor.black,
//                 );
//               }
//
//               // Mic with long press
//               return GestureDetector(
//                 onLongPress: () => c.startRecording(),
//                 onLongPressEnd: (d) => c.stopRecordingAndSend(),
//                 onTap: () {
//                   AppLogs.log(" IS RECORDING START OR END ? ${c.isRecording.value}");
//                   if(c.isRecording.value){
//                     c.stopRecordingAndSend();
//                   }
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // pulse while recording
//                     Obx(() => AnimatedScale(
//                       duration: const Duration(milliseconds: 250),
//                       scale: c.isRecording.value ? 1.15 : 1.0,
//                       child: _roundBtn(
//                         icon: !c.isRecording.value?Icons.mic:Icons.record_voice_over,
//                         onTap: () {
//                           AppLogs.log(" IS RECORDING START OR END ? ${c.isRecording.value}");
//                           if(c.isRecording.value){
//                             c.stopRecordingAndSend();
//                           }
//                         },
//                         bg: AppColor.yellow,
//                         iconColor: AppColor.black,
//                       ),
//                     )),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _roundBtn({
//     required IconData icon,
//     required VoidCallback onTap,
//     Color bg = AppColor.yellow,
//     Color iconColor = Colors.white,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(22),
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//         child: Icon(icon, color: iconColor),
//       ),
//     );
//   }
// }


class WaveformWidget extends StatefulWidget {
  final bool isPlaying;
  final double progress;
  final Color color;

  const WaveformWidget({
    Key? key,
    required this.isPlaying,
    required this.progress,
    required this.color,
  }) : super(key: key);

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _barAnimationControllers;
  late List<Animation<double>> _barAnimations;

  // Sample waveform data (heights from 0.2 to 1.0)
  final List<double> _waveformData = [
    0.4, 0.7, 0.3, 0.9, 0.2, 0.8, 0.5, 0.6, 0.9, 0.3,
    0.7, 0.4, 0.8, 0.2, 0.6, 0.9, 0.3, 0.7, 0.5, 0.8,
    0.4, 0.6, 0.3, 0.9, 0.2, 0.7, 0.5, 0.8, 0.4, 0.6,
    0.3, 0.9, 0.2, 0.7, 0.5, 0.8, 0.4, 0.6, 0.3, 0.7,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create individual animation controllers for each bar
    _barAnimationControllers = List.generate(
      _waveformData.length,
          (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index % 3) * 200),
        vsync: this,
      ),
    );

    // Create staggered animations for each bar
    _barAnimations = _barAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    if (widget.isPlaying) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startAnimations();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _animationController.repeat();

    // Start each bar animation with a slight delay
    for (int i = 0; i < _barAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 20), () {
        if (mounted && widget.isPlaying) {
          _barAnimationControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimations() {
    _animationController.stop();
    for (var controller in _barAnimationControllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _barAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveformPainter(
            waveformData: _waveformData,
            progress: widget.progress,
            color: widget.color,
            isPlaying: widget.isPlaying,
            barAnimations: _barAnimations,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color color;
  final bool isPlaying;
  final List<Animation<double>> barAnimations;

  WaveformPainter({
    required this.waveformData,
    required this.progress,
    required this.color,
    required this.isPlaying,
    required this.barAnimations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 2.0;
    final barSpacing = 1.0;
    final totalBars = ((size.width + barSpacing) / (barWidth + barSpacing)).floor();

    final lightPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    final darkPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalBars && i < waveformData.length; i++) {
      final x = i * (barWidth + barSpacing) + barWidth / 2;
      final normalizedProgress = progress * totalBars;

      // Base height from waveform data
      double baseHeight = waveformData[i % waveformData.length];

      // Apply animation if playing
      double animatedHeight = baseHeight;
      if (isPlaying && i < barAnimations.length) {
        animatedHeight = baseHeight * barAnimations[i].value;
      }

      final barHeight = animatedHeight * size.height * 0.8;
      final centerY = size.height / 2;

      final startY = centerY - barHeight / 2;
      final endY = centerY + barHeight / 2;

      // Choose paint based on progress
      final paint = i < normalizedProgress ? darkPaint : lightPaint;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.color != color;
  }
}


// class _VoiceBubble extends StatelessWidget {
//   final ChatMessage message;
//   final Color fg;
//   final Color bg;
//   const _VoiceBubble({required this.message, required this.fg, required this.bg});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ChatController>();
//     return GestureDetector(
//       onTap: () => c.togglePlay(message),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Obx(() => Icon(
//             c.playingId.value == message.id ? Icons.pause : Icons.play_arrow,
//             color: fg,
//             size: 22,
//           )),
//           const SizedBox(width: 8),
//           // fake waveform bar (simple)
//           Expanded(
//             child: SizedBox(
//               width: 140,
//               height: 22,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   children: [
//                     Container(color: fg.withOpacity(0.15)),
//                     Obx(() => FractionallySizedBox(
//                       widthFactor: c.playingId.value == message.id
//                           ? (c.playingProgress.value.clamp(0.0, 1.0))
//                           : 0.0,
//                       alignment: Alignment.centerLeft,
//                       child: Container(color: fg.withOpacity(0.35)),
//                     )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 8),
//           Text(
//             _fmt(message.duration ?? Duration.zero),
//             style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _fmt(Duration d) {
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
// }