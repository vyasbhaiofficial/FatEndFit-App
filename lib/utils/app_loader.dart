import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_color.dart';

class AppLoader {
  static void show() {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}


class AppLoaderWidget extends StatelessWidget {
  final double size;
  const AppLoaderWidget({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation(AppColor.yellow),
          // backgroundColor: AppColor.black,
        ),
      ),
    );
  }
}

