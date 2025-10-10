import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_print.dart';
import '../../utils/app_images.dart';
import '../../utils/common/app_image.dart';
import '../../utils/common/app_text.dart';
import '../profile/profile_controller.dart';
import 'my_progress_controller.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProgressController());
    ProfileController profile = Get.find();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),

            // Logo Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12),
            //   child: Center(
            //     child: SvgPicture.asset(
            //       AppImages.fatEndFitIcon,
            //       height: 50,
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.015),
              child: Center(
                child: SvgPicture.asset(AppImages.fatEndFitIcon, height: height * 0.06),
              ),
            ),

            // const SizedBox(height: 10),


            // Days List
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: profile.user.value?.planCurrentDay ?? 1,
                itemBuilder: (context, index) {
                  final label = "${AppString.day} - ${(index + 1).toString().padLeft(2, '0')}";
                  return ProgressDayCard(
                    dayLabel: label,
                    onEditPressed: () => controller.onEditProgress(label),
                  );
                },
              )),
            ),
          ],
        ),
      ),

    );
  }

}

/// Common Progress Card
class ProgressDayCard extends StatelessWidget {
  final String dayLabel;
  final VoidCallback onEditPressed;

  const ProgressDayCard({
    super.key,
    required this.dayLabel,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              dayLabel,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.textBlack,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              ),
              onPressed: onEditPressed,
              child: AppText(
                AppString.editProgress,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}