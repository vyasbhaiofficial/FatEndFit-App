import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/view/profile/profile_screen.dart';
import 'package:fat_end_fit/view/reference/reference_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_text.dart';
import '../about_us/widget/common_header.dart';

class MyReferenceScreen extends StatefulWidget {
  const MyReferenceScreen({super.key});

  @override
  State<MyReferenceScreen> createState() => _MyReferenceScreenState();
}

class _MyReferenceScreenState extends State<MyReferenceScreen> {
  ReferenceController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchReferences();
  }

  @override
  Widget build(BuildContext context) {
    // final references = [
    //   {"name": "Madison Smith", "mobile": "+91 98653 25154"},
    //   {"name": "Madison Smith", "mobile": "+91 98653 25154"},
    //   {"name": "Madison Smith", "mobile": "+91 98653 25154"},
    // ];

    // return Scaffold(
    //   backgroundColor: AppColor.white,
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         children: [
    //           CommonHeader(title: AppString.myReference),
    //           const SizedBox(height: 20),
    //           Expanded(
    //             child: ListView.separated(
    //               itemCount: references.length,
    //               separatorBuilder: (_, __) => const SizedBox(height: 12),
    //               itemBuilder: (context, index) {
    //                 final item = references[index];
    //                 return Container(
    //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //                   decoration: BoxDecoration(
    //                     color: AppColor.yellow,
    //                     border: Border.all(color: AppColor.black,width: 1.5),
    //                     borderRadius: BorderRadius.circular(32),
    //                   ),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       AppText(
    //                         "${item["name"]}\n${item["mobile"]}",
    //                         fontSize: 14,
    //                         color: AppColor.black,
    //                       ),
    //                       Container(
    //                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                         decoration: BoxDecoration(
    //                           color: AppColor.black,
    //                           borderRadius: BorderRadius.circular(20),
    //                         ),
    //                         child: AppText(
    //                           AppString.relation,
    //                           fontSize: 12,
    //                           fontWeight: FontWeight.bold,
    //                           color: AppColor.white,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 );
    //               },
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CommonHeader(title: AppString.myReference),
              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoadingRef.value) {
                  return Expanded(child: const Center(child: AppLoaderWidget()));
                }

                if (controller.references.isEmpty) {
                  return const Center(child: Text("No references found"));
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: controller.references.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.references[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          // border: Border.all(color: AppColor.black, width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 7,
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    item.name,
                                    fontSize: 14,
                                    color: AppColor.textBlack,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  AppText(
                                    formatMobile(item.mobile,""),
                                    fontSize: 14,
                                    color: AppColor.textBlack,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColor.yellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  "Relation",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textBlack,
                                  maxLines: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
