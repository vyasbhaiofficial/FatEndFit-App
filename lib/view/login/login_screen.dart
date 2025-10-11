// import 'package:fat_end_fit/utils/app_strings.dart';
// import 'package:fat_end_fit/utils/common/app_textfield.dart';
// import 'package:fat_end_fit/view/login/widget/otp_input_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../utils/app_color.dart';
// import '../../utils/app_text_style.dart';
// import '../../utils/common/app_button_v1.dart';
// import '../../utils/common/app_video.dart';
// import '../../utils/common_function.dart';
// import 'login_controller.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//
//   final LoginController controller = Get.put(LoginController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AppLogo(height: 67,width: Get.width - 80,),
//               const SizedBox(height: 12),
//               Text(
//                 AppString.startYourBodyJourney,
//                 style: AppTextStyle.heading1,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//
//               // Mobile input (only if OTP not yet sent)
//               Obx(
//                     () =>
//                 (controller.isOtpSent.value == false)
//                     ? TextField(
//                   cursorColor: AppColor.yellow,
//                   keyboardType: TextInputType.number,
//                   maxLength: 10,
//                   onChanged:
//                       (val) => controller.mobileNumber.value = val,
//                   decoration: InputDecoration(
//                     hintText: AppString.enterMobileNumber,
//                     filled: true,
//                     fillColor: AppColor.black,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 16,
//                     ),
//                     hintStyle: const TextStyle(color: Colors.white70),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     counterText: '',
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 )
//                     : SizedBox.shrink(),
//               ),
//
//               // OTP input (only if OTP sent)
//               Obx(
//                     () =>
//                 controller.isOtpSent.value
//                     ? OtpInputWidget(
//                   length: 4,
//                   onCompleted: (otp) {
//                     controller.otp.value = otp;
//                   },
//                 )
//                     : SizedBox.shrink(),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Button
//               Obx(
//                     () => CommonButton(
//                   text: controller.isOtpSent.value
//                       ? AppString.verifyOtp
//                       : AppString.sendOtp,
//                   isLoading: controller.isLoading.value,
//                   onTap:
//                   controller.isOtpSent.value
//                       ? controller.verifyOtp
//                       : controller.sendOtp,
//                   showBorder: true,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                 ),
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../../utils/app_print.dart';
import '../../utils/app_text_style.dart';
import '../../utils/app_strings.dart';
// import '../../utils/common/app_logo.dart';
import '../../utils/common/app_button_v1.dart';
import '../../utils/common_function.dart';
import '../../view/login/widget/otp_input_widget.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.08,),
                /// Logo
                const AppLogo(width: 140, height: 60),
                const SizedBox(height: 16),

                /// Heading
                Text(
                  AppString.startYourBodyJourney,
                  style: AppTextStyle.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                /// Phone Input OR OTP Input
                Obx(() {
                  if (!controller.isOtpSent.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          AppString.enterMobileNumber + ":",
                          style: AppTextStyle.label,
                        ),
                        const SizedBox(height: 8),
                        // TextField(
                        //   cursorColor: AppColor.primary,
                        //   keyboardType: TextInputType.number,
                        //   maxLength: 10,
                        //   onChanged: (val) => controller.mobileNumber.value = val,
                        //   decoration: InputDecoration(
                        //     hintText: AppString.phoneNumber,
                        //     counterText: "",hintStyle: TextStyle(color: AppColor.primary,fontSize: 14),
                        //     filled: true,
                        //     fillColor: AppColor.lightGrey,
                        //     contentPadding: const EdgeInsets.symmetric(
                        //         horizontal: 22, vertical: 12),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(30),
                        //       borderSide:
                        //       const BorderSide(color: AppColor.borderGrey),
                        //     ),
                        //     disabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(30),
                        //       borderSide:
                        //       const BorderSide(color: AppColor.borderGrey),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(30),
                        //       borderSide:
                        //       const BorderSide(color: AppColor.black),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(30),
                        //       borderSide:
                        //       const BorderSide(color: AppColor.black),
                        //     ),
                        //   ),
                        // ),
                        Row(
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: AppColor.lightGrey,
                            //     borderRadius: BorderRadius.circular(30),
                            //     border: Border.all(color: AppColor.black),
                            //   ),
                            //   padding: const EdgeInsets.symmetric(horizontal: 5),
                            //   child: CountryCodePicker(
                            //     onChanged: (code) {
                            //       controller.countryCode.value = code.dialCode ?? "+91";
                            //     },
                            //     initialSelection: 'IN',
                            //     favorite: ['+91', 'IN'],
                            //     showCountryOnly: false,
                            //     showOnlyCountryWhenClosed: false,
                            //     alignLeft: false,
                            //     padding: EdgeInsets.zero,
                            //     textStyle: const TextStyle(
                            //       color: AppColor.primary,
                            //       fontSize: 14,
                            //     ),
                            //     showFlag: false, // hides flag — only show code like +91
                            //   ),
                            // ),
                            // const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                cursorColor: AppColor.primary,
                                keyboardType: TextInputType.number,
                                maxLength: controller.phoneLengthByCountry[controller.countryCode.value] ?? 12,
                                onChanged: (val) => controller.mobileNumber.value = val,
                                decoration: InputDecoration(
                                  prefixIcon: CountryCodePicker(
                                    onChanged: (code) {
                                      controller.countryCode.value = code.dialCode ?? "+91";
                                      AppLogs.log("Selected country code: ${code.code}");
                                    },
                                    initialSelection: 'IN',
                                    favorite: ['+91', 'IN'],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    padding: EdgeInsets.zero,
                                    textStyle: const TextStyle(
                                      color: AppColor.primary,
                                      fontSize: 14,
                                    ),
                                    showFlag: false, // hides flag — only show code like +91
                                  ),
                                  hintText: AppString.phoneNumber,
                                  counterText: "",
                                  hintStyle: const TextStyle(color: AppColor.primary, fontSize: 14),
                                  filled: true,
                                  fillColor: AppColor.lightGrey,
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColor.borderGrey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColor.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColor.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppString.otpVerification,
                          style: AppTextStyle.heading2.copyWith(
                            color: AppColor.yellow,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // const SizedBox(height: 3),
                        Text(
                          AppString.otpDesc,
                          style: AppTextStyle.body.copyWith(fontSize: 11,color: AppColor.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        /// OTP boxes
                        OtpInputWidget(
                          length: 4,
                          onCompleted: (otp) => controller.otp.value = otp,
                        ),
                        const SizedBox(height: 16),

                        /// Timer
                        // Obx(() => Text(
                        //   "Remaining time: 00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}s",
                        //   style: AppTextStyle.body.copyWith(
                        //     color: AppColor.yellow,
                        //   ),
                        // )),
                        Obx(() {
                          final seconds = controller.remainingSeconds.value.toString().padLeft(2, '0');
                          return RichText(
                            text: TextSpan(
                              style: AppTextStyle.body, // base style (black)
                              children: [
                                const TextSpan(text: "Remaining time: "), // black by default
                                TextSpan(
                                  text: "00:${seconds}s",
                                  style: AppTextStyle.body.copyWith(color: AppColor.yellow), // yellow only here
                                ),
                                // const TextSpan(text: "s"), // again black
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),

                        /// Resend
                        GestureDetector(
                          onTap: controller.resendOtp,
                          child: GestureDetector(
                            onTap: controller.resendOtp,
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text: "Didn’t receive code? ", // 👈 normal black
                                    style: AppTextStyle.body.copyWith(color: AppColor.textBlack),
                                  ),
                                  TextSpan(
                                    text: "Resend", // 👈 highlighted primary color
                                    style: AppTextStyle.body.copyWith(color: AppColor.yellow),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ],
                    );
                  }
                }),

                const SizedBox(height: 20),

                Obx(() => controller.isOtpSent.value?SizedBox():Row(
                  children: [
                    Checkbox(
                      value: controller.isTermsAccepted.value,
                      onChanged: (val) => controller.isTermsAccepted.value = val ?? false,
                      activeColor: AppColor.primary,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I accept the ",
                          style: AppTextStyle.body.copyWith(color: AppColor.textBlack),
                          children: [
                            TextSpan(
                              text: "Terms & Conditions",
                              style: AppTextStyle.body.copyWith(
                                color: AppColor.primary,
                                decoration: TextDecoration.underline,
                              ),
                              // Optional: open T&C page
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Get.to(() => TermsAndConditionsScreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),

                /// Button(s)
                Obx(() {
                  if (!controller.isOtpSent.value) {
                    return CommonButton(
                      text: AppString.continueBtn,height: 55,
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (controller.mobileNumber.value.length != 10) {
                          AppToast.error("Please enter a valid mobile number");
                          return;
                        }
                        if (controller.isTermsAccepted.value) {
                          controller.sendOtp();
                        } else {
                          AppToast.show("Please accept the Terms & Conditions to continue");
                        }
                      },
                      buttonTextColor: AppColor.textWhite,
                      buttonColor: AppColor.primary,
                    );
                  } else {
                    return Column(
                      children: [
                        CommonButton(
                          buttonTextColor: AppColor.textWhite,
                          buttonColor: AppColor.primary,
                          text: AppString.verify,
                          isLoading: controller.isLoading.value,
                          onTap: controller.verifyOtp,
                        ),
                        const SizedBox(height: 12),
                        CommonButton(
                          buttonTextColor: AppColor.primary,
                          buttonColor: AppColor.textWhite,
                          text: AppString.cancel,
                          isOutlined: true,
                          onTap: controller.cancelOtp,
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
