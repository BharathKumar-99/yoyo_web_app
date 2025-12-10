import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

class EditUserRepo extends ApiRepo {
  Future<UserModel> getUserData(String userId) async {
    final data = await client
        .from(DbTable.users)
        .select('''*,${DbTable.student}(*),${DbTable.school}(*)''')
        .eq('user_id', userId)
        .maybeSingle();

    return UserModel.fromJson(data!);
  }

  Future<List<School>> getAllSchool() async {
    final data = await client
        .from(DbTable.school)
        .select("*,${DbTable.classes}(*)");

    List<School> schools = [];

    for (var sData in data) {
      schools.add(School.fromJson(sData));
    }
    return schools;
  }

  Future<bool> updateFirstName(String userId, String name) async {
    try {
      await client
          .from(DbTable.users)
          .update({'first_name': name})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSurName(String userId, String name) async {
    try {
      await client
          .from(DbTable.users)
          .update({'sur_name': name})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTester(String userId, bool tester) async {
    try {
      await client
          .from(DbTable.users)
          .update({'is_tester': tester})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSchoolAndClass(
    String userId,
    int schoolId,
    int classId,
  ) async {
    try {
      await client
          .from(DbTable.users)
          .update({'school': schoolId})
          .eq('user_id', userId);
      await client
          .from(DbTable.student)
          .update({'class': schoolId})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserResult>> getUserResult(String userId) async {
    List<UserResult> userResult = [];
    final data = await client
        .from(DbTable.userResult)
        .select('*,${DbTable.phrase}(*)')
        .eq('user_id', userId);

    for (var result in data) {
      userResult.add(UserResult.fromJson(result));
    }
    return userResult;
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final std = await client
          .from(DbTable.student)
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      Student student = Student.fromJson(std!);

      await client
          .from(DbTable.attemptedPhrases)
          .delete()
          .eq('student_id', student.id ?? 0);
      await client.from(DbTable.streakTable).delete().eq('user_id', userId);
      await client.from(DbTable.student).delete().eq('user_id', userId);
      await client.from(DbTable.userResult).delete().eq('user_id', userId);
      await client.from(DbTable.users).delete().eq('user_id', userId);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
