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
  List<UserResult>? userResult;
  List<Student>? student;
  School? schools;

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
    this.student,
    this.schools,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    createdAt = DateTime.tryParse(json['created_at'])!;
    firstName = json['first_name'];
    surName = json['sur_name'];
    email = json['email'];
    username = json['username'];
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
    };
  }
}
