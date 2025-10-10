// chat_screen.dart
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:fat_end_fit/utils/common/app_common_back_button.dart';
import 'package:fat_end_fit/utils/common/app_text.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/chat/widget/message_bubble.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/app_color.dart';
import '../../utils/common/app_image.dart';
import 'chat_customer_support_controller.dart';
import 'model/chat_message_model.dart';

class CustomerSupportChatScreen extends StatelessWidget {
  CustomerSupportChatScreen({super.key});
  final _tc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChatController());
    ProfileController profile = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(color: Colors.white,
        child: Column(
          children: [
            // Top bar
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    backButton(),
                    const Spacer(),
                    Text(
                      AppString.customerSupport,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),

            // Header (avatar + name + day chip)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            //   child: Row(
            //     children: [
            //        CircleAvatar(
            //         radius: 25,
            //         child: AppImage.circularAvatar(
            //             radius: 25,
            //             getImageUrl(profile.user.value?.image) ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s"), // replace
            //       ),
            //       const SizedBox(width: 10),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //            Text(profile.user.value?.name ?? 'User'/*'Madison Smith'*/,
            //               style: TextStyle(fontWeight: FontWeight.w700)),
            //           Container(
            //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            //             decoration: BoxDecoration(
            //               color: AppColor.yellow,
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child:  Text('Day ${profile.user.value?.planCurrentDay.toString()}',
            //                 style: TextStyle(
            //                     fontSize: 12,
            //                     color: AppColor.black,
            //                     fontWeight: FontWeight.w700)),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 6),

            // Messages
            // Expanded(
            //   child: Obx(() {
            //     // final msgs = c.messages;
            //     List<ChatMessage>  msgs = c.messages.reversed.toList();
            //
            //     if(msgs.isEmpty){
            //       return Center(child: Text("No Messages."),);
            //     }
            //
            //     return ListView.builder(
            //       // controller: c.scrollController,
            //       padding: const EdgeInsets.only(bottom: 12),
            //       reverse: true,
            //       itemCount: msgs.length,
            //       itemBuilder: (_, i) {
            //         final m = msgs[i];
            //         final prev = i == 0 ? null : msgs[i - 1];
            //         final firstOfGroup = prev == null || prev.isMe != m.isMe;
            //         return Column(
            //           crossAxisAlignment:
            //           m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            //           children: [
            //             MessageBubble(message: m, isFirstOfGroup: firstOfGroup),
            //             Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 16),
            //               child: Text(
            //                 _prettyTime(m.createdAt),
            //                 style: const TextStyle(
            //                     color: Colors.black54, fontSize: 10),
            //               ),
            //             ),
            //             const SizedBox(height: 8),
            //           ],
            //         );
            //       },
            //     );
            //   }),
            // ),
            Expanded(
              child: Obx(() {
                List<ChatMessage> msgs = c.messages.reversed.toList();

                if (msgs.isEmpty) {
                  return const Center(child: Text("No Messages."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i];
                    final prev = i == msgs.length - 1 ? null : msgs[i + 1];
                    final showHeader = prev == null ||
                        DateFormat('yyyyMMdd').format(prev.createdAt) !=
                            DateFormat('yyyyMMdd').format(m.createdAt);
                    final firstOfGroup = prev == null || prev.isMe != m.isMe;
                    return Column(
                      children: [
                        if (showHeader) // 👇 date header in center
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  formatDateHeader(m.createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        Column(
                          crossAxisAlignment:
                          m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            MessageBubble(message: m, isFirstOfGroup: firstOfGroup,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                DateFormat('hh:mm a').format(m.createdAt),
                                style:
                                const TextStyle(color: Colors.black54, fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
            ),


            // Recording banner
            Obx(() => c.isRecording.value
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.yellow.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, color: AppColor.black),
                  const SizedBox(width: 8),
                  Expanded(child: AppText(AppString.recordingHoldToRecord,color: AppColor.black, fontWeight: FontWeight.w600,maxLines: 2,overflow: TextOverflow.ellipsis,)),
                  const SizedBox(width: 8),
                  Text(_pad(c.recordElapsed.value),
                      style: const TextStyle(
                          color: AppColor.black, fontWeight: FontWeight.bold)),
                ],
              ),
            )
                : const SizedBox.shrink()),

            // Input
            ChatInputBar(controller: _tc),
          ],
        ),
      ),
    );
  }

  String _pad(int s) {
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  String _prettyTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }
}

// class CustomerSupportChatScreen extends StatefulWidget {
//   const CustomerSupportChatScreen({super.key});
//
//   @override
//   State<CustomerSupportChatScreen> createState() =>
//       _CustomerSupportChatScreenState();
// }
//
// class _CustomerSupportChatScreenState extends State<CustomerSupportChatScreen> {
//   final _tc = TextEditingController();
//   late final ChatController c;
//
//   @override
//   void initState() {
//     super.initState();
//     // 👇 normally userId & careId you’ll get from backend
//     c = Get.put(ChatController(userId: '123', customerCareId: '2345'));
//
//     // Load cache instantly
//     c.loadCached();
//
//     // Start live listener
//     c.listenMessages();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // 🔹 Top bar
//           SafeArea(
//             bottom: false,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   backButton(),
//                   const Spacer(),
//                    Text(
//                     AppString.customerSupport,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//                   ),
//                   const Spacer(),
//                   const SizedBox(width: 40),
//                 ],
//               ),
//             ),
//           ),
//
//           // 🔹 Header (avatar + info)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(
//                       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s"),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Madison Smith',
//                         style: TextStyle(fontWeight: FontWeight.w700)),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColor.yellow,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Text('Day 01',
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: AppColor.black,
//                               fontWeight: FontWeight.w700)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 6),
//
//           // 🔹 Messages list
//           Expanded(
//             child: Obx(() {
//               final msgs = c.messages;
//               return ListView.builder(
//                 controller: c.scrollController,
//                 padding: const EdgeInsets.only(bottom: 12),
//                 reverse: false,
//                 itemCount: msgs.length,
//                 itemBuilder: (_, i) {
//                   final m = msgs[i];
//                   final prev = i == 0 ? null : msgs[i - 1];
//                   final firstOfGroup = prev == null || prev.isMe != m.isMe;
//                   return Column(
//                     crossAxisAlignment: m.isMe
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: [
//                       MessageBubble(message: m, isFirstOfGroup: firstOfGroup),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           _prettyTime(m.createdAt),
//                           style: const TextStyle(
//                               color: Colors.black54, fontSize: 10),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   );
//                 },
//               );
//             }),
//           ),
//
//           // 🔹 Recording banner
//           Obx(() => c.isRecording
//               ? Container(
//             margin:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColor.yellow.withOpacity(0.9),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.mic, color: AppColor.black),
//                 const SizedBox(width: 8),
//                 Expanded(
//                     child: AppText(
//                       AppString.recordingHoldToRecord,
//                       color: AppColor.black,
//                       fontWeight: FontWeight.w600,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     )),
//                 const SizedBox(width: 8),
//                 Text(_pad(c.recordElapsed.value),
//                     style: const TextStyle(
//                         color: AppColor.black,
//                         fontWeight: FontWeight.bold)),
//               ],
//             ),
//           )
//               : const SizedBox.shrink()),
//
//           // 🔹 Input bar
//           ChatInputBar(controller: _tc),
//         ],
//       ),
//     );
//   }
//
//   String _pad(int s) {
//     final mm = (s ~/ 60).toString().padLeft(2, '0');
//     final ss = (s % 60).toString().padLeft(2, '0');
//     return '$mm:$ss';
//   }
//
//   String _prettyTime(DateTime dt) {
//     final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
//     final m = dt.minute.toString().padLeft(2, '0');
//     final ap = dt.hour >= 12 ? 'PM' : 'AM';
//     return '$h:$m $ap';
//   }
// }

