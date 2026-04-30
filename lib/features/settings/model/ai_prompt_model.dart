class AiPrompt {
  final int? id;
  final DateTime? createdAt;
  final String? phrasePrompt;
  final String? setHomeworkPromt;
  final String? autoHomeworkPrompt;

  AiPrompt({
    this.id,
    this.createdAt,
    this.phrasePrompt,
    this.setHomeworkPromt,
    this.autoHomeworkPrompt,
  });

  factory AiPrompt.fromJson(Map<String, dynamic> json) {
    return AiPrompt(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      phrasePrompt: json['phrase_prompt'] as String?,
      setHomeworkPromt: json['set_homework_promt'] as String?,
      autoHomeworkPrompt: json['auto_homework_prompt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'phrase_prompt': phrasePrompt,
      'set_homework_promt': setHomeworkPromt,
      'auto_homework_prompt': autoHomeworkPrompt,
    };
  }

  AiPrompt copyWith({
    int? idx,
    int? id,
    DateTime? createdAt,
    String? phrasePrompt,
    String? setHomeworkPromt,
    String? autoHomeworkPrompt,
  }) {
    return AiPrompt(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      phrasePrompt: phrasePrompt ?? this.phrasePrompt,
      setHomeworkPromt: setHomeworkPromt ?? this.setHomeworkPromt,
      autoHomeworkPrompt: autoHomeworkPrompt ?? this.autoHomeworkPrompt,
    );
  }
}
