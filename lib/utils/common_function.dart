import 'package:fat_end_fit/service/api_config.dart';
import 'package:fat_end_fit/service/api_service.dart';
import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'app_images.dart';
// import 'package:webview_flutter/webview_flutter.dart';

double getSize(double value, {bool isHeight = false, bool isFont = false}) {
  if (isFont) {
    return (Get.width / 375.0) * value; // font base on width
  } else if (isHeight) {
    return (Get.height / 812.0) * value; // height responsive
  } else {
    return (Get.width / 375.0) * value; // width responsive
  }
}

String getImageUrl(String? path) {
  if (path == null || path.isEmpty) {
    return "https://t3.ftcdn.net/jpg/06/43/97/08/360_F_643970869_qYWnzzuznbMO7TaymQirwMnQ5fiQHZbu.jpg"; // 🔗 fallback image
  }

  String cleanPath = path.trim();

// agar path already http thi start thay to direct return kari de
  if (cleanPath.startsWith("http")) {
    return cleanPath;
  }

// Agar path ma starting ma `/` hoy to remove kari de
  if (cleanPath.startsWith("/")) {
    cleanPath = cleanPath.substring(1);
  }

  return "${ApiConfig.baseUrl}/$cleanPath";
}



class UrlGenerator {

  /// Get Uploaded File URL
  static Future<String?> getUrl(String filePath,
      {void Function(int, int)? onSendProgress}) async {
    try {
      final response = await AppApi.getInstance().uploadFile<Map<String, dynamic>>(
        ApiConfig.generateUrl,
        filePath,
        fieldName: 'image',
        onSendProgress: (count, total) {
          if(onSendProgress != null) onSendProgress(count, total);
        },
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        AppLogs.log("✅ URL generated successfully: ${data['data']}");
        return data['data'];
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Error while generating URL: $e");
      return null;
    }
  }
}

class CommonHtmlViewer extends StatelessWidget {
  final String htmlContent;

  const CommonHtmlViewer({Key? key, required this.htmlContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Html(
        data: htmlContent,
        style: {
          "p": Style(
            fontSize: FontSize(16),
            color: Colors.black87,
          ),
          "h2": Style(
            fontSize: FontSize(22),
            fontWeight: FontWeight.bold,
            margin: Margins.only(bottom: 12),
          ),
          "b": Style(fontWeight: FontWeight.bold),
          "i": Style(fontStyle: FontStyle.italic),
        },
      ),
    );
  }
}
// class WebViewControllerX extends GetxController {
//   final isLoading = true.obs; // 🔄 loading initially true
//   late final WebViewController webViewController;
//
//   WebViewControllerX(String url) {
//     webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..enableZoom(false)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (_) {
//             isLoading.value = true;
//           },
//           onPageFinished: (_) {
//             isLoading.value = false;
//           },
//           onWebResourceError: (_) {
//             isLoading.value = false; // error case ma bhi loader hide
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(url));
//   }
// }
//
// class CustomWebViewScreen extends StatelessWidget {
//   final String url;
//
//   const CustomWebViewScreen({
//     Key? key,
//     required this.url,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(WebViewControllerX(url));
//
//     return Stack(
//       children: [
//         Obx(() => controller.isLoading.value?SizedBox():WebViewWidget(controller: controller.webViewController)),
//         Obx(() => controller.isLoading.value
//             ? const Center(child: AppLoaderWidget())
//             : const SizedBox()),
//       ],
//     );
//   }
// }


class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({
    super.key,
    this.width = 120,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImages.fatEndFitIcon,
      width: getSize(width),
      height: getSize(height),
    );
  }
}

