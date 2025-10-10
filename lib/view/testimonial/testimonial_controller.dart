import 'package:fat_end_fit/service/api_config.dart';
import 'package:fat_end_fit/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_print.dart';
import 'model/testmonial_model.dart';

// class TestimonialController extends GetxController {
//   var testimonials = List.generate(3, (index) => "Detox for Life").obs;
// }
class TestimonialController extends GetxController {
  final AppApi _apiService = AppApi.getInstance(); // your api service
  var isLoading = false.obs;
  var testimonial = Rxn<TestimonialResponse>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchTestimonials();
  // }

  Future<void> fetchTestimonials() async {
    try {
      isLoading(true);

      final response = await _apiService.get<Map<String, dynamic>>(
        ApiConfig.getTestimonial,
      );

      if (response.success && response.data != null) {
        AppLogs.log('Testimonials fetched DATA: ${response.data}',
            tag: 'TESTIMONIAL', color: Colors.green);
        testimonial.value = TestimonialResponse.fromJson(response.data?['data']);

        AppLogs.log('Testimonials fetched successfully = ${testimonial.value?.titleVideo}',
            tag: 'TESTIMONIAL', color: Colors.green);
      } else {
        AppLogs.log('Failed to fetch testimonials: ${response.message}',
            tag: 'TESTIMONIAL', color: Colors.red);
      }
    } catch (e) {
      AppLogs.log('Error fetching testimonials: $e',
          tag: 'TESTIMONIAL', color: Colors.red);
    } finally {
      isLoading(false);
    }
  }
}
