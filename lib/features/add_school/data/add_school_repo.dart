import 'dart:developer';
import 'dart:typed_data';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import '../../../config/constants/constants.dart';
import '../../home/model/language_model.dart';

class AddSchoolRepo extends ApiRepo {
  Future<List<Language>>? getLanguages() async {
    List<Language> lang = [];
    try {
      final data = await client.from(DbTable.language).select(
        '''* , ${DbTable.level}(*)''',
      );
      for (var json in data) {
        lang.add(Language.fromJson(json));
      }
    } catch (e) {
      log(e.toString());
    }
    return lang;
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
    int number,
    int studentCount,
    List<Language> lang,
    String fileName,
  ) async {
    String image = await getSupabaseUrl(selectedFile, fileName);
    var data = {
      'school_name': schoolName,
      'school_address': address,
      'school_telephone_no': number,
      'principle': principalName,
      'no_of_students': studentCount,
      'image': image,
    };

    final sData = await client
        .from(DbTable.school)
        .insert(data)
        .select('*')
        .single();

    School school = School.fromJson(sData);

    for (var lData in lang) {
      var lanData = {'school': school.id, 'language': lData.id};
      await client.from(DbTable.schoolLanguage).insert(lanData);
    }
  }
}
