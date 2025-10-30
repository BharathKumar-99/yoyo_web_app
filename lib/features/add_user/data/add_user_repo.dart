import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class AddUserRepo extends ApiRepo {
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

  Future<void> addUser({
    required String email,
    required String firstName,
    required String surName,
    required String userType,
    required Classes classes,
    required School school,
    required Level? lvl,
    required String? jobType,
    required String? permissionLvl,
  }) async {
    try {
      UserResponse response = await client.auth.admin.createUser(
        AdminUserAttributes(email: email),
      );
      await client.from(DbTable.users).insert({
        "user_id": response.user?.id,
        "first_name": firstName,
        "sur_name": surName,
        "email": email,
        "school": school.id,
      });

      if (userType == "Teacher") {
        await client.from(DbTable.teacher).insert({
          "user_id": response.user?.id,
          "job_title": jobType,
          "permission_level": permissionLvl,
          "classes": classes.id,
        });
      } else {
        await client.from(DbTable.student).insert({
          "user_id": response.user?.id,
          "class": classes.id,
          "language_level": lvl?.id,
        });
      }
      UsefullFunctions.showAwesomeSnackbarContent(
        "User Added",
        'Success',
        ContentType.success,
      );
    } on AuthApiException catch (e) {
      if (e.statusCode == "422") {
        UsefullFunctions.showAwesomeSnackbarContent(
          "User Already Exists ",
          'Failure',
          ContentType.failure,
        );
      }
      UsefullFunctions.showAwesomeSnackbarContent(
        e.message,
        'Failure',
        ContentType.failure,
      );
    }
  }
}
