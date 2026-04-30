import 'dart:developer';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class SchoolRepo extends ApiRepo {
  getSchoolData() async {
    final data = await client.from(DbTable.school).select('''
  *,
  ${DbTable.classes}(
    *,
    ${DbTable.language}(
      *
    ),
   ${DbTable.studentClasses}(*, 
      ${DbTable.users}(
        *,${DbTable.userResult}(*)
     
    ))
  )
''');

    List<School> schools = [];

    for (var element in data) {
      schools.add(School.fromJson(element));
    }
    return schools;
  }

  Future<String> getSupabaseUrl(Uint8List selectedBytes, String image) async {
    final fileName = '$image${DateTime.now().millisecondsSinceEpoch}.png';

    client.storage.from(Stroage.school).uploadBinary(fileName, selectedBytes);
    final url = client.storage.from(Stroage.school).getPublicUrl(fileName);
    return url;
  }

  Future<void> addSchool(
    Uint8List selectedFile,
    String schoolName,
    String principalName,
    String address,
    String email,
    int number,
    String fileName,
  ) async {
    try {
      String image = await getSupabaseUrl(selectedFile, fileName);
      var data = {
        'school_name': schoolName,
        'school_address': address,
        'school_telephone_no': number,
        'email': email,
        'principle': principalName,
        'image': image,
      };

      final sData = await client
          .from(DbTable.school)
          .insert(data)
          .select('*')
          .single();
      School school = School.fromJson(sData);

      try {
        await client.from(DbTable.remoteConfig).insert({
          "api_key": "17142724400002e9",
          "api_secret_key": "8a259350f3a84c9e3af163118cfd4caa",
          "streak": false,
          "fr_slack": 1,
          "warmup": false,
          "language_slack": {
            "de": 0,
            "fr": 10,
            "jp": 0,
            "kr": 0,
            "ru": 0,
            "sp": 0,
            "promax": 0,
            "promax.cn": 0,
          },
          "onboarding": true,
          "school": school.id,
          "mastery": false,
          "lower_threshold": 50,
          "success_threshold": 80,
        });
      } catch (e) {
        log(e.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteSchool(int id) async {
    try {
      await client.rpc(
        'delete_school_transaction',
        params: {'p_school_id': id},
      );

      print("✅ School deleted successfully");
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
