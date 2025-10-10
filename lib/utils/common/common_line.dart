import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/chat/chat_customer_support_screen.dart';
import '../app_color.dart';
import '../app_images.dart';
import 'app_image.dart';

class CustomLine extends StatelessWidget {
  final double height;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final double? width;

  const CustomLine({
    Key? key,
    this.height = 2,
    this.width,
    this.colors = const [
      Colors.transparent,
      Colors.black54,
      Colors.transparent,
    ],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
    );
  }
}

class CommonFloatingButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? child;

  const CommonFloatingButton({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FloatingActionButton(
      backgroundColor: backgroundColor ?? AppColor.yellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onPressed: onTap ??
              () {
            if (Get.isOverlaysOpen) return;
            if (Get.currentRoute == '/CustomerSupportChatScreen') return;

            Get.to(() => CustomerSupportChatScreen(),transition: Transition.downToUp);
          },
      child: child ??
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: AppImage.svg(AppImages.headPhoneIcon),
          ),
    );
  }
}