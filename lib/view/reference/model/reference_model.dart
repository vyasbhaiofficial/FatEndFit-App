class ReferenceModel {
  final String id;
  final String name;
  final String mobile;
  final String relation;

  ReferenceModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.relation,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      relation: json["relation"] ?? "",
    );
  }
}
