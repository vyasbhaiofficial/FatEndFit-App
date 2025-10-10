import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/app_color.dart';

class OtpInputWidget extends StatelessWidget {
  final int length;
  final Function(String)? onCompleted;

  const OtpInputWidget({
    super.key,
    this.length = 4,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: Get.width * 0.06,left: Get.width * 0.06),
      child: PinCodeTextField(
        appContext: context,
        length: length,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        textStyle: const TextStyle(
          color: AppColor.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),cursorColor: AppColor.primary,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: 55,
          fieldWidth: 55,
          borderRadius: BorderRadius.circular(12),
          activeColor: AppColor.primary,
          selectedColor: AppColor.primary,
          inactiveColor: AppColor.primary,
          activeFillColor: AppColor.lightGrey,
          selectedFillColor: AppColor.lightGrey,
          inactiveFillColor: AppColor.lightGrey,
        ),
        enableActiveFill: true,
        onChanged: (value) {},
        onCompleted: onCompleted,
      ),
    );
  }
}