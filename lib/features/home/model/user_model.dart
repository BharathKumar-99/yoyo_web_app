import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/add_teacher/model/teacher_model.dart';
import 'package:yoyo_web_app/features/home/model/fcm.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

import 'school.dart';
import 'student_model.dart';

class UserModel {
  String? userId;
  DateTime? createdAt;
  String? firstName;
  String? surName;
  String? email;
  int? school;
  String? username;
  DateTime? lastLogin;
  bool? onboarding;
  bool? isActivated;
  bool? isLoggedIn;
  String? activationCode;
  bool? isTester;
  List<UserResult>? userResult;
  List<Student>? student;
  List<Fcm>? fcm;
  List<TeacherModel>? teacher;
  School? schools;
  bool? isAdmin;

  UserModel({
    this.userId,
    this.createdAt,
    this.email,
    this.school,
    this.firstName,
    this.surName,
    this.username,
    this.lastLogin,
    this.onboarding,
    this.userResult,
    this.isLoggedIn,
    this.student,
    this.fcm,
    this.schools,
    this.isActivated,
    this.isTester,
    this.teacher,
    this.activationCode,
    this.isAdmin,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    createdAt = DateTime.tryParse(json['created_at'])!;
    firstName = json['first_name'];
    surName = json['sur_name'];
    email = json['email'];
    username = json['username'];
    isAdmin = json['is_admin'];
    activationCode = json['activation_code'];
    isActivated = json['is_activated'];
    isTester = json['is_tester'];
    isLoggedIn = json['is_logged_in'];
    school = json['school'] != null && json['school'] is int
        ? json['school']
        : null;
    schools = json['school'] != null && json['school'] is Map
        ? School.fromJson(json['school'])
        : null;
    lastLogin = json['last_login'] != null
        ? DateTime.tryParse(json['last_login'])
        : null;

    if (json['user_results'] != null) {
      userResult = <UserResult>[];
      json['user_results'].forEach((v) {
        userResult?.add(UserResult.fromJson(v));
      });
    }
    if (json['student'] != null) {
      student = <Student>[];
      json['student'].forEach((v) {
        student!.add(Student.fromJson(v));
      });
    }
    if (json['fcm'] != null) {
      fcm = <Fcm>[];
      json['fcm'].forEach((v) {
        fcm!.add(Fcm.fromJson(v));
      });
    }
    if (json[DbTable.teacher] != null) {
      teacher = <TeacherModel>[];
      json[DbTable.teacher].forEach((v) {
        teacher!.add(TeacherModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'email': email,
      'school': school,
      'first_name': firstName,
      'sur_name': surName,
      'last_login': lastLogin?.toIso8601String(),
      'onboarding': onboarding,
      'activation_code': activationCode,
      'is_activated': isActivated,
      'is_logged_in': isLoggedIn,
      'is_admin': isAdmin,
      'is_tester': isTester,
      'fcm': fcm?.map((v) => v.toJson()).toList(),
    };
  }
}
