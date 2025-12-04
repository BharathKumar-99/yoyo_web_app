import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/view_school/data/school_repo.dart';

class ViewSchoolViewModel extends ChangeNotifier {
  int schoolId;
  School? school;
  final SchoolRepo _repo = SchoolRepo();

  bool loading = true;
  ViewSchoolViewModel(this.schoolId) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.show());
    school = await _repo.getSchoolData(schoolId);
    loading = false;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.hide());
  }
}
