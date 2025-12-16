import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/common_repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class CommonViewModel extends ChangeNotifier {
  UserModel? user;
  UserModel? teacher;
  final CommonRepo _repo = CommonRepo();

  getuser() async {
    user = await _repo.getLoggedInUserInfo();
    notifyListeners();
  }

  getTeacherLogin() async {
    teacher = await _repo.getLoggedInTeacherInfo();
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
}
