import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/users/data/user_repo.dart';

class UsersViewModel extends ChangeNotifier {
  final UserRepo _repo = UserRepo();
  List<UserModel> users = [];
  UsersViewModel() {
    init();
  }

  init() async {
    users = await _repo.getUserData();
    notifyListeners();
  }
}
