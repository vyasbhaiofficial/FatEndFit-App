import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../firebase_options.dart';
import '../utils/app_print.dart';
import '../view/chat/model/chat_message_model.dart';
import 'api_config.dart';
import 'api_service.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// 🔹 Local Notification plugin
  // static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  /// 🔹 Init Firebase
  static Future<void> init() async {
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Request Notification Permissions
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM Token
    String? token = await messaging.getToken();
    print("🔥 FCM Token: $token");

    // Listen foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message: ${message.notification?.title}");
      // _showLocalNotification(message);
    });

    // Background & Terminated state click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("👉 User clicked on notification: ${message.data}");
    });

    // Local Notification Setup
    // const AndroidInitializationSettings androidInit =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    // const InitializationSettings initSettings =
    // InitializationSettings(android: androidInit);
    // await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// 🔹 Show Local Notification
  // static Future<void> _showLocalNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidDetails =
  //   AndroidNotificationDetails(
  //     'default_channel',
  //     'General Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails platformDetails =
  //   NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     message.hashCode,
  //     message.notification?.title ?? "No Title",
  //     message.notification?.body ?? "No Body",
  //     platformDetails,
  //     payload: message.data.toString(),
  //   );
  // }

  /// 🔹 Subscribe to topic
  static Future<void> subscribeTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
    print("✅ Subscribed to $topic");
  }

  /// 🔹 Unsubscribe from topic
  static Future<void> unsubscribeTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
    print("🚫 Unsubscribed from $topic");
  }

  /// 🔹 Get Current Token
  static Future<String?> getToken() async {
    return await messaging.getToken();
  }

  /// 🔹 Delete Token
  static Future<void> deleteToken() async {
    await messaging.deleteToken();
    print("🗑️ FCM Token deleted");
  }

  Future<void> updateToken() async {
    try {
      // 🔑 Get FCM Token
      final token = await messaging.getToken();

      if (token == null) {
        AppLogs.log("⚠️ Token not available");
        return;
      }

      final data = {
        "fcmToken": token,
      };

      // PUT API call
      final response = await AppApi.getInstance().put(
        ApiConfig.updateToken, // 🔗 endpoint define karo ApiConfig ma
        data: data,
      );

      if (response.success) {
        AppLogs.log("✅ Token updated successfully");
      } else {
        AppLogs.log("❌ Token update failed: ${response.message}");
      }
    } catch (e) {
      AppLogs.log("🔥 Error updating token: $e");
    }
  }


  // Firestore instance

  Future<String?> createOrGetChat(String userId, String userName,) async {
    try {
      ProfileController profileController = Get.find();

      // Get customer care ID from user profile
      final customerCareId = profileController.user.value?.branch;
      if (customerCareId == null) return null;

      final chatId = '${userId}_$customerCareId';

      // Check if chat already exists
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        // Create new chat
        final customerCareDoc = await _firestore
            .collection('customer_care')
            .doc(customerCareId)
            .get();

        final customerCareName = customerCareDoc.data()?['name'] ?? 'Customer Support';

        final chatInfo = ChatInfo(
          chatId: chatId,
          userId: userId,
          userName: profileController.user.value?.name ?? '',
          userArea: "test",
          customerCareId: customerCareId,
          customerCareName: customerCareName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('chats').doc(chatId).set(chatInfo.toFirestore());
      }

      return chatId;
    } catch (e) {
      print('Error creating/getting chat: $e');
      return null;
    }
  }

  // Send message to Firestore
  Future<bool> sendMessage(ChatMessage message) async {
    try {
      print("SEND MESSAGE: ${message.toFirestore()}");
      await _firestore
          .collection('chats')
          .doc(message.chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toFirestore());

      // Update chat info with last message
      await _firestore.collection('chats').doc(message.chatId).update({
        'lastMessage': message.toFirestore(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // Listen to messages
  Stream<List<ChatMessage>> getMessagesStream(String chatId, String currentUserId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data(), currentUserId))
          .toList();
    });
  }

  // Update message status
  Future<void> updateMessageStatus(String chatId, String messageId, MessageStatus status) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'status': status.name});
    } catch (e) {
      print('Error updating message status: $e');
    }
  }

  // Get all chats for admin panel
  Stream<List<ChatInfo>> getAllChatsStream(String currentUserId) {
    return _firestore
        .collection('chats')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatInfo.fromFirestore(doc.data(), currentUserId))
          .toList();
    });
  }


  /// 🔹 Analytics Event
  // static Future<void> logEvent(String name,
  //     {Map<String, Object?>? params}) async {
  //   await analytics.logEvent(name: name, parameters: params);
  // }
}
