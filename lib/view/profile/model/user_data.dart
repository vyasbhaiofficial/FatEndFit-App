class UserResponse {
  final bool success;
  final String message;
  final UserData? data;

  UserResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class UserData {
  final String id;
  final String name;
  final String surname;
  final int patientId;
  final String mobilePrefix;
  final String mobileNumber;
  final String gender;
  final int age;
  final int height;
  final int weight;
  final String language;
  final String medicalDescription;
  final String image;
  final String fcmToken;
  final String city;
  final String state;
  final String country;
  final String appReferer;
  final String plan;
  final String branch;
  final bool activated;
  final bool isDeleted;
  final bool isBlocked;
  final String createdAt;
  final String updatedAt;
  final String planCurrentDate;
  final int planCurrentDay;
  final String? planHoldDate;
  final String planResumeDate;
  final bool isProfileUpdated;

  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.patientId,
    required this.mobilePrefix,
    required this.mobileNumber,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.language,
    required this.medicalDescription,
    required this.image,
    required this.fcmToken,
    required this.city,
    required this.state,
    required this.country,
    required this.appReferer,
    required this.plan,
    required this.branch,
    required this.activated,
    required this.isDeleted,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
    required this.planCurrentDate,
    required this.planCurrentDay,
    required this.planHoldDate,
    required this.planResumeDate,
    required this.isProfileUpdated,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return UserData(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      surname: json['surname'] ?? "",
      patientId: _parseInt(json['patientId']),
      mobilePrefix: json['mobilePrefix'] ?? "",
      mobileNumber: json['mobileNumber'] ?? "",
      gender: json['gender'] ?? "",
      age: _parseInt(json['age']),
      height: _parseInt(json['height']),
      weight: _parseInt(json['weight']),
      language: json['language'] ?? "",
      medicalDescription: json['medicalDescription'] ?? "",
      image: json['image'] ?? "",
      fcmToken: json['fcmToken'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      country: json['country'] ?? "",
      appReferer: json['appReferer'] ?? "",
      plan: json['plan'] ?? "",
      branch: json['branch'] ?? "",
      activated: json['activated'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      planCurrentDate: json['planCurrentDate'] ?? "",
      planCurrentDay: _parseInt(json['planCurrentDay']),
      planHoldDate: json['planHoldDate'],
      planResumeDate: json['planResumeDate'] ?? "",
      isProfileUpdated: json['isProfileUpdated'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "surname": surname,
      "patientId": patientId,
      "mobilePrefix": mobilePrefix,
      "mobileNumber": mobileNumber,
      "gender": gender,
      "age": age,
      "height": height,
      "weight": weight,
      "language": language,
      "medicalDescription": medicalDescription,
      "image": image,
      "fcmToken": fcmToken,
      "city": city,
      "state": state,
      "country": country,
      "appReferer": appReferer,
      "plan": plan,
      "branch": branch,
      "activated": activated,
      "isDeleted": isDeleted,
      "isBlocked": isBlocked,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "planCurrentDate": planCurrentDate,
      "planCurrentDay": planCurrentDay,
      "planHoldDate": planHoldDate,
      "planResumeDate": planResumeDate,
      "isProfileUpdated": isProfileUpdated,
    };
  }
}
