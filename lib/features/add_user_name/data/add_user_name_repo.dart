import 'dart:developer';

import 'package:yoyo_web_app/core/api/repo.dart';

import '../../../config/constants/constants.dart' show DbTable;
import '../../add_user/model/level.dart';
import '../../home/model/school.dart';

class AddUserNameRepo extends ApiRepo {
  Future<List<School>>? getAllSchool() async {
    List<School> schoolData = [];
    try {
      final data = await client.from(DbTable.school).select(
        '''* , ${DbTable.classes}(*)''',
      );
      for (var element in data) {
        schoolData.add(School.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return schoolData;
  }

  Future<List<Level>> getAllLevel() async {
    List<Level> level = [];
    try {
      final data = await client.from(DbTable.level).select('*');
      for (var element in data) {
        level.add(Level.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return level;
  }
}
