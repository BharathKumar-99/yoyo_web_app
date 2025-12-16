import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/home/model/class_level_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';

class Classes {
  int? id;
  String? className;
  DateTime? createdAt;
  int? noOfStudents;
  int? submissionThreshold;
  List<Student>? students;
  School? school;
  List<ClassLevel>? classLevel;

  Classes({
    this.id,
    this.className,
    this.createdAt,
    this.noOfStudents,
    this.submissionThreshold,
    this.students,
    this.school,
    this.classLevel,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      id: json['id'],

      className: json['class_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      noOfStudents: json['no_of_students'],
      submissionThreshold: json['submission_threshold'],
      students: (json['student'] as List?)
          ?.map((e) => Student.fromJson(e))
          .toList(),
      school: json['school'] != null && json['school'] is Map?
          ? School.fromJson(json['school'])
          : null,
      classLevel: json[DbTable.classLevel] != null
          ? (json[DbTable.classLevel] as List?)
                ?.map((e) => ClassLevel.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'class_name': className,
      'created_at': createdAt?.toIso8601String(),
      'no_of_students': noOfStudents,
      'submission_threshold': submissionThreshold,
    };
  }
}
