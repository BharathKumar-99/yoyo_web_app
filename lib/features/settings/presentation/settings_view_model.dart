import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/data/home_repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class SettingsViewModel extends ChangeNotifier {
  List<School> schools = [];
  final HomeRepo _repo = HomeRepo();
  late School selectedSchool;

  SettingsViewModel() {
    getSchools();
  }

  getSchools() async {
    schools = await _repo.getHomeData();
    selectedSchool = schools.first;
    notifyListeners();
  }

  void selectSchool(School val) {
    selectedSchool = val;
    notifyListeners();
  }
}
