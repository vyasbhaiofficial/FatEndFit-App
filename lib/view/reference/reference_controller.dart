import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../service/api_config.dart';
import '../../service/api_service.dart';
import '../../utils/app_loader.dart';
import '../../utils/app_print.dart';
import 'model/reference_model.dart';


class ReferenceController extends GetxController {
  var isLoading = false.obs;
  var countryCode = "+91".obs;

  final Map<String, int> phoneLengthByCountry = {
    '+91': 10, // India
    '+1': 10,  // US/Canada
    '+86': 11, // China
    '+49': 11, // Germany
    '+55': 11, // Brazil
    '+65': 8,  // Singapore
    '+81': 10, // Japan
    '+44': 10, // UK
    '+33': 9,  // France
    '+61': 9,  // Australia
  };

  Future<void> createReference({
    required String name,
    required String mobile,
    required String relation,
  }) async {
    try {
      AppLoader.show();
      isLoading.value = true;

      final response = await AppApi.getInstance().post(
        ApiConfig.createUserReference,
        data: {
          "name": name,
          "mobile": countryCode + mobile,
          "relation": relation,
        },
      );

      if (response.success == true) {
        AppLogs.log("✅ Reference Created: ${response.data}");
        AppToast.show("Reference added successfully!");
      } else {
        AppToast.show("Failed to add reference");
      }
    } catch (e) {
      AppLogs.log("❌ Error creating reference: $e");
      AppToast.show("Something went wrong");
    } finally {
      AppLoader.hide();
      isLoading.value = false;
    }
  }

  var references = <ReferenceModel>[].obs;
  var isLoadingRef = false.obs;


  Future<void> fetchReferences() async {
    try {
      isLoadingRef.value = true;

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   AppLoader.show();
      // });

      final response = await AppApi.getInstance().get(ApiConfig.referenceList);

      if (response.success == true && response.data != null) {
        final List<dynamic> data = response.data["data"];
        references.assignAll(
          data.map((e) => ReferenceModel.fromJson(e)).toList(),
        );
        AppLogs.log("✅ References fetched: ${references.length}");
      } else {
        AppLogs.log("❌ Failed to fetch references");
      }
    } catch (e) {
      AppLogs.log("❌ Error fetching references: $e");
    } finally {
      // AppLoader.hide();
      isLoadingRef.value = false;
    }
  }

}
