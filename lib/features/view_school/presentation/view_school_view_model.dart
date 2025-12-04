import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/view_school/data/school_repo.dart';

class ViewSchoolViewModel extends ChangeNotifier {
  int schoolId;
  School? school;
  final SchoolRepo _repo = SchoolRepo();
  ViewSchoolViewModel(this.schoolId) {
    init();
  }

  init() async {
    school = await _repo.getSchoolData(schoolId);
    notifyListeners();
  }
}
