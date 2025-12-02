import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/add_user/data/add_user_repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class AddUserViewModel extends ChangeNotifier {
  final AddUserRepo _repo = AddUserRepo();
  List<UserModel> user = [];
  UserModel? selectedUser;
  String? selectedUserType;
  List<String> userType = ["Student", "Teacher"];
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();

  AddUserViewModel() {
    init();
  }

  Future<void> init() async {
    user = await _repo.getUsersWhereFirstNameIsNull();
    notifyListeners();
  }

  void selectUser(UserModel? val) {
    selectedUser = val;
    notifyListeners();
  }

  void selectUserType(String? val) {
    selectedUserType = val;
    notifyListeners();
  }

  Future<void> addUser() async {
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.show());
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    await _repo.assignUser(firstName, lastName, selectedUser?.userId);
    reset();
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.hide());
  }

  reset() {
    firstNameController.clear();
    lastNameController.clear();
    selectedUserType = null;
    notifyListeners();
  }
}
