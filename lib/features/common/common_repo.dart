import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/get_user_details.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class CommonRepo extends ApiRepo {
  getLoggedInUserInfo() async {
    String? userId = GetUserDetails.getCurrentUserId();
    final data = await client
        .from(DbTable.users)
        .select('*')
        .eq('user_id', userId!)
        .maybeSingle();
    return UserModel.fromJson(data!);
  }

  Future<UserModel?> getIndiviUser(String username) async {
    final data = await client
        .from(DbTable.users)
        .select('*')
        .eq('username', username)
        .maybeSingle();
    return UserModel.fromJson(data!);
  }

  Future<UserModel?> getLoggedInTeacherInfo() async {
    try {
      String? userId = GetUserDetails.getCurrentUserId();

      if (userId == null) {
        debugPrint("UserId is null");
        return null;
      }

      final data = await client
          .from(DbTable.users)
          .select('''*, 
          ${DbTable.studentClasses}(*, ${DbTable.classes}(*)),
          ${DbTable.teacher}(*),
          school:school!Users_school_fkey(*,
            top_performer_user:users!school_top_performer_fkey(*),
            ${DbTable.classes}(*,
              ${DbTable.language}(*)
            )
          )''')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        debugPrint("No user found in DB");
        return null;
      }

      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint("Error in getLoggedInTeacherInfo: $e");
      return null;
    }
  }

  Future<List<School>> getSchools() async {
    final data = await client.from(DbTable.school).select(
      '''*
      ,${DbTable.classes}(*,${DbTable.language}(*,${DbTable.level}(*)),${DbTable.classLevel}(*,${DbTable.level}(*)),${DbTable.teacher}(*),${DbTable.studentClasses}(*,${DbTable.users}(*,${DbTable.userResult}(*),${DbTable.teacher}(*),${DbTable.student}(*,${DbTable.users}(*,${DbTable.studentClasses}(*),${DbTable.userResult}(*,${DbTable.phrase}(*)))))))''',
    );

    return data.map((e) => School.fromJson(e)).toList();
  }

  Future<void> requestNewActivationCode(String username) async {
    try {
      final data = await client
          .from(DbTable.users)
          .select('''*,${DbTable.studentClasses}(*)''')
          .ilike('username', username)
          .maybeSingle();

      UserModel userModel = UserModel.fromJson(data!);
      String? fcmToken;

      int classId = userModel.studentClasses?.first.classId ?? 0;
      await client.from(DbTable.activationRequests).insert({
        'username': userModel.username,
        'class': classId,
        'fcm': fcmToken,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
