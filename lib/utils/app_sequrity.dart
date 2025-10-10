import 'package:no_screenshot/no_screenshot.dart';

class AppSecurity {
  AppSecurity._(); // private constructor

  static final AppSecurity _instance = AppSecurity._();

  factory AppSecurity() => _instance;

  void noScreenShotOff() {
    NoScreenshot.instance.screenshotOn();
  }

  void noScreenShotOn() {
    NoScreenshot.instance.screenshotOff();
  }
}
