// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AppPage {
//   /// Go to next screen
//   static void open(Widget page) {
//     Get.to(() => page);
//   }
//
//   /// Go to next screen and remove previous (replacement)
//   static void openReplace(Widget page) {
//     Get.off(() => page);
//   }
//
//   /// Go to next screen and remove all previous (clear stack)
//   static void openAndRemoveUntil(Widget page) {
//     Get.offAll(() => page);
//   }
//
//   /// Go back
//   static void close() {
//     if (Get.key.currentState?.canPop() ?? false) {
//       Get.back();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage {
  /// Go to next screen
  static Future<T?> open<T>(Widget page, {bool fullscreenDialog = false}) async {
    return Get.to<T>(
          () => page,
      fullscreenDialog: fullscreenDialog,
      transition: Transition.rightToLeft, // default animation
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Go to next screen and remove previous (replacement)
  static Future<T?> openReplace<T>(Widget Function() page, {bool fullscreenDialog = false}) async {
    return Get.off<T>(
          () => page,
      fullscreenDialog: fullscreenDialog,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Go to next screen and remove all previous (clear stack)
  static Future<T?> openAndRemoveUntil<T>(Widget page, {bool fullscreenDialog = false}) async {
    return Get.offAll<T>(
          () => page,
      fullscreenDialog: fullscreenDialog,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Go back with optional [result]
  static void close<T>({T? result}) {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back<T>(result: result);
    }
  }

  /// Close all dialogs, sheets etc
  static void closeAll() {
    while (Get.isOverlaysOpen) {
      Get.back();
    }
  }
}
