import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';

class PhrasesRepo extends ApiRepo {
  Future<List<PhraseModel>> getPhrasesDetails() async {
    List<PhraseModel> phrases = [];
    try {
      final data = await client.from(DbTable.phrase).select(
        '''*,${DbTable.phraseCategories}(*),${DbTable.language}(*),${DbTable.level}(*)''',
      );
      for (var val in data) {
        phrases.add(PhraseModel.fromJson(val));
      }
    } catch (e) {
      log(e.toString());
    }
    return phrases;
  }

  Future<void> deletePhrase(int id, String fileUrl) async {
    await client.from(DbTable.attemptedPhrases).delete().eq('phrases_id', id);
    await client.from(DbTable.userResult).delete().eq('phrases_id', id);
    await client.from(DbTable.phrase).delete().eq('id', id);

    const basePath = '/storage/v1/object/public/';
    final uri = Uri.parse(fileUrl);
    final startIndex = uri.path.indexOf(basePath);
    if (startIndex == -1) throw 'Invalid Supabase Storage URL';

    final relativePath = uri.path.substring(startIndex + basePath.length);
    final parts = relativePath.split('/');
    final bucket = parts.first;
    final filePath = parts.skip(1).join('/');

    await client.storage.from(bucket).remove([filePath]);
  }
}
