import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/common/app_text.dart';
import '../../../utils/common_function.dart';
import '../bottom_nav_bar_controller.dart';


class CommonBottomBar extends StatelessWidget {
  final RxInt selectedIndex;
  final List<String> labels;
  final List<String> icons;
  final Function(int) onTap;

  const CommonBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.labels,
    required this.icons,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(labels.length == icons.length, "Labels and icons length must match");

    return Obx(
          () => Card(
        color: AppColor.black,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColor.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(labels.length, (index) {
              final isSelected = selectedIndex.value == index;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      icons[index],
                      height: getSize(20, isHeight: true),
                      width: getSize(30),
                      color: isSelected ? AppColor.yellow : Colors.white,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: Get.width / labels.length - 10, // even spacing
                      child: Text(
                        labels[index].toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? AppColor.yellow : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: getSize(9, isFont: true),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Container(color: AppColor.white,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColor.primary, // Gray color from the image
          borderRadius: BorderRadius.circular(18), // Oval shape
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            items(
              'HOME',
              "assets/icons/home.png",
              // Icons.home_outlined,
              0,
              controller,
              isFirst: true, // Special styling for the first item
            ),
            items(
              'MY PROGRESS',
              "assets/icons/work-in-progress.png",
              // Icons.access_time_outlined,
              1,
              controller,
            ),
            items(
              'TESTIMONIAL',
              "assets/icons/feedback.png",
              2,
              controller,
            ),
            items(
              'LIVE SECTION',
              "assets/icons/live-streaming.png",
              3,
              controller,
            ),
            items(
              'MORE',
              "assets/icons/moreee.png",
              4,
              controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget items(
      String label,
      dynamic icon,
      int index,
      BottomNavController controller, {
        bool isFirst = false,
      }) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final itemColor = isSelected ? Colors.black : AppColor.blackColor;
      final backgroundColor = isSelected ? Color(0xFFFFCC00) : Colors.transparent;

      return Expanded(
        child: GestureDetector(
          onTap: () => controller.changeIndex(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 1),
            decoration: /*isFirst
                ?*/ BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
            )
                /*: null*/,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon is IconData?Icon(icon, color: itemColor, size: 24):Image.asset(icon,height: 25,width: 25),
                SizedBox(height: 4),
                AppText(
                  label,
                  color: itemColor,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
