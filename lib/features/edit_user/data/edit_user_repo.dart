import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

import '../../../config/router/navigation_helper.dart';
import '../../users/model/student_langugaes.dart';

class EditUserRepo extends ApiRepo {
  Future<UserModel> getUserData(String userId) async {
    final data = await client
        .from(DbTable.users)
        .select(
          '''*,${DbTable.student}(*),${DbTable.studentLanguage}(*),school:school!Users_school_fkey(*,top_performer_user:users!school_top_performer_fkey(*))''',
        )
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

  Future<UserModel?> isStudent(String userId) async {
    try {
      final response = await client
          .from(DbTable.users)
          .select('''*,${DbTable.student}(*)''')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateFirstName(String userId, String name) async {
    try {
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'first_name': name})
            .eq('user_id', userId);
        return true;
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSurName(String userId, String name) async {
    try {
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'sur_name': name})
            .eq('user_id', userId);
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTester(String userId, bool tester) async {
    try {
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'is_tester': tester})
            .eq('user_id', userId);
        return true;
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
        return false;
      }
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
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'school': schoolId})
            .eq('user_id', userId);
        await client
            .from(DbTable.studentClasses)
            .update({'classes': schoolId})
            .eq('user_id', userId);
        return true;
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
        return false;
      }
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

  Future<bool> deleteUser(String id) async {
    try {
      await client.rpc('delete_student_transaction', params: {'p_user_id': id});
      return true;
    } on PostgrestException catch (e) {
      print("❌ Delete failed");
      print("Message: ${e.message}");
      print("Details: ${e.details}");
      print("Code: ${e.code}");

      return false;
    } catch (e) {
      print("❌ Unexpected error: $e");
      rethrow;
    }
  }

  Future<bool> updateActivationCode(String userId, String s) async {
    try {
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'activation_code': s})
            .eq('user_id', userId);
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
        return false;
      }
      return true;
    } catch (e) {
      return false;
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

  Future<void> updateStudentLanguage(String userId, int id) async {
    try {
      UserModel? student = await isStudent(userId);
      if (student?.isAdmin != true && student?.student != null) {
        await client
            .from(DbTable.users)
            .update({'language': id})
            .eq('user_id', userId);
      } else {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Insufficent Permission',
          'Failed',
          ContentType.failure,
        );
      }
    } catch (e) {
      UsefullFunctions.showAwesomeSnackbarContent(
        'Something went wrong',
        'Failed',
        ContentType.failure,
      );
    }
  }
}
