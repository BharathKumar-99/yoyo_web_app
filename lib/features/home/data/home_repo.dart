import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class HomeRepo extends ApiRepo {
  Future<List<School>> getHomeData() async {
    List<School> schoolData = [];

    try {
      final data = await client.from(DbTable.school).select(
        '''*,${DbTable.schoolLanguage}(*,${DbTable.language}(*)),${DbTable.classes}(*,${DbTable.student}(*,${DbTable.classes}(*),${DbTable.level}(*),${DbTable.users}(*,${DbTable.userResult}(*,${DbTable.phrase}(*)))))''',
      );

      for (var val in data as List) {
        schoolData.add(School.fromJson(val as Map<String, dynamic>));
      }
    } catch (e) {
      log(e.toString());
    }

    return schoolData;
  }

  Future<List<Level>> getLevel() async {
    List<Level> lvl = [];

    try {
      final data = await client.from(DbTable.level).select("*");
      for (var element in data) {
        lvl.add(Level.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return lvl;
  }
}
