import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/data/home_repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

import '../../add_teacher/model/teacher_model.dart';

class SettingsViewModel extends ChangeNotifier {
  List<School> schools = [];
  final HomeRepo _repo = HomeRepo();
  late School selectedSchool;
  List<TeacherModel>? teacherModel;
  CommonViewModel? commonmodel;

  SettingsViewModel() {
    getSchools();
  }

  getSchools() async {
    schools = await _repo.getHomeData();
    selectedSchool = schools.first;
    commonmodel = Provider.of<CommonViewModel>(ctx!, listen: false);
    teacherModel = commonmodel?.teacher?.teacher;
    if (teacherModel?.isNotEmpty ?? false) {
      selectSchool(
        schools.firstWhere((t) => t.id == commonmodel?.teacher?.schools?.id),
      );
    }
    notifyListeners();
  }

  void selectSchool(School val) {
    selectedSchool = val;
    notifyListeners();
  }
}
