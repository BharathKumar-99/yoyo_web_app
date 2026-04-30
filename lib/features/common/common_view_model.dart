import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/features/common/common_repo.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class CommonViewModel extends ChangeNotifier {
  UserModel? user;
  UserModel? teacher;
  final CommonRepo _repo = CommonRepo();
  RealtimeChannel? _channel;
  final _client = Supabase.instance.client;
  bool hasNotification = false;
  List<School> schools = [];
  School? selectedSchool;
  Classes? selectedClass;
  bool isLoading = true;
  bool get isAdmin => user?.isAdmin == true;
  bool get isTeacherAdmin =>
      teacher?.teacher != null && (teacher?.teacher?.isNotEmpty ?? false)
      ? teacher?.teacher?.first.permissionLevel == 'Teacher'
            ? false
            : true
      : false;
  bool get isTeacher => user?.isAdmin != true && isTeacherAdmin == false;

  CommonViewModel() {
    init();
  }

  getCode(String username) async {
    await _repo.requestNewActivationCode(username);
    return await getIndiviUser(username);
  }

  init() async {
    try {
      isLoading = true;
      notifyListeners();
      user = null;
      teacher = null;
      schools = [];
      selectedSchool = null;
      _channel?.unsubscribe();
      hasNotification = false;
      await getSchools();
      await getuser();
      getTeacherLogin();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  getSchools() async {
    schools = await _repo.getSchools();
    selectedSchool = null;
    selectedClass = null;
    notifyListeners();
  }

  getSchoolfromOut(School? val) async {
    schools = await _repo.getSchools();
    selectSchoolFromOutside(val);
  }

  getClassFromOut(School? school, Classes? val) async {
    schools = await _repo.getSchools();
    selectSchoolFromOutside(school);

    selectClassFromOutside(val);
  }

  selectClassFromOutside(Classes? val) {
    Classes classes = selectedSchool!.classes!.firstWhere(
      (v) => v.id == val?.id,
    );
    selectedClass = classes;
    notifyListeners();
  }

  getSchoolfromOutinit() async {
    schools = await _repo.getSchools();
    notifyListeners();
  }

  void selectSchool(School? val) {
    selectedSchool = val;
    selectedClass = null;
    notifyListeners();
  }

  void selectSchoolFromOutside(School? val) {
    School school = schools.firstWhere((v) => v.id == val?.id);
    selectedSchool = school;
    selectedClass = null;
    notifyListeners();
  }

  getuser() async {
    user = await _repo.getLoggedInUserInfo();
    notifyListeners();
  }

  getIndiviUser(String username) async {
    return await _repo.getIndiviUser(username);
  }

  Future<void> getTeacherLogin() async {
    try {
      teacher = await _repo.getLoggedInTeacherInfo();

      if (teacher == null) {
        debugPrint("Teacher model is null");
        notifyListeners();
        return;
      }

      final teacherList = teacher?.teacher ?? [];

      if (teacherList.isNotEmpty) {
        final currentTeacher = teacherList.first;

        if (schools.isNotEmpty && teacher!.schools != null) {
          selectedSchool = schools.firstWhere(
            (school) => school.id == teacher!.schools!.id,
            orElse: () => schools.first,
          );
        }

        if (teacher!.studentClasses?.isNotEmpty ?? false) {
          final teacherClassId = teacher!.studentClasses!.first.classes?.id;

          selectedClass = selectedSchool!.classes!.firstWhere(
            (c) => c.id == teacherClassId,
            orElse: () => selectedSchool!.classes!.first,
          );
        }

        listenTeacherNotification(currentTeacher.id ?? 0);
        hasNotification = currentTeacher.notification ?? false;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error in getTeacherLogin: $e");
    }
  }

  String extractCaps(String text) {
    final matches = RegExp(r'(^[A-Za-z])|-(\s*[A-Za-z])').allMatches(text);

    // Extract the actual letters, remove '-', trim spaces
    final letters = matches.map((m) {
      return (m.group(1) ?? m.group(2))!
          .replaceAll('-', '')
          .trim()
          .toUpperCase();
    }).join();

    return letters;
  }

  void listenTeacherNotification(int teacherId) {
    _channel = _client.channel('teacher-$teacherId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'teacher',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: teacherId,
        ),
        callback: (payload) {
          final newRecord = payload.newRecord;
          hasNotification = newRecord['notification'] == true;
          notifyListeners();
        },
      )
      ..subscribe();
  }

  @override
  void dispose() {
    if (_channel != null) {
      _client.removeChannel(_channel!);
    }
    super.dispose();
  }

  void selectClass(Classes? val) {
    selectedClass = val;
    notifyListeners();
  }
}
