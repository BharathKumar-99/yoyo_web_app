import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';

class PhrasesRepo extends ApiRepo {
  StreamSubscription? _phraseStatusSub;
  Future<List<PhraseModel>> getPhrasesDetails(List<int> catId) async {
    List<PhraseModel> phrases = [];
    try {
      final data = await client
          .from(DbTable.phrase)
          .select(
            '''*,${DbTable.userResult}(*),${DbTable.phraseCategories}(*),${DbTable.language}(*),${DbTable.level}(*),${DbTable.phraseDisabledSchools}(*,${DbTable.remoteConfig}(*,${DbTable.school}(*)))''',
          )
          .inFilter('categories', catId)
          .order('created_at', ascending: false);
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
        '''*,${DbTable.classes}(*,${DbTable.language}(*)),${DbTable.classes}(*,${DbTable.classLevel}(*,${DbTable.level}(*)),${DbTable.student}(*,${DbTable.classes}(*),${DbTable.level}(*),${DbTable.users}(*,${DbTable.userResult}(*,${DbTable.phrase}(*)))))''',
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

  Future<void> addCategory(String name, int schoolId, int languageId) async {
    try {
      await client.from(DbTable.phraseCategories).insert({
        'name': name,
        'school_id': schoolId,
        'language': languageId,
        'Active': true,
      });
    } catch (e) {
      log('add error: $e');
      rethrow;
    }
  }

  Future<List<PhraseCategories>> getPhraseCategories(int i) async {
    List<PhraseCategories> phraseCategories = [];
    try {
      final data = await client
          .from(DbTable.phraseCategories)
          .select('*')
          .eq('school_id', i);
      for (var val in data) {
        phraseCategories.add(PhraseCategories.fromJson(val));
      }
    } catch (e) {
      log(e.toString());
    }
    return phraseCategories;
  }

  Future<void> callWebhook(
    int id,
    String phrase,
    int lang,
    String? question,
  ) async {
    final url = Uri.parse(
      'https://yoyospeak.app.n8n.cloud/webhook/c48770b2-466f-4746-a825-e6604eb669a9',
    );

    final payload = {
      "id": id,
      "phrase": phrase,
      "language": lang,
      "question": question,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error calling webhook: $e');
    }
  }

  Future<Map<String, dynamic>> generatePhrases({
    required String prompt,
    required bool useUploads,
    FilePickerResult? fileResult,
    required int categoryId,
    required int languageId,
    required int phraseCount,
  }) async {
    String? base64File;

    if (useUploads && fileResult != null) {
      final PlatformFile file = fileResult.files.first;

      Uint8List? bytes = file.bytes;

      // ✅ Mobile fallback (if bytes == null)
      if (bytes == null && file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      }

      if (bytes == null) {
        throw Exception("Unable to read file");
      }

      base64File = base64Encode(bytes);
    }

    final response = await http.post(
      Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/group_phrase_creation',
      ),

      body: jsonEncode({
        "prompt": prompt,
        "useUploads": useUploads,
        "file": base64File,
        "category_id": categoryId,
        "language_id": languageId,
        "phrase_count": phraseCount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Something went wrong');
    }

    return data;
  }

  Future<PhraseModel> addPhrases(
    String phrase,
    String question,
    String type,
    int catId,
    int langId,
  ) async {
    try {
      final data = await client
          .from(DbTable.phrase)
          .insert({
            'phrase': phrase,
            'question': question,
            'listen': type == 'Listening' ? true : false,
            'reading_phrase': type == 'Reading' ? true : false,
            'categories': catId,
            // 'level': lvlId,
            'language': langId,
          })
          .select('*')
          .single();

      PhraseModel newPhrase = PhraseModel.fromJson(data);
      return newPhrase;
    } catch (e) {
      log('add error: $e');
      rethrow;
    }
  }

  void listenForPhraseCompletion(
    int phraseId, {
    required VoidCallback onCompleted,
  }) {
    _phraseStatusSub?.cancel();

    _phraseStatusSub = client
        .from(DbTable.phrase)
        .stream(primaryKey: ['id'])
        .eq('id', phraseId)
        .listen((rows) {
          if (rows.isEmpty) return;

          final status = rows.first['status'];

          if (status == 'completed') {
            _phraseStatusSub?.cancel();
            _phraseStatusSub = null;

            onCompleted();
          }
        });
  }

  void listenForPhraseGroupCompletion(
    List<int> phraseIds,
    {required VoidCallback onCompleted}) {

    _phraseStatusSub?.cancel();

    _phraseStatusSub = client
        .from(DbTable.phrase)
        .stream(primaryKey: ['id'])
        .inFilter('id', phraseIds)
        .listen((rows) {
          if (rows.isEmpty) return;

          final allCompleted = rows.every((row) => row['status'] == 'completed');

          if (allCompleted && rows.length == phraseIds.length) {
            _phraseStatusSub?.cancel();
            _phraseStatusSub = null;

            onCompleted();
          }
        });
  }

  Future<void> deleteCategories(int id) async {
    try {
      await client.from(DbTable.phraseCategories).delete().eq('id', id);
    } catch (e) {
      log('delete error: $e');
    }
  }

  Future<void> deletePhrases(int categoryId) async {
    try {
      // 1️⃣ Fetch phrase IDs
      final phraseIdsResponse = await client
          .from(DbTable.phrase)
          .select('id')
          .eq('categories', categoryId);

      final phraseIds = (phraseIdsResponse as List)
          .map((e) => e['id'] as int)
          .toList();

      if (phraseIds.isEmpty) return;

      // 2️⃣ Delete from userResult
      await client
          .from(DbTable.userResult)
          .delete()
          .inFilter('phrases_id', phraseIds);
      await client
          .from(DbTable.attemptedPhrases)
          .delete()
          .inFilter('phrases_id', phraseIds);

      // 3️⃣ Delete phrases
      await client.from(DbTable.phrase).delete().eq('categories', categoryId);
    } catch (e, st) {
      log('delete error: $e', stackTrace: st);
    }
  }

  Future<PhraseModel?> getLastCategories() async {
    try {
      final data = await client
          .from(DbTable.phrase)
          .select('*')
          .not('categories', 'is', null)
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data == null) return null;

      return PhraseModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
