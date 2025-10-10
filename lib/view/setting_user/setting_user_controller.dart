import 'package:get/get.dart';
import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_print.dart';
import 'model/setting_user_responce.dart';
import 'package:html/parser.dart' as html_parser;

class AppSettingController extends GetxController {
  var isLoading = false.obs;
  var setting = Rxn<AppSettingModel>();

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;

      final response = await AppApi.getInstance().get(ApiConfig.getUserSettings);
      AppLogs.log("API Response: ${response.data}", tag: "APP_SETTING");

      if (response.success && response.data != null) {
        // 🔹 Pick inner "data" map
        final json = response.data["data"];
        if (json != null) {
          setting.value = AppSettingModel.fromJson(json);
          AppLogs.log(
            "Parsed setting [appActive ?]: ${setting.value?.appActive}",
            tag: "APP_SETTING",
          );
        }
      } else {
        AppLogs.log("Failed to fetch settings: $response", tag: "APP_SETTING");
      }
    } catch (e, s) {
      AppLogs.log("Error: $e\n$s", tag: "APP_SETTING");
    } finally {
      isLoading.value = false;
    }
  }

}

class HtmlUtils {
  static String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? "";
  }
}
