import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class PhrasesRepo extends ApiRepo {
  Future<List<PhraseModel>> getPhrasesDetails() async {
    List<PhraseModel> phrases = [];
    try {
      final data = await client.from(DbTable.phrase).select(
        '''*,${DbTable.userResult}(*),${DbTable.phraseCategories}(*),${DbTable.language}(*),${DbTable.level}(*),${DbTable.phraseDisabledSchools}(*,${DbTable.remoteConfig}(*,${DbTable.school}(*)))''',
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

  Future<void> disablePharase(int phraseId, List<int> schoolIds) async {
    try {
      final remotes = await client
          .from(DbTable.remoteConfig)
          .select('id, school')
          .inFilter('school', schoolIds);

      for (final remote in remotes) {
        final remoteId = remote['id'];

        final existing = await client
            .from(DbTable.phraseDisabledSchools)
            .select('id')
            .eq('phrase_id', phraseId)
            .eq('remote_id', remoteId)
            .maybeSingle();

        if (existing == null) {
          await client.from(DbTable.phraseDisabledSchools).insert({
            'phrase_id': phraseId,
            'remote_id': remoteId,
          });
        } else {
          await client
              .from(DbTable.phraseDisabledSchools)
              .delete()
              .eq('id', existing['id']);
        }
      }
    } catch (e, st) {
      log('togglePhrase error: $e\n$st');
      rethrow;
    }
  }

  Future<List<School>> getHomeData() async {
    List<School> schoolData = [];

    try {
      final data = await client.from(DbTable.school).select(
        '''*,${DbTable.schoolLanguage}(*,${DbTable.language}(*)),${DbTable.classes}(*,${DbTable.classLevel}(*,${DbTable.level}(*)),${DbTable.student}(*,${DbTable.classes}(*),${DbTable.level}(*),${DbTable.users}(*,${DbTable.userResult}(*,${DbTable.phrase}(*)))))''',
      );

      for (var val in data as List) {
        schoolData.add(School.fromJson(val as Map<String, dynamic>));
      }
    } catch (e) {
      log(e.toString());
    }

    return schoolData;
  }

  Future<void> disableCategories(bool val, int id) async {
    try {
      await client
          .from(DbTable.phraseCategories)
          .update({'Active': val})
          .eq('id', id);
    } catch (e) {
      log('togglePhrase error: $e');
      rethrow;
    }
  }
}
