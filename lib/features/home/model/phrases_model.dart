import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';

import '../../edit_school/model/remote_config.dart';
import 'user_result_model.dart';

class PhraseModel {
  int? id;
  int? level;
  int? vocab;
  String? phrase;
  String? question;
  String? questionRecording;
  int? sounds;
  int? language;
  int? categories;
  String? recording;
  DateTime? createdAt;
  String? translation;
  String? questionTranslation;
  bool? readingPhrase;
  int? score;
  bool? warmup;
  bool? listen;
  Level? levelData;
  Language? languageData;
  PhraseCategories? phraseCategories;
  List<UserResult>? userResult;
  List<PhraseDisabledSchools> phraseDisabledSchools;

  PhraseModel({
    this.id,
    this.level,
    this.vocab,
    this.phrase,
    this.question,
    this.questionRecording,
    this.sounds,
    this.language,
    this.recording,
    this.createdAt,
    this.warmup,
    this.translation,
    this.readingPhrase,
    this.listen,
    this.questionTranslation,
    this.score,
    this.levelData,
    this.languageData,
    this.categories,
    this.phraseCategories,
    this.userResult,
    required this.phraseDisabledSchools,
  });

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
    List<PhraseDisabledSchools> phraseDisabledSchool = [];
    if (json['phrase_disabled_schools'] != null) {
      json['phrase_disabled_schools'].forEach((v) {
        phraseDisabledSchool.add(PhraseDisabledSchools.fromJson(v));
      });
    }
    List<UserResult>? userResults = [];
    if (json['user_results'] != null) {
      userResults = <UserResult>[];
      json['user_results'].forEach((v) {
        userResults?.add(UserResult.fromJson(v));
      });
    }
    return PhraseModel(
      id: json['id'] as int?,
      level: json['level'] is int? ? json['level'] as int? : null,
      categories: json['categories'] is int?
          ? json['categories'] as int?
          : null,
      vocab: json['vocab'] as int?,
      warmup: json['warmup'] as bool?,
      listen: json['listen'] as bool?,
      readingPhrase: json['reading_phrase'] as bool?,
      phrase: json['phrase'] as String?,
      question: json['question'] as String?,
      questionTranslation: json['question_translation'] as String?,
      sounds: json['sounds'] as int?,
      questionRecording: json['question_recording'] as String?,
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
      phraseCategories: json[DbTable.phraseCategories] is Map
          ? PhraseCategories.fromJson(json[DbTable.phraseCategories])
          : null,
      phraseDisabledSchools: phraseDisabledSchool,
      userResult: userResults,
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

class PhraseDisabledSchools {
  int? id;
  int? phraseId;
  int? remoteId;
  String? disabledAt;
  RemoteConfig? remoteConfig;

  PhraseDisabledSchools({
    this.id,
    this.phraseId,
    this.remoteId,
    this.disabledAt,
    this.remoteConfig,
  });

  PhraseDisabledSchools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phraseId = json['phrase_id'];
    remoteId = json['remote_id'];
    disabledAt = json['disabled_at'];
    remoteConfig = json[DbTable.remoteConfig] != null
        ? RemoteConfig.fromJson(json[DbTable.remoteConfig])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phrase_id'] = phraseId;
    data['remote_id'] = remoteId;
    data['disabled_at'] = disabledAt;
    return data;
  }
}
