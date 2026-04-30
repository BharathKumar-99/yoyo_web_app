import 'dart:developer';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';

import '../../home/model/school.dart';

class EditSchoolRepo extends ApiRepo {
  Future<School> getSchool(int id) async {
    final data = await client
        .from(DbTable.school)
        .select('''*,${DbTable.classes}(*,${DbTable.language}(*))''')
        .eq('id', id)
        .maybeSingle();
    return School.fromJson(data!);
  }

  Future<RemoteConfig> getRemoteConfig(int id) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .select('*')
        .eq('school', id)
        .maybeSingle();
    return RemoteConfig.fromJson(data!);
  }

  Future<RemoteConfig> updateStreakEnabled(bool value, int id) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .update({"streak": value})
        .eq('school', id)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }

  Future<RemoteConfig> updateMasteryEnabled(bool value, id) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .update({"mastery": value})
        .eq('school', id)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }

  Future<RemoteConfig> updateWarmupEnabled(bool value, id) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .update({"warmup": value})
        .eq('school', id)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }

  Future<RemoteConfig> updateRemote(RemoteConfig apiCred) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .update(apiCred.toJson())
        .eq('id', apiCred.id)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }

  Future<String> getSupabaseUrl(Uint8List selectedBytes, String school) async {
    final fileName = '$school${DateTime.now().millisecondsSinceEpoch}.png';

    client.storage.from(Stroage.school).uploadBinary(fileName, selectedBytes);
    final url = client.storage.from(Stroage.school).getPublicUrl(fileName);
    return url;
  }

  Future<School> updateSchool(School? updatedSchool) async {
    final data = await client
        .from(DbTable.school)
        .update(updatedSchool?.toJson() ?? {})
        .eq('id', updatedSchool?.id ?? '')
        .select()
        .single();
    return School.fromJson(data);
  }

  Future<List<Language>> getLanguage() async {
    try {
      List<Language> lang = [];
      final data = await client.from(DbTable.language).select('*');
      for (var element in data) {
        lang.add(Language.fromJson(element));
      }
      return lang;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> addClass(String name, int? lang, int? year, int? school) async {
    try {
      await client.from(DbTable.classes).insert({
        'class_name': name,
        'school': school,
        'language': lang,
        'year': year,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateClass(name, int id) async {
    try {
      await client
          .from(DbTable.classes)
          .update({'class_name': name})
          .eq('id', id);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updatePass(int parse, int? id) async {
    await client
        .from(DbTable.remoteConfig)
        .update({'success_threshold': parse})
        .eq('id', id ?? 0);
  }

  Future<void> updateLow(int parse, int? id) async {
    await client
        .from(DbTable.remoteConfig)
        .update({'lower_threshold': parse})
        .eq('id', id ?? 0);
  }

  Future<void> deleteClass(int classId) async {
    try {
      await client.rpc(
        'delete_class_transaction',
        params: {'p_class_id': classId},
      );

      print("✅ Class deleted successfully");
    } on PostgrestException catch (e) {
      print("❌ Delete failed");
      print("Message: ${e.message}");
      print("Details: ${e.details}");
      print("Code: ${e.code}");

      throw Exception(e.message);
    } catch (e) {
      print("❌ Unexpected error: $e");
      rethrow;
    }
  }
}
