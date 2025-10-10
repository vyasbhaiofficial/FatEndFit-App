class QuestionModel {
  final String id;
  final String videoId;
  final String question;
  final String correctAnswer;
  final int type;

  QuestionModel({
    required this.id,
    required this.videoId,
    required this.question,
    required this.correctAnswer,
    required this.type,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["_id"] ?? "",
      videoId: json["videoId"] ?? "",
      question: json["questionText"] ?? "",
      correctAnswer: json["correctAnswer"] ?? "",
      type: json["type"] ?? 0,
    );
  }
}
