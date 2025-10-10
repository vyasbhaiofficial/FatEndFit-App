class ApiConfig {
  //https://fatendfit.codestoreapp.com/
  static const String scheme = "https://";
  // static const String host = "192.168.1.13";
  // static const String host = "fatendfit.codestoreapp.com";
  static const String host = "backend.fatendfit.com";
  // static const String port = ":3002";
  static const String port = "";
  static const String centerPart = "/api/v1";
  // static const String baseUrl = "$host:$port/api/v1";
  static const String baseUrl = scheme + host + port + centerPart;

  // All API Endpoints
  static const String login = "$baseUrl/auth/user/login";
  static const String userUpdate = "$baseUrl/user/update";
  static const String getUser = "$baseUrl/user/get";
  static const String getFirstPageDayWiseProgress = "$baseUrl/user/getFirstPageDayWiseProgress";
  static const String updateToken = "$baseUrl/user/updateFcmToken";
  static const String getProgramVideos = "$baseUrl/user/video/get";
  static const String generateUrl = "$baseUrl/user/other/generateUrl";
  static const String videoProgress = "$baseUrl/user/videoProgress/update";
  static const String getUserSettings = "$baseUrl/user/setting/get";
  static const String planHoldResume = "$baseUrl/user/plan/hold-resume";
  static const String getQuestions = "$baseUrl/user/question/get";
  static const String getDailyQuestions = "$baseUrl/user/question/get-daily";
  static const String submitDailyReports = "$baseUrl/user/useranswer/submit-daily-report";
  static const String refreshToken = "$baseUrl/auth/user/refresh-token";
  static const String getTestimonial = "$baseUrl/user/testimonial/get-testimonial";
  static const String contactUs = "$baseUrl/user/other/contactUs";
  static const String createUserReference = "$baseUrl/user/reference/create";
  static const String referenceList = "$baseUrl/user/reference/list";
  static const String userAnswerSubmit = "$baseUrl/user/useranswer/submit";
}
