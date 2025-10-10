import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_end_fit/service/api_config.dart';
import 'package:fat_end_fit/service/api_service.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:fat_end_fit/view/setting_user/setting_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../service/firebase_service.dart';
import '../../utils/app_storage.dart';
import '../../utils/common_function.dart';
import 'model/chat_message_model.dart';

//ui
// class ChatController extends GetxController {
//   final messages = <ChatMessage>[].obs;
//   final text = ''.obs;
//
//   // Recording
//   final _rec = AudioRecorder();
//   bool get isRecording => _isRecording.value;
//   final _isRecording = false.obs;
//   final recordElapsed = 0.obs; // seconds
//   Timer? _timer;
//   final scrollController = ScrollController();
//
//   // Playback (single player for simplicity)
//   final _player = AudioPlayer();
//   String? _currentlyPlayingId;
//   final playingId = ''.obs;   // message id that is playing
//   final playingProgress = 0.0.obs;
//
//   void sendText() {
//     final t = text.value.trim();
//     if (t.isEmpty) return;
//     final msg = ChatMessage.text(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       isMe: true,
//       text: t,
//       createdAt: DateTime.now(),
//     );
//     sendMessage(msg);
//     text.value = '';
//     // TODO: push to API/Firebase later
//   }
//
//   Future<void> startRecording() async {
//     if (isRecording) return;
//     if (!await _rec.hasPermission()) {
//       // Optionally show a toast
//       return;
//     }
//     final dir = await getTemporaryDirectory();
//     final path =
//         '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//     await _rec.start(RecordConfig(bitRate: 128000, sampleRate: 44100), path: path);
//       // path: path,
//       // encoder: AudioEncoder.aacLc,
//       // bitRate: 128000,
//       // samplingRate: 44100,
//     // );
//
//     _isRecording.value = true;
//     recordElapsed.value = 0;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       recordElapsed.value++;
//     });
//   }
//
//   Future<void> stopRecordingAndSend({bool cancel = false}) async {
//     if (!isRecording) return;
//     _timer?.cancel();
//     _isRecording.value = false;
//
//     final path = await _rec.stop(); // returns file path
//     if (cancel || path == null || !File(path).existsSync() || recordElapsed.value < 1) {
//       return;
//     }
//
//     final msg = ChatMessage.voice(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       isMe: true,
//       audioPath: path,
//       duration: Duration(seconds: recordElapsed.value),
//       createdAt: DateTime.now(),
//     );
//     sendMessage(msg);
//     // TODO: upload file / push meta to backend later
//   }
//
//
//   sendMessage(ChatMessage msg) {
//     // if (msg.type == MessageType.text && msg.text?.isEmpty) return;
//     // if (msg.type == MessageType.voice && msg.audioPath == null) return;
//
//     messages.add(msg);
//
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         final position = scrollController.position;
//         if (position.pixels != position.maxScrollExtent) {
//           scrollController.animateTo(
//             position.maxScrollExtent,
//             duration: const Duration(milliseconds: 100),
//             curve: Curves.easeOut,
//           );
//         }
//       }
//     });
//
//   }
//
//   Future<void> togglePlay(ChatMessage msg) async {
//     if (msg.type != MessageType.voice || msg.audioPath == null) return;
//
//     if (_currentlyPlayingId == msg.id) {
//       final state =  _player.state;
//       if (state == PlayerState.playing) {
//         await _player.pause();
//         playingId.value = '';
//         return;
//       } else {
//         await _player.resume();
//         playingId.value = msg.id;
//         return;
//       }
//     }
//
//     await _player.stop();
//     _currentlyPlayingId = msg.id;
//     playingId.value = msg.id;
//
//     await _player.play(DeviceFileSource(msg.audioPath!));
//
//     _player.onPositionChanged.listen((d) {
//       final total = msg.duration ?? Duration.zero;
//       if (total.inMilliseconds == 0) {
//         playingProgress.value = 0;
//       } else {
//         playingProgress.value = d.inMilliseconds / total.inMilliseconds;
//       }
//     });
//
//     _player.onPlayerComplete.listen((_) {
//       playingId.value = '';
//       playingProgress.value = 0;
//       _currentlyPlayingId = null;
//     });
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     _player.dispose();
//     super.onClose();
//   }
// }
class ChatController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final AppStorage _storage = AppStorage();

  // Chat data
  final messages = <ChatMessage>[].obs;
  final text = ''.obs;
  String? chatId;
  String? currentUserId;
  StreamSubscription? _messagesSubscription;

  // UI state
  final scrollController = ScrollController();
  final isLoading = false.obs;
  final isConnected = true.obs;

  // Recording
  final _recorder = AudioRecorder();
  final isRecording = false.obs;
  final recordElapsed = 0.obs;
  Timer? _recordTimer;

  // Audio playback
  final _player = AudioPlayer();
  String? _currentlyPlayingId;
  final playingId = ''.obs;
  final playingProgress = 0.0.obs;

  ProfileController profileController = Get.find();
  AppSettingController settingController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    isLoading.value = true;

    // Get user data from storage
    currentUserId = profileController.user.value?.id;

    if (currentUserId == null) {
      // Handle error - redirect to login/setup
      AppToast.error('User data not found');
      return;
    }

    // Load local messages first for instant UI
     chatId = '${currentUserId}_${profileController.user.value?.branch}';
    // AppLogs.log('CHAT ID: $chatId
    _loadLocalMessages();


    // Create/get chat from Firebase
    chatId = await _firebaseService.createOrGetChat(
      currentUserId!,
      profileController.user.value?.name ?? "Unknown",
    );


    if (chatId != null) {
      // Listen to real-time updates
      _listenToMessages();
    }

    isLoading.value = false;
  }

  void _loadLocalMessages() {
    AppLogs.log("START TO GET CHAT DAT FROM LOCAL $chatId LOADING...");
    if (chatId != null) {
      final localMessages = _storage.getChatMessages(chatId!);
      messages.assignAll(localMessages);
      AppLogs.log("LOCAL MESSAGES GETED SUCCESS DONE: $messages");
      _scrollToBottom();
    }
  }

  void _listenToMessages() {
    _messagesSubscription = _firebaseService
        .getMessagesStream(chatId!, currentUserId!)
        .listen(
          (newMessages) {
        // Update local messages
        messages.assignAll(newMessages);

        // Save to local storage
        _storage.saveChatMessages(chatId!, newMessages);

        // Auto scroll to bottom if near bottom
        _autoScrollIfNeeded();

        // Update connection status
        isConnected.value = true;
      },
      onError: (error) {
        print('Messages stream error: $error');
        isConnected.value = false;
      },
    );
  }

  void _autoScrollIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final position = scrollController.position;
        // Auto scroll if user is near bottom (within 100px)
        if (position.maxScrollExtent - position.pixels < 100) {
          _scrollToBottom();
        }
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Send text message
  void sendText() {
    final trimmedText = text.value.trim();
    if (trimmedText.isEmpty || chatId == null || currentUserId == null) return;

    final message = ChatMessage.text(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      chatId: chatId!,
      senderId: currentUserId!,
      senderName: 'You',
      isMe: true,
      text: trimmedText,
      createdAt: DateTime.now(),
    );

    // Add to local list immediately for instant UI update
    messages.add(message);

    // Save to local storage
    _storage.saveChatMessages(chatId!, messages.toList());

    // Clear text and scroll
    text.value = '';
    _scrollToBottom();

    // Send to Firebase (with retry logic)
    _sendMessageWithRetry(message);
  }

  Future<void> _sendMessageWithRetry(ChatMessage message) async {
    const maxRetries = 3;
    int attempts = 0;

    while (attempts < maxRetries) {
      final success = await _firebaseService.sendMessage(message);

      if (success) {
        // Update message status to sent
        final index = messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          messages[index] = message.copyWith(status: MessageStatus.sent);
          _storage.saveChatMessages(chatId!, messages.toList());
        }
        break;
      }

      attempts++;
      if (attempts < maxRetries) {
        await Future.delayed(Duration(seconds: attempts * 2));
      } else {
        // Mark as failed
        final index = messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          messages[index] = message.copyWith(status: MessageStatus.failed);
          _storage.saveChatMessages(chatId!, messages.toList());
        }
        Get.snackbar('Error', 'Failed to send message');
      }
    }
  }

  // Voice recording methods
  Future<void> startRecording() async {
    if (isRecording.value) return;

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      Get.snackbar('Permission Required', 'Microphone permission is needed for voice messages');
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final filePath = '${tempDir.path}/$fileName';

      await _recorder.start(
        RecordConfig(bitRate: 128000, sampleRate: 44100),
        path: filePath,
      );

      isRecording.value = true;
      recordElapsed.value = 0;

      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordElapsed.value++;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording');
    }
  }

  Future<void> stopRecordingAndSend({bool cancel = false}) async {
    if (!isRecording.value) return;

    _recordTimer?.cancel();
    isRecording.value = false;

    try {
      final filePath = await _recorder.stop();

      if (cancel || filePath == null || !File(filePath).existsSync() || recordElapsed.value < 1) {
        return;
      }

      var tempMessage = ChatMessage.voice(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        chatId: chatId!,
        senderId: currentUserId!,
        senderName: profileController.user.value?.name ?? 'user',
        isMe: true,
        audioPath: filePath,
        duration: Duration(seconds: recordElapsed.value),
        createdAt: DateTime.now(),
        uploadProgress: 0.0,
      );

      // Add immediately with 0% progress
      messages.add(tempMessage);
      _storage.saveChatMessages(chatId!, messages.toList());
      _scrollToBottom();

      // Upload with progress
      final url = await UrlGenerator.getUrl(
        filePath,
        onSendProgress: (count, total) {
          double progress = total > 0 ? count / total : 0;

          // replace message with updated copy
          tempMessage = tempMessage.copyWith(uploadProgress: progress);

          // find & update in the list
          final index = messages.indexWhere((m) => m.id == tempMessage.id);
          if (index != -1) {
            messages[index] = tempMessage;
            messages.refresh();
          }
        },
      );

      // Once uploaded, update message with URL & mark progress = 1
      tempMessage = tempMessage.copyWith(
        audioUrl: url,
        uploadProgress: 1.0,
        status: MessageStatus.sent,
      );

      final index = messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        messages[index] = tempMessage;
        messages.refresh();
      }

      // Send to Firebase
      await _sendMessageWithRetry(tempMessage);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save recording');
    }
  }


  Future<void> _sendVoiceMessageWithRetry(ChatMessage message) async {
    // For now, we'll just send the message without uploading the audio file
    // In a real app, you'd upload to Firebase Storage first
    await _sendMessageWithRetry(message);
  }

  Future<void> togglePlay(ChatMessage message) async {
    AppLogs.log("togglePlay called for messageId: ${message.id}");

    if (message.type != MessageType.voice) {
      AppLogs.log("Message type is not voice, returning...");
      return;
    }

    AppLogs.log("message.audioPath [ ${message.audioPath} ]  == message.audioUrl [ ${message.audioUrl} ] == message.text [ ${message.text} ]");
    String? audioPath = message.audioPath ?? message.audioUrl;
    AppLogs.log("Initial audioPath: $audioPath");

    if (audioPath == null) {
      AppLogs.log("No audioPath or audioUrl found, returning...");
      return;
    }

    try {
      if (_currentlyPlayingId == message.id) {
        AppLogs.log("Message is already playing: $_currentlyPlayingId");

        final state = _player.state;
        AppLogs.log("Current player state: $state");

        if (state == PlayerState.playing) {
          AppLogs.log("Pausing player...");
          await _player.pause();
          playingId.value = '';
          return;
        } else {
          AppLogs.log("Resuming player...");
          await _player.resume();
          playingId.value = message.id;
          return;
        }
      }

      AppLogs.log("Stopping any existing playback...");
      await _player.stop();
      _currentlyPlayingId = message.id;
      playingId.value = message.id;

      // Play from local file or remote URL
      // if (message.audioPath != null && File(message.audioPath!).existsSync()) {
      //   AppLogs.log("Playing from local file: ${message.audioPath}");
      //   await _player.play(DeviceFileSource(message.audioPath!));
      // } else if (message.audioUrl != null) {
      //   final url = "${ApiConfig.baseUrl}/${message.audioUrl}";
      //   AppLogs.log("Playing from remote URL: $url");
      //   await _player.play(UrlSource(url));
      // }
      if (message.audioPath != null && File(message.audioPath!).existsSync()) {
        AppLogs.log("Playing from local file: ${message.audioPath}");
        await _player.play(DeviceFileSource(message.audioPath!));
      } else if (message.audioUrl != null) {
        final url = message.audioUrl!.startsWith('http')
            ? message.audioUrl!
            : "${ApiConfig.baseUrl}/${message.audioUrl}";
        AppLogs.log("Playing from remote URL: $url");
        await _player.play(UrlSource(url));
      }


      // Listen to progress
      _player.onPositionChanged.listen((position) {
        final total = message.duration ?? Duration.zero;
        // AppLogs.log("Progress update - position: $position, total: $total");

        if (total.inMilliseconds > 0) {
          playingProgress.value =
              position.inMilliseconds / total.inMilliseconds;
          AppLogs.log("Updated playingProgress: ${playingProgress.value}");
        }
      });

      // Listen to completion
      _player.onPlayerComplete.listen((_) {
        AppLogs.log("Playback completed for messageId: ${message.id}");
        playingId.value = '';
        playingProgress.value = 0;
        _currentlyPlayingId = null;
      });
    } catch (e) {
      AppLogs.log("Error while playing audio: $e");
      Get.snackbar('Error', 'Failed to play audio');
      playingId.value = '';
      _currentlyPlayingId = null;
    }
  }

  // Retry failed message
  void retryMessage(ChatMessage message) {
    if (message.status == MessageStatus.failed) {
      final updatedMessage = message.copyWith(status: MessageStatus.sending);
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = updatedMessage;
        _storage.saveChatMessages(chatId!, messages.toList());

        if (message.type == MessageType.text) {
          _sendMessageWithRetry(updatedMessage);
        } else {
          _sendVoiceMessageWithRetry(updatedMessage);
        }
      }
    }
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    _recordTimer?.cancel();
    _player.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

extension MediaChat on ChatController {
  /// Send media (image/video) messages with upload + retry
  Future<void> sendMedia({
    required File file,
    required MessageType type, // MessageType.image or MessageType.video
  }) async {
    if (chatId == null || currentUserId == null) return;

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    // temp local message
    var tempMessage = ChatMessage.media(
      id: id,
      chatId: chatId!,
      senderId: currentUserId!,
      senderName: profileController.user.value?.name ?? 'You',
      isMe: true,
      type: type,
      mediaPath: file.path,
      createdAt: DateTime.now(),
      uploadProgress: 0.0,
      status: MessageStatus.sending,
    );

    // Show immediately in chat
    messages.add(tempMessage);
    _storage.saveChatMessages(chatId!, messages.toList());
    _scrollToBottom();

    try {
      // upload with progress
      final url = await UrlGenerator.getUrl(
        file.path,
        onSendProgress: (count, total) {
          double progress = total > 0 ? count / total : 0;

          tempMessage = tempMessage.copyWith(uploadProgress: progress);

          final index = messages.indexWhere((m) => m.id == tempMessage.id);
          if (index != -1) {
            messages[index] = tempMessage;
            messages.refresh();
          }
        },
      );

      // update with final URL
      tempMessage = tempMessage.copyWith(
        mediaUrl: url,
        uploadProgress: 1.0,
        status: MessageStatus.sent,
      );

      final index = messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        messages[index] = tempMessage;
        messages.refresh();
      }

      // send to firebase
      await _sendMessageWithRetry(tempMessage);
    } catch (e) {
      AppLogs.log("❌ Failed to upload/send media: $e");

      // mark failed
      final index = messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        messages[index] = tempMessage.copyWith(status: MessageStatus.failed);
        messages.refresh();
      }
      Get.snackbar("Error", "Failed to send media");
    }
  }
}


// Future<void> stopRecordingAndSend({bool cancel = false}) async {
//   if (!isRecording.value) return;
//
//   _recordTimer?.cancel();
//   isRecording.value = false;
//
//   try {
//     final filePath = await _recorder.stop();
//
//     if (cancel ||
//         filePath == null ||
//         !File(filePath).existsSync() ||
//         recordElapsed.value < 1) {
//       return;
//     }
//
//     final url = await UrlGenerator.getUrl(filePath,onSendProgress: (count, total) {
//       AppLogs.log("=========== count [ $count ] & total [ $total ] ==========");
//
//     },);
//
//     AppLogs.log("===========response==========");
//     AppLogs.log("===========${url}==========");
//     AppLogs.log("===========${ApiConfig.baseUrl}/${url}==========");
//     // AppLogs.log("===========${response.data}==========");
//     // AppLogs.log("===========${response.message}==========");
//
//     final message = ChatMessage.voice(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       chatId: chatId!,
//       senderId: currentUserId!,
//       senderName: 'You',
//       isMe: true,
//       audioPath: filePath,
//       duration: Duration(seconds: recordElapsed.value),
//       createdAt: DateTime.now(),
//       audioUrl: url
//     );
//
//     // Add to local list immediately
//     messages.add(message);
//     _storage.saveChatMessages(chatId!, messages.toList());
//     _scrollToBottom();
//
//     // Send to Firebase (upload audio file first)
//     _sendVoiceMessageWithRetry(message);
//   } catch (e) {
//     Get.snackbar('Error', 'Failed to save recording');
//   }
// }

/// oldd
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'model/chat_message_model.dart';
//
// class ChatController extends GetxController {
//   final messages = <ChatMessage>[].obs;
//   final text = ''.obs;
//   final scrollController = ScrollController();
//
//   final _fire = FirebaseFirestore.instance;
//   final _box = GetStorage();
//
//   final String userId;
//   final String customerCareId;
//   late final String chatId;
//
//   final _rec = AudioRecorder();
//   bool get isRecording => _isRecording.value;
//   final _isRecording = false.obs;
//   final recordElapsed = 0.obs; // seconds
//   Timer? _timer;
//
//   final _player = AudioPlayer();
//   String? _currentlyPlayingId;
//   final playingId = ''.obs;   // message id that is playing
//   final playingProgress = 0.0.obs;
//
//   ChatController({required this.userId, required this.customerCareId}) {
//     chatId = "${userId}_$customerCareId";
//   }
//
//   /// 🔹 Listen to Firestore
//   void listenMessages() {
//     _fire.collection("chats/$chatId/messages")
//         .orderBy("createdAt", descending: false)
//         .snapshots()
//         .listen((snap) {
//       messages.value = snap.docs.map((d) => ChatMessage.fromMap(d.data())).toList();
//
//       // 🔹 Cache locally
//       _box.write(chatId, messages.map((e) => e.toMap()).toList());
//
//       _scrollToBottom();
//     });
//   }
//
//   /// 🔹 Load cached messages for faster display
//   void loadCached() {
//     final cached = _box.read(chatId);
//     if (cached != null) {
//       messages.value = (cached as List).map((e) => ChatMessage.fromMap(Map<String, dynamic>.from(e))).toList();
//     }
//   }
//
//   /// 🔹 Send text
//   Future<void> sendText() async {
//     final t = text.value.trim();
//     if (t.isEmpty) return;
//
//     final msg = ChatMessage.text(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       isMe: true,
//       senderId: userId,
//       receiverId: customerCareId,
//       text: t,
//       createdAt: DateTime.now(),
//     );
//
//     await _fire.collection("chats/$chatId/messages").doc(msg.id).set(msg.toMap());
//     text.value = '';
//   }
//
//   /// 🔹 Send voice
//   Future<void> sendVoice(String path, int seconds) async {
//     final msg = ChatMessage.voice(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       isMe: true,
//       senderId: userId,
//       receiverId: customerCareId,
//       audioPath: path,
//       duration: Duration(seconds: seconds),
//       createdAt: DateTime.now(),
//     );
//
//     await _fire.collection("chats/$chatId/messages").doc(msg.id).set(msg.toMap());
//   }
//
//   Future<void> startRecording() async {
//     if (isRecording) return;
//     if (!await _rec.hasPermission()) {
//       // Optionally show a toast
//       return;
//     }
//     final dir = await getTemporaryDirectory();
//     final path =
//         '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//     await _rec.start(RecordConfig(bitRate: 128000, sampleRate: 44100), path: path);
//     // path: path,
//     // encoder: AudioEncoder.aacLc,
//     // bitRate: 128000,
//     // samplingRate: 44100,
//     // );
//
//     _isRecording.value = true;
//     recordElapsed.value = 0;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       recordElapsed.value++;
//     });
//   }
//
//   Future<void> stopRecordingAndSend({bool cancel = false}) async {
//     if (!isRecording) return;
//     _timer?.cancel();
//     _isRecording.value = false;
//
//     final path = await _rec.stop(); // returns file path
//     if (cancel || path == null || !File(path).existsSync() || recordElapsed.value < 1) {
//       return;
//     }
//
//     final msg = ChatMessage.voice(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       isMe: true,
//       audioPath: path,
//       duration: Duration(seconds: recordElapsed.value),
//       createdAt: DateTime.now(), senderId: '', receiverId: '',
//     );
//     sendVoice("msg", recordElapsed.value);
//     // TODO: upload file / push meta to backend later
//   }
//
//   Future<void> togglePlay(ChatMessage msg) async {
//     if (msg.type != MessageType.voice || msg.audioPath == null) return;
//
//     if (_currentlyPlayingId == msg.id) {
//       final state =  _player.state;
//       if (state == PlayerState.playing) {
//         await _player.pause();
//         playingId.value = '';
//         return;
//       } else {
//         await _player.resume();
//         playingId.value = msg.id;
//         return;
//       }
//     }
//
//     await _player.stop();
//     _currentlyPlayingId = msg.id;
//     playingId.value = msg.id;
//
//     await _player.play(DeviceFileSource(msg.audioPath!));
//
//     _player.onPositionChanged.listen((d) {
//       final total = msg.duration ?? Duration.zero;
//       if (total.inMilliseconds == 0) {
//         playingProgress.value = 0;
//       } else {
//         playingProgress.value = d.inMilliseconds / total.inMilliseconds;
//       }
//     });
//
//     _player.onPlayerComplete.listen((_) {
//       playingId.value = '';
//       playingProgress.value = 0;
//       _currentlyPlayingId = null;
//     });
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (scrollController.hasClients) {
//         scrollController.jumpTo(scrollController.position.maxScrollExtent);
//       }
//     });
//   }
// }
