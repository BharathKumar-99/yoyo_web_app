import 'dart:typed_data';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';

import '../../home/model/school.dart';

class EditSchoolRepo extends ApiRepo {
  Future<School> getSchool(int id) async {
    final data = await client
        .from(DbTable.school)
        .select('*')
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

  Future<RemoteConfig> updateStreakEnabled(bool value) async {
    final data = await client
        .from(DbTable.remoteConfig)
        .update({"streak": value})
        .eq('id', 1)
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
