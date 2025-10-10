import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_print.dart';
import '../../utils/app_strings.dart';
import '../../utils/common/app_common_back_button.dart';
import '../../utils/common/app_text.dart';
import 'contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactUsController());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: backButton(),
        centerTitle: true,
        title: AppText(
          AppString.contactUs,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.textBlack,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: AppLoaderWidget());
          }
          final data = controller.contactUs.value;
          if (data == null) {
            return const Center(child: Text("No data found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map Image Placeholder
                Container(decoration: BoxDecoration(border: Border.all(width: 1.5,color: AppColor.black),borderRadius: BorderRadius.circular(12)),child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppImage.network("https://www.thegogame.com/hubfs/locations/gujarat%3Bsurat.jpeg",enableCaching: true,width: Get.width,height: Get.height * 0.25))),
                const SizedBox(height: 20),

                // Hotel Info
                // AppText(
                //   "Darshan Hotel",
                //   fontSize: 18,
                //   fontWeight: FontWeight.bold,
                //   color: AppColor.textBlack,
                // ),
                AppText(
                  data.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textBlack,
                ),
                const SizedBox(height: 5),

                // ContactInfoCard(
                //   icon: Icons.location_on_outlined,
                //   text:
                //   "6VCG+9FF, Varachha Main Rd, Mamata Park Society-1, Varachha, Surat, Gujarat 395006",
                //   onTap: () {
                //     Get.snackbar("Location", "Opening Google Maps...");
                //   },
                // ),
                AddressInfoCard(
                  icon: Icons.location_on_outlined,
                  address: data.fullAddress,
                  onTap: () {
                    // Open Google Maps
                    final url =
                        "https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}";
                    AppLogs.log("Opening Map: $url");
                  },
                ),

                const SizedBox(height: 20),

                // Contact Info
                AppText(
                  "Contact info",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textBlack,
                ),
                const SizedBox(height: 12),

                // ContactInfoCard(
                //   icon: Icons.phone,
                //   text: "+91 99999 99999",
                //   onTap: () {
                //     // Get.snackbar("Phone", "Dialing...");
                //   },
                // ),
                // const SizedBox(height: 12),
                // ContactInfoCard(
                //   icon: Icons.email_outlined,
                //   text: "Contact@developer.com",
                //   onTap: () {
                //     // Get.snackbar("Email", "Opening mail app...");
                //   },
                // ),
                if (data.mobile.isNotEmpty)
                  ContactInfoCard(
                    icon: Icons.phone,
                    text: data.mobile,
                    onTap: () {
                      // Launch dialer
                    },
                  ),
                const SizedBox(height: 12),

                if (data.email.isNotEmpty)
                  ContactInfoCard(
                    icon: Icons.email_outlined,
                    text: data.email,
                    onTap: () {
                      // Launch mail
                    },
                  ),
              ],
            ),
          );
        },),
      ),
    );
  }
}
class AddressInfoCard extends StatelessWidget {
  final IconData icon;
  final String address;
  final VoidCallback onTap;

  const AddressInfoCard({
    super.key,
    required this.icon,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage.asset("assets/icons/location.png",height: 45,width: 36,fit: BoxFit.fill),
            const SizedBox(width: 10),
            Expanded(
              child: AppText(
                address,
                // style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
                // ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Common Contact Info Card
// class ContactInfoCard extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback onTap;
//
//   const ContactInfoCard({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(25),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: AppColor.yellow,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColor.black),
//             const SizedBox(width: 10),
//             Expanded(
//               child: AppText(
//                 text,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColor.black,
//                 maxLines: 4,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContactInfoCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        height: 60,

        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            // 🔹 Left black part with icon
            Container(
              width: 50,
              decoration: const BoxDecoration(
                color: AppColor.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(icon, color: Colors.white),
              ),
            ),

            // 🔹 Right yellow part with text
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.yellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                alignment: Alignment.centerLeft,
                child: AppText(
                  text,
                  // style: const TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
