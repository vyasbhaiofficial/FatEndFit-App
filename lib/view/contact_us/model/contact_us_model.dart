class ContactUsModel {
  final String title;
  final String fullAddress;
  final String email;
  final String mobile;
  final String latitude;
  final String longitude;

  ContactUsModel({
    required this.title,
    required this.fullAddress,
    required this.email,
    required this.mobile,
    required this.latitude,
    required this.longitude,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      title: json['title'] ?? "",
      fullAddress: json['fullAddress'] ?? "",
      email: json['email'] ?? "",
      mobile: json['mobile'] ?? "",
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fullAddress': fullAddress,
      'email': email,
      'mobile': mobile,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
