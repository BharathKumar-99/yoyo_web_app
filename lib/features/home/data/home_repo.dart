import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class HomeRepo extends ApiRepo {
  Future<List<School>> getHomeData() async {
    List<School> schoolData = [];

    try {
      final data = await client.from(DbTable.school).select(
        '''*,${DbTable.schoolLanguage}(*,${DbTable.language}(*)),${DbTable.classes}(*,${DbTable.student}(*,${DbTable.users}(*,${DbTable.userResult}(*))))''',
      );

      for (var val in data as List) {
        schoolData.add(School.fromJson(val as Map<String, dynamic>));
      }
    } catch (e) {
      log(e.toString());
    }

    return schoolData;
  }
}
