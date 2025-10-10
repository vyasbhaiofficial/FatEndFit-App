// enum MessageType { text, voice }
//
// class ChatMessage {
//   final String id;
//   final bool isMe;
//   final MessageType type;
//   final String? text;
//   final String? audioPath;
//   final Duration? duration;
//   final DateTime createdAt;
//
//   ChatMessage.text({
//     required this.id,
//     required this.isMe,
//     required this.text,
//     required this.createdAt,
//   })  : type = MessageType.text,
//         audioPath = null,
//         duration = null;
//
//   ChatMessage.voice({
//     required this.id,
//     required this.isMe,
//     required this.audioPath,
//     required this.duration,
//     required this.createdAt,
//   })  : type = MessageType.voice,
//         text = null;
// }


// enum MessageType { text, voice }
enum MessageStatus { sending, sent, delivered, read, failed }

// class ChatMessage {
//   final String id;
//   final String chatId;
//   final String senderId;
//   final String senderName;
//   final bool isMe;
//   final MessageType type;
//   final String? text;
//   final String? audioPath;
//   final String? audioUrl; // Firebase storage URL
//   final Duration? duration;
//   final DateTime createdAt;
//   final MessageStatus status;
//
//   /// 0.0 → not uploaded, 1.0 → fully uploaded
//   final double uploadProgress;
//
//   ChatMessage.text({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     required this.isMe,
//     required this.text,
//     required this.createdAt,
//     this.status = MessageStatus.sending,
//     this.uploadProgress = 1.0, // text is always instantly "uploaded"
//   })  : type = MessageType.text,
//         audioPath = null,
//         audioUrl = null,
//         duration = null;
//
//   ChatMessage.voice({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     required this.isMe,
//     required this.audioPath,
//     this.audioUrl,
//     required this.duration,
//     required this.createdAt,
//     this.status = MessageStatus.sending,
//     this.uploadProgress = 0.0, // voice starts uploading
//   })  : type = MessageType.voice,
//         text = null;
//
//   // 🔹 Firestore conversion
//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'senderName': senderName,
//       'type': type.name,
//       'text': text,
//       'audioUrl': audioUrl,
//       'duration': duration?.inSeconds,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'status': status.name,
//       'uploadProgress': uploadProgress,
//     };
//   }
//
//   factory ChatMessage.fromFirestore(Map<String, dynamic> data, String currentUserId) {
//     final type = MessageType.values.firstWhere((e) => e.name == data['type']);
//     final status = MessageStatus.values.firstWhere(
//           (e) => e.name == (data['status'] ?? 'sent'),
//       orElse: () => MessageStatus.sent,
//     );
//     final progress = (data['uploadProgress'] ?? (type == MessageType.text ? 1.0 : 0.0)).toDouble();
//
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: data['id'],
//         chatId: data['chatId'],
//         senderId: data['senderId'],
//         senderName: data['senderName'],
//         isMe: data['senderId'] == currentUserId,
//         text: data['text'],
//         createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
//         status: status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: data['id'],
//         chatId: data['chatId'],
//         senderId: data['senderId'],
//         senderName: data['senderName'],
//         isMe: data['senderId'] == currentUserId,
//         audioUrl: data['audioUrl'],
//         audioPath: null,
//         duration: Duration(seconds: data['duration'] ?? 0),
//         createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
//         status: status,
//         uploadProgress: progress,
//       );
//     }
//   }
//
//   // 🔹 Local JSON storage
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'senderName': senderName,
//       'isMe': isMe,
//       'type': type.name,
//       'text': text,
//       'audioPath': audioPath,
//       'audioUrl': audioUrl,
//       'duration': duration?.inSeconds,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'status': status.name,
//       'uploadProgress': uploadProgress,
//     };
//   }
//
//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     final type = MessageType.values.firstWhere((e) => e.name == json['type']);
//     final status = MessageStatus.values.firstWhere(
//           (e) => e.name == (json['status'] ?? 'sent'),
//       orElse: () => MessageStatus.sent,
//     );
//     final progress = (json['uploadProgress'] ?? (type == MessageType.text ? 1.0 : 0.0)).toDouble();
//
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: json['id'],
//         chatId: json['chatId'],
//         senderId: json['senderId'],
//         senderName: json['senderName'],
//         isMe: json['isMe'],
//         text: json['text'],
//         createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
//         status: status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: json['id'],
//         chatId: json['chatId'],
//         senderId: json['senderId'],
//         senderName: json['senderName'],
//         isMe: json['isMe'],
//         audioPath: json['audioPath'],
//         audioUrl: json['audioUrl'],
//         duration: Duration(seconds: json['duration'] ?? 0),
//         createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
//         status: status,
//         uploadProgress: progress,
//       );
//     }
//   }
//
//   // 🔹 Helper for immutability
//   ChatMessage copyWith({
//     MessageStatus? status,
//     String? audioUrl,
//     String? audioPath,
//     double? uploadProgress,
//   }) {
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: id,
//         chatId: chatId,
//         senderId: senderId,
//         senderName: senderName,
//         isMe: isMe,
//         text: text,
//         createdAt: createdAt,
//         status: status ?? this.status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: id,
//         chatId: chatId,
//         senderId: senderId,
//         senderName: senderName,
//         isMe: isMe,
//         audioPath: audioPath ?? this.audioPath,
//         audioUrl: audioUrl ?? this.audioUrl,
//         duration: duration,
//         createdAt: createdAt,
//         status: status ?? this.status,
//         uploadProgress: uploadProgress ?? this.uploadProgress,
//       );
//     }
//   }
// }
enum MessageType { text, voice, image, video }

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final bool isMe;
  final MessageType type;

  // 🔹 content
  final String? text;
  final String? audioPath;
  final String? audioUrl;
  final String? mediaPath; // local file (image/video)
  final String? mediaUrl;  // uploaded URL

  final Duration? duration;
  final DateTime createdAt;
  final MessageStatus status;

  /// 0.0 → not uploaded, 1.0 → fully uploaded
  final double uploadProgress;

  // 🔹 Text
  ChatMessage.text({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.isMe,
    required this.text,
    required this.createdAt,
    this.status = MessageStatus.sending,
    this.uploadProgress = 1.0,
  })  : type = MessageType.text,
        audioPath = null,
        audioUrl = null,
        mediaPath = null,
        mediaUrl = null,
        duration = null;

  // 🔹 Voice
  ChatMessage.voice({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.isMe,
    required this.audioPath,
    this.audioUrl,
    required this.duration,
    required this.createdAt,
    this.status = MessageStatus.sending,
    this.uploadProgress = 0.0,
  })  : type = MessageType.voice,
        text = null,
        mediaPath = null,
        mediaUrl = null;

  // 🔹 Media (image/video)
  ChatMessage.media({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.isMe,
    required this.type, // must be MessageType.image or MessageType.video
    this.mediaPath,
    this.mediaUrl,
    required this.createdAt,
    this.status = MessageStatus.sending,
    this.uploadProgress = 0.0,
  })  : assert(type == MessageType.image || type == MessageType.video),
        text = null,
        audioPath = null,
        audioUrl = null,
        duration = null;

  // 🔹 Firestore conversion
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'type': type.name,
      'text': text,
      'audioUrl': audioUrl,
      'mediaUrl': mediaUrl,
      'duration': duration?.inSeconds,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.name,
      'uploadProgress': uploadProgress,
    };
  }

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String currentUserId) {
    final type = MessageType.values.firstWhere((e) => e.name == data['type']);
    final status = MessageStatus.values.firstWhere(
          (e) => e.name == (data['status'] ?? 'sent'),
      orElse: () => MessageStatus.sent,
    );
    final progress = (data['uploadProgress'] ?? (type == MessageType.text ? 1.0 : 0.0)).toDouble();

    switch (type) {
      case MessageType.text:
        return ChatMessage.text(
          id: data['id'],
          chatId: data['chatId'],
          senderId: data['senderId'],
          senderName: data['senderName'],
          isMe: data['senderId'] == currentUserId,
          text: data['text'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
          status: status,
        );
      case MessageType.voice:
        return ChatMessage.voice(
          id: data['id'],
          chatId: data['chatId'],
          senderId: data['senderId'],
          senderName: data['senderName'],
          isMe: data['senderId'] == currentUserId,
          audioUrl: data['audioUrl'],
          audioPath: null,
          duration: Duration(seconds: data['duration'] ?? 0),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
          status: status,
          uploadProgress: progress,
        );
      case MessageType.image:
      case MessageType.video:
        return ChatMessage.media(
          id: data['id'],
          chatId: data['chatId'],
          senderId: data['senderId'],
          senderName: data['senderName'],
          isMe: data['senderId'] == currentUserId,
          type: type,
          mediaUrl: data['mediaUrl'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
          status: status,
          uploadProgress: progress,
        );
    }
  }

  // 🔹 Local JSON storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'isMe': isMe,
      'type': type.name,
      'text': text,
      'audioPath': audioPath,
      'audioUrl': audioUrl,
      'mediaPath': mediaPath,
      'mediaUrl': mediaUrl,
      'duration': duration?.inSeconds,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.name,
      'uploadProgress': uploadProgress,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final type = MessageType.values.firstWhere((e) => e.name == json['type']);
    final status = MessageStatus.values.firstWhere(
          (e) => e.name == (json['status'] ?? 'sent'),
      orElse: () => MessageStatus.sent,
    );
    final progress = (json['uploadProgress'] ?? (type == MessageType.text ? 1.0 : 0.0)).toDouble();

    switch (type) {
      case MessageType.text:
        return ChatMessage.text(
          id: json['id'],
          chatId: json['chatId'],
          senderId: json['senderId'],
          senderName: json['senderName'],
          isMe: json['isMe'],
          text: json['text'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          status: status,
        );
      case MessageType.voice:
        return ChatMessage.voice(
          id: json['id'],
          chatId: json['chatId'],
          senderId: json['senderId'],
          senderName: json['senderName'],
          isMe: json['isMe'],
          audioPath: json['audioPath'],
          audioUrl: json['audioUrl'],
          duration: Duration(seconds: json['duration'] ?? 0),
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          status: status,
          uploadProgress: progress,
        );
      case MessageType.image:
      case MessageType.video:
        return ChatMessage.media(
          id: json['id'],
          chatId: json['chatId'],
          senderId: json['senderId'],
          senderName: json['senderName'],
          isMe: json['isMe'],
          type: type,
          mediaPath: json['mediaPath'],
          mediaUrl: json['mediaUrl'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          status: status,
          uploadProgress: progress,
        );
    }
  }

  // 🔹 Helper for immutability
  ChatMessage copyWith({
    MessageStatus? status,
    String? audioUrl,
    String? audioPath,
    String? mediaUrl,
    String? mediaPath,
    double? uploadProgress,
  }) {
    switch (type) {
      case MessageType.text:
        return ChatMessage.text(
          id: id,
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
          isMe: isMe,
          text: text,
          createdAt: createdAt,
          status: status ?? this.status,
        );
      case MessageType.voice:
        return ChatMessage.voice(
          id: id,
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
          isMe: isMe,
          audioPath: audioPath ?? this.audioPath,
          audioUrl: audioUrl ?? this.audioUrl,
          duration: duration,
          createdAt: createdAt,
          status: status ?? this.status,
          uploadProgress: uploadProgress ?? this.uploadProgress,
        );
      case MessageType.image:
      case MessageType.video:
        return ChatMessage.media(
          id: id,
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
          isMe: isMe,
          type: type,
          mediaPath: mediaPath ?? this.mediaPath,
          mediaUrl: mediaUrl ?? this.mediaUrl,
          createdAt: createdAt,
          status: status ?? this.status,
          uploadProgress: uploadProgress ?? this.uploadProgress,
        );
    }
  }
}

// class ChatMessage {
//   final String id;
//   final String chatId;
//   final String senderId;
//   final String senderName;
//   final bool isMe;
//   final MessageType type;
//   final String? text;
//   final String? audioPath;
//   final String? audioUrl; // Firebase storage URL
//   final Duration? duration;
//   final DateTime createdAt;
//   final MessageStatus status;
//
//   ChatMessage.text({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     required this.isMe,
//     required this.text,
//     required this.createdAt,
//     this.status = MessageStatus.sending,
//   })  : type = MessageType.text,
//         audioPath = null,
//         audioUrl = null,
//         duration = null;
//
//   ChatMessage.voice({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     required this.isMe,
//     required this.audioPath,
//     this.audioUrl,
//     required this.duration,
//     required this.createdAt,
//     this.status = MessageStatus.sending,
//   })  : type = MessageType.voice,
//         text = null;
//
//   // Convert to/from Firestore
//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'senderName': senderName,
//       'type': type.name,
//       'text': text,
//       'audioUrl': audioUrl,
//       'duration': duration?.inSeconds,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'status': status.name,
//     };
//   }
//
//   factory ChatMessage.fromFirestore(Map<String, dynamic> data, String currentUserId) {
//     final type = MessageType.values.firstWhere((e) => e.name == data['type']);
//     final status = MessageStatus.values.firstWhere(
//           (e) => e.name == (data['status'] ?? 'sent'),
//       orElse: () => MessageStatus.sent,
//     );
//
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: data['id'],
//         chatId: data['chatId'],
//         senderId: data['senderId'],
//         senderName: data['senderName'],
//         isMe: data['senderId'] == currentUserId,
//         text: data['text'],
//         createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
//         status: status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: data['id'],
//         chatId: data['chatId'],
//         senderId: data['senderId'],
//         senderName: data['senderName'],
//         isMe: data['senderId'] == currentUserId,
//         audioUrl: data['audioUrl'],
//         audioPath: null, // Will be downloaded locally if needed
//         duration: Duration(seconds: data['duration'] ?? 0),
//         createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
//         status: status,
//       );
//     }
//   }
//
//   // Convert to/from local storage
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'senderName': senderName,
//       'isMe': isMe,
//       'type': type.name,
//       'text': text,
//       'audioPath': audioPath,
//       'audioUrl': audioUrl,
//       'duration': duration?.inSeconds,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'status': status.name,
//     };
//   }
//
//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     final type = MessageType.values.firstWhere((e) => e.name == json['type']);
//     final status = MessageStatus.values.firstWhere(
//           (e) => e.name == (json['status'] ?? 'sent'),
//       orElse: () => MessageStatus.sent,
//     );
//
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: json['id'],
//         chatId: json['chatId'],
//         senderId: json['senderId'],
//         senderName: json['senderName'],
//         isMe: json['isMe'],
//         text: json['text'],
//         createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
//         status: status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: json['id'],
//         chatId: json['chatId'],
//         senderId: json['senderId'],
//         senderName: json['senderName'],
//         isMe: json['isMe'],
//         audioPath: json['audioPath'],
//         audioUrl: json['audioUrl'],
//         duration: Duration(seconds: json['duration'] ?? 0),
//         createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
//         status: status,
//       );
//     }
//   }
//
//   ChatMessage copyWith({
//     MessageStatus? status,
//     String? audioUrl,
//     String? audioPath,
//   }) {
//     if (type == MessageType.text) {
//       return ChatMessage.text(
//         id: id,
//         chatId: chatId,
//         senderId: senderId,
//         senderName: senderName,
//         isMe: isMe,
//         text: text,
//         createdAt: createdAt,
//         status: status ?? this.status,
//       );
//     } else {
//       return ChatMessage.voice(
//         id: id,
//         chatId: chatId,
//         senderId: senderId,
//         senderName: senderName,
//         isMe: isMe,
//         audioPath: audioPath ?? this.audioPath,
//         audioUrl: audioUrl ?? this.audioUrl,
//         duration: duration,
//         createdAt: createdAt,
//         status: status ?? this.status,
//       );
//     }
//   }
// }
//
class ChatInfo {
  final String chatId;
  final String userId;
  final String userName;
  final String userArea;
  final String customerCareId;
  final String customerCareName;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;

  ChatInfo({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.userArea,
    required this.customerCareId,
    required this.customerCareName,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'userId': userId,
      'userName': userName,
      'userArea': userArea,
      'customerCareId': customerCareId,
      'customerCareName': customerCareName,
      'lastMessage': lastMessage?.toFirestore(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
    };
  }

  factory ChatInfo.fromFirestore(Map<String, dynamic> data, String currentUserId) {
    return ChatInfo(
      chatId: data['chatId'],
      userId: data['userId'],
      userName: data['userName'],
      userArea: data['userArea'],
      customerCareId: data['customerCareId'],
      customerCareName: data['customerCareName'],
      lastMessage: data['lastMessage'] != null
          ? ChatMessage.fromFirestore(data['lastMessage'], currentUserId)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
      unreadCount: data['unreadCount'] ?? 0,
    );
  }
}


