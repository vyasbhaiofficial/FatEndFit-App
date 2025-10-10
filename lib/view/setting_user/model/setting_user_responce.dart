// class UserSettingResponse {
//   final bool success;
//   final UserSettingData? data;
//
//   UserSettingResponse({
//     required this.success,
//     this.data,
//   });
//
//   factory UserSettingResponse.fromJson(Map<String, dynamic> json) {
//     return UserSettingResponse(
//       success: json['success'] ?? false,
//       data: json['data'] != null ? UserSettingData.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'data': data?.toJson(),
//     };
//   }
// }
//
// class UserSettingData {
//   final String id;
//   final String privacyPolicyLink;
//   final String termsAndConditionsLink;
//   final bool appActive;
//   final int version;
//   final String aboutUs;
//   final String createdAt;
//   final String updatedAt;
//   final int v;
//
//   UserSettingData({
//     required this.id,
//     required this.privacyPolicyLink,
//     required this.termsAndConditionsLink,
//     required this.appActive,
//     required this.version,
//     required this.aboutUs,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory UserSettingData.fromJson(Map<String, dynamic> json) {
//     return UserSettingData(
//       id: json['_id'] ?? '',
//       privacyPolicyLink: json['privacyPolicyLink'] ?? '',
//       termsAndConditionsLink: json['termsAndConditionsLink'] ?? '',
//       appActive: json['appActive'] ?? false,
//       version: json['version'] ?? 0,
//       aboutUs: json['aboutUs'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       v: json['__v'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'privacyPolicyLink': privacyPolicyLink,
//       'termsAndConditionsLink': termsAndConditionsLink,
//       'appActive': appActive,
//       'version': version,
//       'aboutUs': aboutUs,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       '__v': v,
//     };
//   }
// }

// class AppSettingModel {
//   final String id;
//   final String privacyPolicyLink;
//   final String termsAndConditionsLink;
//   final bool appActive;
//   final int version;
//   final String aboutUs;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//
//   AppSettingModel({
//     required this.id,
//     required this.privacyPolicyLink,
//     required this.termsAndConditionsLink,
//     required this.appActive,
//     required this.version,
//     required this.aboutUs,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory AppSettingModel.fromJson(Map<String, dynamic> json) {
//     return AppSettingModel(
//       id: json["_id"] ?? "",
//       privacyPolicyLink: json["privacyPolicyLink"] ?? "",
//       termsAndConditionsLink: json["termsAndConditionsLink"] ?? "",
//       appActive: json["appActive"] ?? false,
//       version: json["version"] ?? 0,
//       aboutUs: json["aboutUs"] ?? "",
//       createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
//       v: json["__v"] ?? 0,
//     );
//   }
// }
class AppSettingModel {
  final String id;
  final String privacyPolicyLink;
  final String termsAndConditionsLink;
  final bool appActive;
  final int version;
  final String aboutUs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String privacyPolicy;
  final String termsAndConditions;
  final String resumeVideoLink;

  AppSettingModel({
    required this.id,
    required this.privacyPolicyLink,
    required this.termsAndConditionsLink,
    required this.appActive,
    required this.version,
    required this.aboutUs,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.privacyPolicy,
    required this.termsAndConditions,
    this.resumeVideoLink = '',
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      id: json["_id"] ?? "",
      privacyPolicyLink: json["privacyPolicyLink"] ?? "",
      termsAndConditionsLink: json["termsAndConditionsLink"] ?? "",
      appActive: json["appActive"] ?? false,
      version: json["version"] ?? 0,
      aboutUs: json["aboutUs"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      v: json["__v"] ?? 0,
      privacyPolicy: json["privacyPolicy"] ?? "",
      termsAndConditions: json["termsAndConditions"] ?? "",
      resumeVideoLink: json["resumeLink"] ?? "https://cdn.pixabay.com/video/2024/03/08/203449-921267347_tiny.mp4",
    );
  }
}
