import 'package:fat_end_fit/utils/app_color.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget backButton({bool autoBack = true,VoidCallback? onTap, double? marginLeft, double? marginTop, double? marginBottom, double? marginRight,double? height, double? width}) {
  return GestureDetector(onTap: () {
    if(autoBack) Get.back();
    if(onTap != null) onTap();
  },
    child: Container(
      height: 32,width: 32,
      margin: EdgeInsets.only(left: marginLeft ?? 16, top: marginTop ?? 5, bottom: marginBottom ?? 10,right: marginRight ?? 0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
       border: Border.all(color: AppColor.black)
      ),
      child: Icon(Icons.arrow_back_ios_new, size: 18,color: AppColor.black,),
    ),
  );
}