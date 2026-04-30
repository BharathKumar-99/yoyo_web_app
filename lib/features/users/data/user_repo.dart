import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/email_services.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/users/model/student_langugaes.dart';

import '../../common/common_view_model.dart';

class UserRepo extends ApiRepo {
  Future<List<UserModel>> getUserData(CommonViewModel commonViewModel) async {
    List<UserModel> users = [];

    try {
      final data = await client.from(DbTable.users).select('''
      *,
      ${DbTable.studentClasses}(*),
      ${DbTable.teacher}(*),
      ${DbTable.student}(
        *,
        ${DbTable.classes}(*)
      ),
      school:school!Users_school_fkey(
        *,
        top_performer_user:users!school_top_performer_fkey(*)
      )
    ''');

      for (var val in data) {
        UserModel user = UserModel.fromJson(val);
        if (commonViewModel.teacher?.teacher?.isNotEmpty ?? false) {
          if (user.schools?.id == commonViewModel.teacher?.schools?.id) {
            users.add(user);
          }
        } else {
          users.add(user);
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return users;
  }

  addStudent(
    String firstName,
    String lastName,
    String username,
    String activationCode,
    int classId,
    int schoolId, {
    int? language,
    bool isAdmin = false,
  }) async {
    try {
      final email = generateRandomEmail();

      // 1. Create Auth user
      final userAuth = await client.auth.admin.createUser(
        AdminUserAttributes(email: email, emailConfirm: true),
      );

      final userId = userAuth.user?.id ?? "";

      await client.from(DbTable.users).upsert({
        'user_id': userId,
        'first_name': firstName,
        'sur_name': lastName,
        'email': email,
        'school': schoolId,
        'last_login': null,
        'onboarding': false,
        'activation_code': activationCode,
        'is_activated': false,
        'username': username,
        'teacher_tag': null,
        'is_admin': isAdmin,
        'language': language,
      });

      // 3. Insert student record
      await client.from(DbTable.student).upsert({
        'user_id': userId,
        'vocab': 0,
        'effort': 0,
        'score': 0,
        'language_level': 1,
        'user_name': username,
      });

      await client.from(DbTable.studentClasses).upsert({
        'user': userId,
        'classes': classId,
      });
    } catch (e) {
      UsefullFunctions.showSnackBar(
        ctx!,
        "Failed to add student. Please try again.",
      );
    }
  }

  Future<void> addTeacher(
    String name,
    String surName,
    String email,
    String jobTitle,
    String username,
    String activationCode,
    String selectedPermission,
    int schoolId,
    int classId,
  ) async {
    try {
      // 1. Create Auth user
      final userAuth = await client.auth.admin.createUser(
        AdminUserAttributes(email: email, emailConfirm: true),
      );

      final userId = userAuth.user?.id ?? "";

      await client.from(DbTable.users).upsert({
        'user_id': userId,
        'first_name': name,
        'sur_name': surName,
        'email': email,
        'school': schoolId,
        'last_login': null,
        'onboarding': false,
        'activation_code': activationCode,
        'is_activated': false,
        'username': username,
        'teacher_tag': null,
      });

      // 3. Insert student record
      await client.from(DbTable.teacher).upsert({
        'user_id': userId,
        'job_title': jobTitle,
        'permission_level': selectedPermission,
        'active': true,
        'classes': classId,
      });

      await client.from(DbTable.student).upsert({
        'user_id': userId,
        'vocab': 0,
        'effort': 0,
        'score': 0,
        'language_level': 1,
        'user_name': username,
      });

      await client.from(DbTable.studentClasses).upsert({
        'user': userId,
        'classes': classId,
      });
    } catch (e) {
      UsefullFunctions.showSnackBar(
        ctx!,
        "Failed to add teacher. Please try again.",
      );
    }
  }

  Future<List<StudentLanguageModel>> getStudentLanguage() async {
    try {
      final data = await client.from(DbTable.studentLanguage).select("*");
      return data.map((e) => StudentLanguageModel.fromJson(e)).toList();
    } catch (e) {
      UsefullFunctions.showSnackBar(
        ctx!,
        "Failed to get student language. Please try again.",
      );
      return [];
    }
  }
}
