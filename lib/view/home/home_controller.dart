import 'package:fat_end_fit/service/api_service.dart';
import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/view/home/widget/resume_video.dart';
import 'package:fat_end_fit/view/profile/profile_controller.dart';
import 'package:get/get.dart';

import '../../service/api_config.dart';
import '../../utils/app_print.dart';
import '../../utils/app_toast.dart';
import '../program_video/program_video_controller.dart';
import '../program_video/program_video_details/program_video_details_controller.dart';
import '../setting_user/setting_user_controller.dart';
import 'model/home_model.dart';
// Progress List (static for now)
final List<Map<String, dynamic>> progressList = [
  {
    "day": "04",
    "percentage": 50,
    "image":
    "https://centerforfamilymedicine.com/wp-content/uploads/2020/06/Center-for-family-medicine-The-Health-Benefits-of-Eating-10-Servings-Of-Fruits-_-Veggies-Per-Day.jpg"
  },
  {"day": "03", "percentage": 100,
    "image":
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ90v8a1FW5pvDBoUOzxZBR_zioYNixl74qPA&s"
  },
  {"day": "02", "percentage": 100,
    "image":
    "https://i.insider.com/5fff4992fe7e140019f7ec01?width=1200&format=jpeg"
  },
  {"day": "01", "percentage": 100,
    "image":
    "https://shreediagnostics.com/wp-content/uploads/2023/03/Blog-Post-2.webp"
  },
  {"day": "00", "percentage": 100,
    "image":
    "https://images.contentstack.io/v3/assets/blt8a393bb3b76c0ede/blt75d0470ec717b719/65ecf2e8f283f74af8285fd4/healthy-eating-header.jpg"
  },
];
class HomeController extends GetxController {
  // Profile Info
  var userName = "User".obs;
  var profileImage = "https://cdn.vectorstock.com/i/1000v/72/44/bodybuilder-logo-icon-on-white-background-vector-18167244.jpg".obs;
  var currentDay = 1.obs;

  // Program Hold
  var isProgramHold = false.obs;

  var isLoading = true.obs;


  var homeProgressData = Rxn<HomeProgressData>();

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      final response = await AppApi.getInstance().get<Map<String, dynamic>>(ApiConfig.getFirstPageDayWiseProgress);
      AppLogs.log("[ fetchHomeData ] GET RESPONSE-----${response.success}->${response.data}", tag:"FETCH HOME DATA");

      if (response.success && response.data != null) {
        final homeData = HomeProgressResponse.fromJson(response.data!);

        /// Store data in observable
        homeProgressData.value = homeData.data;
        AppLogs.log("homeData.data?.isHold------>${homeData.data?.isHold}", tag:"HOLD");
        isProgramHold.value = homeData.data?.isHold ?? true;
        currentDay.value = homeData.data?.progress.first.day ?? 1;
        /// Optional: Save in storage (if needed)
        // AppStorage.save("homeData", userResponse.data?.toJson());
      } else {
        // AppToast.error(response.message ?? "Failed to fetch progress");
      }
    } catch (e) {
      // AppToast.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // For Hold & Resume Current Program
  Future<void> holdOrResumePlan({
    required String planId,
    required int type, // 1 = Hold, 2 = Resume
    bool showDialog = false
  }) async {
    try {
      AppSettingController settingController = Get.find();
      if(type == 2 && showDialog){
        final ProfileDetailsController programVideoCon = Get.put(ProfileDetailsController("video_type_$type"));
        final result = showResumeVideoDialog(thumbnailUrl: "", planId: planId,videoCtrl: programVideoCon, videoUrl: settingController.setting.value?.resumeVideoLink ?? 'https://cdn.pixabay.com/video/2024/03/08/203449-921267347_tiny.mp4');
        return;
      }
      
      AppLoader.show();
      final queryParams = {
        "planId": planId,
        "type": type.toString(),
      };

      final response = await AppApi.getInstance().post<Map<String, dynamic>>(
        ApiConfig.planHoldResume,
        queryParameters: queryParams,
      );

      if (response.success) {
        if(response.data?['message'] != null &&  response.data?['message'] == "Plan resume successfully"){
           isProgramHold.value = false;
        }else if (response.data?['message'] != null && response.data?['message'] == "Plan hold successfully"){
           isProgramHold.value = true;
        }
        AppLoader.hide();
        AppLogs.log(
          "✅ Plan action success: planId=$planId type=$type → ${response.data}",
          tag: "HOLD_RESUME_PLAN",
        );
      } else {
        AppLoader.hide();

        AppLogs.log(
          "❌ Plan action failed: ${response.message}",
          tag: "HOLD_RESUME_PLAN",
        );
      }
    } catch (e) {
      AppLoader.hide();
      AppLogs.log("🔥 Exception in holdOrResumePlan: $e",
          tag: "HOLD_RESUME_PLAN");
    }
  }


}
// String? getThumbnailForLanguage(DayProgress progress) {
//   try {
//     final profileController = Get.find<ProfileController>();
//     final lang = profileController.user.value?.language.toLowerCase() ?? "english";
//
//     if (progress.firstThumbnail == null) return null;
//
//     switch (lang) {
//       case "hindi":
//         return progress.firstThumbnail?.hindi;
//       case "gujarati":
//       // case "gujarati": // spelling fix
//         return progress.firstThumbnail?.gujarati;
//       case "english":
//       default:
//         return progress.firstThumbnail?.english;
//     }
//   } catch (e) {
//     return null;
//   }
// }
