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
  String? image;
  DateTime? lastLogin;
  List<UserResult>? userResult;
  List<Student>? student;
  School? schools;

  UserModel({
    this.userId,
    this.createdAt,
    this.firstName,
    this.surName,
    this.email,
    this.school,
    this.image,
    this.lastLogin,
    this.userResult,
    this.student,
    this.schools,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    createdAt = DateTime.tryParse(json['created_at']);
    firstName = json['first_name'];
    surName = json['sur_name'];
    email = json['email'];
    school = json['school'] != null && json['school'] is int
        ? json['school']
        : null;
    schools = json['school'] != null && json['school'] is Map
        ? School.fromJson(json['school'])
        : null;
    lastLogin = json['last_login'] != null
        ? DateTime.tryParse(json['last_login'])
        : null;
    image = json['image'];
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
      'first_name': firstName,
      'sur_name': surName,
      'email': email,
      'school': school,
      'image': image,
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
