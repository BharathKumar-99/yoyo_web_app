import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/add_teacher/model/teacher_model.dart';
import 'package:yoyo_web_app/features/home/model/class_level_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';

import 'student_classes.dart';

class Classes {
  int? id;
  String? className;
  DateTime? createdAt;
  int? noOfStudents;
  int? submissionThreshold;
  List<Student>? students;
  List<TeacherModel>? teacher;
  School? school;
  int? year;
  int? languageId;
  Language? language;
  List<ClassLevel>? classLevel;
  List<StudentClassesModel>? studentClasses;
  bool? activationCodeThroughTeacher;
  bool? allowTeachersToSetCategories;
  bool? allowTeachersToSetPhrases;
  bool? allowTeachersToSetBulkPhrases;

  Classes({
    this.id,
    this.className,
    this.createdAt,
    this.noOfStudents,
    this.submissionThreshold,
    this.students,
    this.school,
    this.year,
    this.languageId,
    this.language,
    this.classLevel,
    this.teacher,
    this.studentClasses,
    this.activationCodeThroughTeacher,
    this.allowTeachersToSetCategories,
    this.allowTeachersToSetPhrases,
    this.allowTeachersToSetBulkPhrases,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    List<StudentClassesModel> classes = [];
    if (json['student_classes'] is List) {
      for (var element in (json['student_classes'])) {
        if ((element != null)) {
          classes.add(StudentClassesModel.fromJson(element));
        }
      }
    }

    return Classes(
      id: json['id'],

      className: json['class_name'],
      year: json['year'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      noOfStudents: json['no_of_students'],
      submissionThreshold: json['submission_threshold'],
      students: (json['student'] as List?)
          ?.map((e) => Student.fromJson(e))
          .toList(),
      teacher: (json['teacher'] as List?)
          ?.map((e) => TeacherModel.fromJson(e))
          .toList(),
      school: json['school'] != null && json['school'] is Map?
          ? School.fromJson(json['school'])
          : null,
      languageId: json['language'] is int ? json['language'] : null,
      language: json['language'] is Map
          ? Language.fromJson(json['language'])
          : null,
      classLevel: json[DbTable.classLevel] != null
          ? (json[DbTable.classLevel] as List?)
                ?.map((e) => ClassLevel.fromJson(e))
                .toList()
          : null,
      studentClasses: classes,
      activationCodeThroughTeacher: json['activation_code_teacher'],
      allowTeachersToSetCategories: json['allow_teachers_to_set_categories'],
      allowTeachersToSetPhrases: json['allow_teachers_to_set_phrases'],
      allowTeachersToSetBulkPhrases: json['allow_teachers_to_set_bulk_phrases'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'class_name': className,
      'created_at': createdAt?.toIso8601String(),
      'no_of_students': noOfStudents,
      'submission_threshold': submissionThreshold,
      'language': languageId,
      'activation_code_teacher': activationCodeThroughTeacher,
      'allow_teachers_to_set_categories': allowTeachersToSetCategories,
      'allow_teachers_to_set_phrases': allowTeachersToSetPhrases,
      'allow_teachers_to_set_bulk_phrases': allowTeachersToSetBulkPhrases,
    };
  }
}
