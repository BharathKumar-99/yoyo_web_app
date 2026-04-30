import 'classes_model.dart';

class School {
  int? id;
  String? principle;
  DateTime? createdAt;
  String? schoolName;
  String? schoolEmail;
  int? noOfStudents;
  String? schoolAddress;
  List<Classes>? classes;

  int? schoolTelephoneNo;
  String? image;

  School({
    this.id,
    this.principle,
    this.createdAt,
    this.schoolName,
    this.noOfStudents,
    this.schoolAddress,
    this.schoolEmail,
    this.schoolTelephoneNo,
    this.image,
    this.classes,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    var classes = json['classes'] as List?;
    return School(
      id: json['id'],
      principle: json['principle'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      schoolName: json['school_name'],
      schoolEmail: json['email'],
      noOfStudents: json['no_of_students'],
      schoolAddress: json['school_address'],

      schoolTelephoneNo: json['school_telephone_no'],
      image: json['image'],
      classes: classes?.map((e) => Classes.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'principle': principle,
      'created_at': createdAt?.toIso8601String(),
      'school_name': schoolName,
      'no_of_students': noOfStudents,
      'school_address': schoolAddress,
      'school_telephone_no': schoolTelephoneNo,
      'image': image,
    };
  }
}
