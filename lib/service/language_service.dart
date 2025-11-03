import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_storage.dart';

class LanguageService extends Translations {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final Map<String, Map<String, String>> _localizedValues = {};

  /// Load JSON files dynamically
  Future<void> loadLanguages() async {
    _localizedValues['en'] =
    Map<String, String>.from(jsonDecode(await rootBundle.loadString('lib/translations/en.json')));
    _localizedValues['hi'] =
    Map<String, String>.from(jsonDecode(await rootBundle.loadString('lib/translations/hi.json')));
    _localizedValues['gu'] =
    Map<String, String>.from(jsonDecode(await rootBundle.loadString('lib/translations/gu.json')));
  }

  @override
  Map<String, Map<String, String>> get keys => _localizedValues;

  /// Change language at runtime + save in storage
  void changeLanguage(String langCode) {
    var locale = Locale(langCode);
    Get.updateLocale(locale);
    AppStorage().saveLanguage(langCode);
  }

  /// Load saved language or default to English
  Locale getInitialLocale() {
    String? savedCode = AppStorage().getLanguage();
    return Locale(savedCode ?? 'en');
  }
}

// // how to use:
// class LanguageScreen extends StatelessWidget {
//   final languages = {
//     "English": "en",
//     "हिंदी": "hi",
//     "ગુજરાતી": "gu",
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Select Language")),
//       body: ListView(
//         children: languages.entries.map((entry) {
//           return ListTile(
//             title: Text(entry.key),
//             onTap: () {
//               LanguageService().changeLanguage(entry.value);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
