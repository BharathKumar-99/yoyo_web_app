import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/email_services.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/add_teacher/model/teacher_model.dart';

import '../../home/model/school.dart';

class AddTeacherRepo extends ApiRepo {
  Future<List<School>> getAllSchools() async {
    List<School> schools = [];
    final data = await client
        .from(DbTable.school)
        .select('*,${DbTable.classes}(*)');
    for (var val in data) {
      schools.add(School.fromJson(val));
    }
    return schools;
  }

  Future<bool> addTeacher(
    String firstName,
    String lastName,
    String userName,
    String email,
    String job,
    String permission,
    int? school,
    int? classId,
  ) async {
    try {
      final user = await client.auth.admin.createUser(
        AdminUserAttributes(email: email, emailConfirm: true),
      );
      String userId = user.user?.id ?? '';
      final firstLetter = lastName.isNotEmpty
          ? lastName[0].toUpperCase()
          : null;

      await client.from(DbTable.users).insert({
        'user_id': userId,
        'first_name': firstName,
        'sur_name': firstLetter,
        'email': email,
        'school': school,
        'username': userName,
      });

      await client.from(DbTable.teacher).insert({
        'user_id': userId,
        'job_title': job,
        'permission_level': permission,
        'classes': classId,
      });
      await EmailService.sendEmail(
        to: email,
        subject: "Activate Your Account",
        html:
            """
    <p>Hello!</p>
    <p>Your teacher account has been created.</p>
    <a href="https://app.yoyospeak.com/activate?uid=$userId">
      Click here to activate
    </a>
  """,
      );

      return true;
    } on AuthException catch (error) {
      if (error.statusCode == '422') {
        UsefullFunctions.showSnackBar(ctx!, "Email Already Exits");
        return false;
      }
    } catch (e) {
      UsefullFunctions.showSnackBar(ctx!, "Failed to add Teachers");
      return false;
    }
    return false;
  }

  Future<String> activateTeacher(String uid) async {
    try {
      final existing = await client
          .from(DbTable.teacher)
          .select("active")
          .eq("user_id", uid)
          .maybeSingle();
      if (existing != null) {
        TeacherModel model = TeacherModel.fromJson(existing);
        if (model.active == true) {
          return "Your account is already activated.";
        } else {
          await client
              .from(DbTable.teacher)
              .update({"active": true})
              .eq("user_id", uid);
          return "Your account has been activated successfully! 🎉";
        }
      } else {
        return "Teacher Not Found";
      }
    } catch (e) {
      return "Something went wrong";
    }
  }
}
