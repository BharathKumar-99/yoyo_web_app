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
  List<Classes> classes = [];
  School? selectedSchool;
  Classes? selectedClass;
  bool isLoading = true;
  bool get isTeacherAdmin =>
      teacher?.teacher?.first.permissionLevel == 'Teacher' ? false : true;
  bool get isTeacher => user?.isAdmin != true && isTeacherAdmin == false;

  CommonViewModel() {
    init();
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
      await getTeacherLogin();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  getSchools() async {
    schools = await _repo.getSchools();
    selectedSchool = null;
    notifyListeners();
  }

  void selectSchool(School? val) {
    selectedSchool = val;
    notifyListeners();
  }

  getuser() async {
    user = await _repo.getLoggedInUserInfo();
    notifyListeners();
  }

  getTeacherLogin() async {
    teacher = await _repo.getLoggedInTeacherInfo();
    if (teacher?.teacher?.isNotEmpty ?? false) {
      selectedSchool = schools.firstWhere(
        (school) => school.id == teacher?.schools?.id,
        orElse: () => schools.first,
      );
      listenTeacherNotification(teacher?.teacher?.first.id ?? 0);
      hasNotification = teacher?.teacher?.first.notification ?? false;
    }

    notifyListeners();
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
