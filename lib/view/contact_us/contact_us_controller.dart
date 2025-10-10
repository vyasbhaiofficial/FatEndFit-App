import 'dart:convert';

import 'package:get/get.dart';

import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_print.dart';
import '../../utils/app_storage.dart';
import 'model/contact_us_model.dart';

class ContactUsController extends GetxController {
  var contactUs = Rxn<ContactUsModel>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage(); // first load old saved data
    fetchContactUs();   // then call API to refresh
  }

  /// Load saved data from local storage
  Future<void> _loadFromStorage() async {
    try {
      final savedJson = await AppStorage().read<String>("contactUs");
      if (savedJson != null && savedJson.isNotEmpty) {
        contactUs.value = ContactUsModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(savedJson)),
        );
        isLoading.value = false; // show old data while API loading
      }
    } catch (e) {
      AppLogs.log("❌ Error loading saved ContactUs: $e");
    }
  }

  /// Fetch fresh data from API
  Future<void> fetchContactUs() async {
    isLoading.value = true;
    final result = await getContactUs();

    if (result != null) {
      contactUs.value = result;
      // Save latest response to local storage
      await AppStorage().save(
        "contactUs",
        jsonEncode(result.toJson()),
      );
    }

    isLoading.value = false;
  }

  /// Call API and parse response
  Future<ContactUsModel?> getContactUs() async {
    try {
      final response = await AppApi.getInstance().get(ApiConfig.contactUs);

      if (response.success == true && response.data != null) {
        final data = response.data['data'];
        return ContactUsModel.fromJson(data);
      }
      return null;
    } catch (e) {
      AppLogs.log("❌ ContactUs error: $e");
      return null;
    }
  }
}

