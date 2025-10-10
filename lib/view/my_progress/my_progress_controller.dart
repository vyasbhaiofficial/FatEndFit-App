import 'package:fat_end_fit/utils/app_navigation.dart';
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:fat_end_fit/utils/app_toast.dart';
import 'package:get/get.dart';

import '../edit_program/edit_program_screen.dart';

class MyProgressController extends GetxController {
  // Example: list of days
  var days = List.generate(4, (index) => "${AppString.day} - ${index + 1}").obs;

  void onEditProgress(String day) {
    Get.to(()=>EditProgramScreen(day: day,));
   // AppToast.success("This Future Currently Not Available.");
  }
}