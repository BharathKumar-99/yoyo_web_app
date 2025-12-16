import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

import '../../../config/router/navigation_helper.dart';

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

  Future<List<UserModel>> getUsersWhereFirstNameIsNull() async {
    CommonViewModel commonViewModel = Provider.of<CommonViewModel>(ctx!);
    final res = await client
        .from(DbTable.users)
        .select('''*,${DbTable.school}(*)''')
        .isFilter('first_name', null);

    if (res.isEmpty) {
      return [];
    }

    List<UserModel> user = res
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    if (commonViewModel.teacher?.teacher != null) {
      user = user
          .where((v) => v.schools?.id == commonViewModel.teacher?.schools?.id)
          .toList();
    }
    return user;
  }

  Future<void> assignUser(
    String firstName,
    String lastName,
    String? userId,
  ) async {
    final firstLetter = lastName.isNotEmpty ? lastName[0].toUpperCase() : null;

    await client
        .from(DbTable.users)
        .update({'first_name': firstName, 'sur_name': firstLetter})
        .eq('user_id', userId ?? '');
  }
}
