import 'package:fat_end_fit/utils/app_print.dart';
import 'package:get_storage/get_storage.dart';

import '../view/chat/model/chat_message_model.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;
  AppStorage._internal();

  final _box = GetStorage();

  /// Call this before runApp()
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Save data
  Future<void> save(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read data
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Delete single key
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clear all data
  Future<void> clear() async {
    await _box.erase();
  }

  /// Check if key exists
  bool has(String key) {
    return _box.hasData(key);
  }

  static const String keyLanguageCode = "language_code";

  Future<void> saveLanguage(String langCode) async {
    await save(keyLanguageCode, langCode);
  }

  /// Get language
  String? getLanguage() {
    return read<String>(keyLanguageCode);
  }

  /// get User Login Status
  bool get isLogin => read<bool>('isLogin') ?? false;

  /// common login status check
  void checkIsLogin() {
    if (!isLogin) {
      AppLogs.log("Warning!!! User not logged in");
      return;
    }
  }

  /// Chat --
  Future<void> saveChatMessages(String chatId, List<ChatMessage> messages) async {
    final jsonList = messages.map((msg) => msg.toJson()).toList();
    await save('chat_messages_$chatId', jsonList);
  }

  List<ChatMessage> getChatMessages(String chatId) {
    final jsonList = read<List>('chat_messages_$chatId');
    if (jsonList == null) return [];

    return jsonList
        .map((json) => ChatMessage.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveCurrentUserId(String userId) async {
    await save('current_user_id', userId);
  }

  String? getCurrentUserId() {
    return read<String>('current_user_id');
  }

  Future<void> saveUserArea(String area) async {
    await save('user_area', area);
  }

  String? getUserArea() {
    return read<String>('user_area');
  }
}
