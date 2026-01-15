import 'dart:developer';
import 'dart:typed_data';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';

class AddPhrasesRepo extends ApiRepo {
  Future<List<Language>>? getLanguages() async {
    List<Language> lang = [];
    try {
      final data = await client.from(DbTable.language).select('*');
      for (var json in data) {
        lang.add(Language.fromJson(json));
      }
    } catch (e) {
      log(e.toString());
    }
    return lang;
  }

  Future<List<Level>>? getLevel() async {
    List<Level> lvl = [];
    try {
      final data = await client.from(DbTable.level).select('*');
      for (var json in data) {
        lvl.add(Level.fromJson(json));
      }
    } catch (e) {
      log(e.toString());
    }
    return lvl;
  }

  Future<String> getSupabaseUrl(
    String phrase,
    Uint8List selectedBytes,
    String mp3Name,
  ) async {
    final fileName =
        '$phrase/$mp3Name${DateTime.now().millisecondsSinceEpoch}.mp3';

    client.storage.from(Stroage.phrases).uploadBinary(fileName, selectedBytes);
    final url = client.storage.from(Stroage.phrases).getPublicUrl(fileName);
    return url;
  }

  Future<void> addPhrases(
    Uint8List selectedFile,
    String phrase,
    String translation,
    int vocab,
    int sound,
    Language lang,
    Level lvl,
    String fileName,
  ) async {
    String mp3Url = await getSupabaseUrl(
      lang.language ?? '',
      selectedFile,
      fileName,
    );
    var data = {
      'phrase': phrase,
      'translation': translation,
      'language': lang.id,
      'vocab': vocab,
      'sounds': sound,
      'level': lvl.id,
      'recording': mp3Url,
    };
    await client.from(DbTable.phrase).insert(data);
  }

  Future<List<PhraseCategories>> getPhraseCategories(int i) async {
    List<PhraseCategories> categories = [];
    try {
      final data = await client
          .from(DbTable.phraseCategories)
          .select('*')
          .eq('school_id', i);
      for (var json in data) {
        categories.add(PhraseCategories.fromJson(json));
      }
    } catch (e) {
      log(e.toString());
    }
    return categories;
  }
}
