import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/data/home_repo.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/table_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

import '../model/classes_model.dart';
import '../model/school.dart';
import '../model/student_model.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepo _repo = HomeRepo();
  List<School> homedata = [];
  List<TableModel> tableModel = [];
  List<TableModel> filteredTableModel = [];
  List<Language?> languages = [];
  int participation = 0;
  int effort = 0;
  int avrageScore = 0;
  String? selectedSchool;
  String? selectedLaunguage;
  List<int> efforts = [];
  List<int> average = [];
  List<UserResult> participationList = [];
  int totalNoStudents = 0;

  HomeViewModel() {
    getHomeData();
  }

  getHomeData() async {
    homedata = await _repo.getHomeData();

    for (var element in homedata) {
      element.schoolLanguage?.forEach((val) {
        languages.add(val.language);
      });
      tableModel.add(
        TableModel(
          element.schoolName ?? '',
          element.classes
                  ?.map((val) => extractClassNumber(val.className ?? ''))
                  .toList() ??
              [],
          element.principle ?? '',
          element.schoolLanguage
                  ?.map((scL) => scL.language?.language ?? '')
                  .toList()
                  .join(',') ??
              '',

          getAvgScore(element.classes),
        ),
      );
    }
    filteredTableModel = tableModel;
    selectedLaunguage = 'All';
    selectedSchool = 'All';
    int avgScore = 0;
    int effScore = 0;
    for (var va in average) {
      avgScore = avgScore + va;
    }
    for (var va in efforts) {
      effScore = effScore + va;
    }
    avrageScore = (avgScore / average.length).toInt();
    effort = (effScore / efforts.length).toInt();
    participation = ((participationList.length / totalNoStudents) * 100)
        .toInt();
    notifyListeners();
  }

  int? extractClassNumber(String className) {
    final regex = RegExp(r'Y(\d{2})'); // Matches "Y" followed by 2 digits
    final match = regex.firstMatch(className);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  int getAvgScore(List<Classes?>? classes) {
    List<Student> students = [];

    int score = 0;
    classes?.forEach((val) {
      val?.students?.forEach((stu) => students.add(stu));
    });

    int totaScore = 0;
    int totalEffort = 0;
    for (var val in students) {
      totaScore = totaScore + (val.score ?? 0);
      totalEffort = totalEffort + (val.effort ?? 0);
      val.userModel?.userResult?.forEach((v) {
        participationList.add(v);
      });
    }
    participationList = getUniqueUsers(participationList);
    score = (totaScore / (students.length)).toInt();
    average.add(score);
    efforts.add(totalEffort);
    totalNoStudents = totalNoStudents + (students.length);
    return score;
  }

  List<UserResult> getUniqueUsers(List<UserResult> usersResult) {
    final seen = <String>{};
    final uniqueList = <UserResult>[];

    for (var user in usersResult) {
      if (user.userId != null && !seen.contains(user.userId)) {
        seen.add(user.userId!);
        uniqueList.add(user);
      }
    }

    return uniqueList;
  }

  changeLanguage(String val) {
    selectedLaunguage = val;
    notifyListeners();
  }

  changeSchool(String val) {
    selectedSchool = val;
    notifyListeners();
  }

  void applyFilter() {
    if ((selectedSchool == null || selectedSchool == "All") &&
        (selectedLaunguage == null || selectedLaunguage == "All")) {
      filteredTableModel = List.from(tableModel);
    } else {
      filteredTableModel = tableModel.where((table) {
        final schoolMatch = (selectedSchool == "All" || selectedSchool == null)
            ? true
            : table.name == selectedSchool;

        final languageMatch =
            (selectedLaunguage == "All" || selectedLaunguage == null)
            ? true
            : table.languages.split(',').contains(selectedLaunguage);

        return schoolMatch && languageMatch;
      }).toList();
    }

    notifyListeners();
  }
}
