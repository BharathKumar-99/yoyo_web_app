import 'dart:typed_data';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';

import '../../home/model/school.dart';

class EditSchoolRepo extends ApiRepo {
  Future<School> getSchool(int id) async {
    final data = await client
        .from(DbTable.school)
        .select('''*,${DbTable.schoolLanguage}(*,${DbTable.language}(*))''')
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
}
