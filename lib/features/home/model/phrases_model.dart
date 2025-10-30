import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';

class PhraseModel {
  int? id;
  int? level;
  int? vocab;
  String? phrase;
  int? sounds;
  int? language;
  String? recording;
  DateTime? createdAt;
  String? translation;
  int? score;
  Level? levelData;
  Language? languageData;

  PhraseModel({
    this.id,
    this.level,
    this.vocab,
    this.phrase,
    this.sounds,
    this.language,
    this.recording,
    this.createdAt,
    this.translation,
    this.score,
    this.levelData,
    this.languageData,
  });

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
    return PhraseModel(
      id: json['id'] as int?,
      level: json['level'] is int? ? json['level'] as int? : null,
      vocab: json['vocab'] as int?,
      phrase: json['phrase'] as String?,
      sounds: json['sounds'] as int?,
      language: json['language'] is int? ? json['language'] as int? : null,
      recording: json['recording'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      translation: json['translation'] as String?,
      levelData: json['level'] is Map? ? Level.fromJson(json['level']) : null,
      languageData: json['language'] is Map?
          ? Language.fromJson(json['language'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'vocab': vocab,
      'phrase': phrase,
      'sounds': sounds,
      'language': language,
      'recording': recording,
      'created_at': createdAt?.toIso8601String(),
      'translation': translation,
    };
  }
}
