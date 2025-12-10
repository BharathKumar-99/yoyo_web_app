import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/data/home_repo.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

import '../../add_user/model/level.dart';
import '../model/classes_model.dart';
import '../model/school.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepo _repo = HomeRepo();
  List<School> homedata = [];
  List<Language?> languages = [];
  int participation = 0;
  int effort = 0;
  int avrageScore = 0;
  List<int> efforts = [];
  List<int> average = [];
  List<UserResult> participationList = [];
  int totalNoStudents = 0;
  School? selectedSchool;
  Classes? selectedClass;
  Level? selectedLevel;
  String? selectedTimeFrame;
  List<Level> levels = [];
  List<String> timeFrame = ["Today", "This Week", "This Month", "This Year"];
  Language? selectedLanguage;
  List<String> goodWords = [];
  List<String> badWords = [];
  List<Student> students = [];
  List<Student> filteredStudents = [];

  HomeViewModel() {
    getHomeData();
  }

  getHomeData() async {
    homedata = await _repo.getHomeData();

    for (var element in homedata) {
      element.schoolLanguage?.forEach((val) {
        languages.add(val.language);
      });
    }
    languages = languages.toSet().toList();
    levels = await _repo.getLevel();
    applyFilter();
    applyStudentFilter();
    notifyListeners();
  }

  List<UserResult> getUniqueUsers(List<UserResult> usersResult) {
    final seen = <String>{};
    final uniqueList = <UserResult>[];

    for (var user in usersResult) {
      if (user.type == 'Learned') {
        if (user.userId != null && !seen.contains(user.userId)) {
          seen.add(user.userId!);
          uniqueList.add(user);
        }
      }
    }

    return uniqueList;
  }

  void selectSchool(School? val) {
    selectedSchool = val;
    selectedClass = null;
    applyFilter();
    notifyListeners();
  }

  void selectClass(Classes? val) {
    selectedClass = val;
    applyFilter();
    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    applyStudentFilter();
    notifyListeners();
  }

  void selectTimeFrame(String? val) {
    selectedTimeFrame = val;
    applyStudentFilter();
    notifyListeners();
  }

  void selectLanguage(Language? val) {
    selectedLanguage = val;
    applyStudentFilter();
    notifyListeners();
  }

  applyFilter() {
    totalNoStudents = 0;
    effort = 0;
    avrageScore = 0;
    int scoreSum = 0;
    participationList = [];
    students = [];
    selectedSchool == null
        ? homedata.forEach((val) {
            val.classes?.forEach((cal) {
              totalNoStudents = totalNoStudents + (cal.students?.length ?? 0);

              cal.students?.forEach((std) {
                students.add(std);
                scoreSum = scoreSum + (std.score ?? 0);
                std.userModel?.userResult?.forEach((user) {
                  participationList.add(user);
                });
              });
            });
          })
        : selectedClass == null
        ? selectedSchool?.classes?.forEach((cal) {
            totalNoStudents = totalNoStudents + (cal.students?.length ?? 0);
            cal.students?.forEach((std) {
              students.add(std);
              scoreSum = scoreSum + (std.score ?? 0);
              std.userModel?.userResult?.forEach((user) {
                participationList.add(user);
              });
            });
          })
        : selectedClass?.students?.forEach((std) {
            students.add(std);
            totalNoStudents = totalNoStudents + 1;
            scoreSum = scoreSum + (std.score ?? 0);
            std.userModel?.userResult?.forEach((user) {
              participationList.add(user);
            });
          });
    filteredStudents = students;
    for (var attempt in participationList) {
      attempt.goodWords?.forEach((val) {
        goodWords.add(val);
      });
      attempt.badWords?.forEach((val) {
        badWords.add(val);
      });
      effort = effort + (attempt.attempt ?? 0);
    }

    participationList = getUniqueUsers(participationList);
    participation = (((participationList.length) / (totalNoStudents)) * 100)
        .toInt();
    avrageScore = (scoreSum / totalNoStudents).toInt();
    goodWords = getTopWords(goodWords);
    badWords = getTopWords(badWords);

    notifyListeners();
  }

  void applyStudentFilter() {
    final List<Student> originalList = students;
    filteredStudents = [];

    bool matchLanguage(UserResult val) {
      if (selectedLanguage == null) return true;
      return (val.phraseModel?.language ?? 0) == selectedLanguage!.id;
    }

    bool matchTimeFrame(DateTime date) {
      switch (selectedTimeFrame) {
        case 'Today':
          return date.isToday;
        case 'This Week':
          return date.isThisWeek;
        case 'This Month':
          return date.isThisMonth;
        case 'This Year':
          return date.isThisYear;
        default:
          return true;
      }
    }

    for (var student in originalList) {
      // Level filter
      if (selectedLevel != null && student.level?.id != selectedLevel!.id) {
        continue; // Skip this student
      }

      final results = <UserResult>[];

      for (var val in (student.userModel?.userResult ?? [])) {
        final date = val.createdAt!;
        if (matchTimeFrame(date) && matchLanguage(val)) {
          results.add(val);
        }
      }

      // Only include the student if they have filtered results
      if (results.isNotEmpty) {
        student.userModel?.userResult = results;
        filteredStudents.add(student);
      }
    }
  }

  List<String> getTopWords(List<String> words, {int top = 10}) {
    final counts = <String, int>{};

    for (var w in words) {
      w = w.toLowerCase().trim();
      if (w.isEmpty) continue;

      counts[w] = (counts[w] ?? 0) + 1;
    }

    final sortedKeys = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    return sortedKeys.take(top).toList();
  }
}

extension DateExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();

    // Start of current week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // End of current week (Sunday)
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }
}
