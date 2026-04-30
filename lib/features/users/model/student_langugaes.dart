class StudentLanguageModel {
  int? idx;
  int? id;
  DateTime? createdAt;
  String? language;

  StudentLanguageModel({
    this.idx,
    this.id,
    this.createdAt,
    this.language,
  });

  StudentLanguageModel.fromJson(Map<String, dynamic> json) {
    idx = json['idx'];
    id = json['id'];
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'language': language,
    };
  }
}
