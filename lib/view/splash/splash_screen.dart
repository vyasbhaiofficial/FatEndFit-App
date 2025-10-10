import 'package:fat_end_fit/view/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/app_images.dart';
import '../../utils/common/app_image.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: Get.width * 0.14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImages.fatEndFitIcon,
                width: 120,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
