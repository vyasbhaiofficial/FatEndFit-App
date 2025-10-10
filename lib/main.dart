import 'package:fat_end_fit/service/connectivity_service.dart';
import 'package:fat_end_fit/service/firebase_service.dart';
import 'package:fat_end_fit/service/language_service.dart';
import 'package:fat_end_fit/utils/app_sequrity.dart';
import 'package:fat_end_fit/utils/app_storage.dart';
import 'package:fat_end_fit/view/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:fat_end_fit/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print('FIREBASE CONNECTED SUCCESS...');
  },);
  FirebaseService.init();
  await AppStorage.init();
  AppSecurity().noScreenShotOn();
  await LanguageService().loadLanguages();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    systemNavigationBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  var isLogin = AppStorage().read("isLogin") ?? false;
  if(isLogin) {
    FirebaseService().updateToken();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LanguageService(),
      locale: LanguageService().getInitialLocale(),
      fallbackLocale: const Locale('en'),
      home: SplashScreen(),
    );
  }
}
