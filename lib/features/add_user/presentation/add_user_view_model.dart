import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/add_user/data/add_user_repo.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';

import '../../home/model/school.dart';
import '../model/level.dart';

class AddUserViewModel extends ChangeNotifier {
  final AddUserRepo _repo = AddUserRepo();
  List<School>? school = [];
  List<Classes>? classes = [];
  List<Level> level = [];
  School? selectedSchool;
  Classes? selectedClasses;
  String? selectedUserType;
  Level? selectedLevel;
  List<String> userType = ["Student", "Teacher"];
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController permissionLvl = TextEditingController();

  AddUserViewModel() {
    init();
  }

  Future<void> init() async {
    school = await _repo.getAllSchool();
    level = await _repo.getAllLevel();
    notifyListeners();
  }

  void selectSchools(School? val) {
    selectedSchool = val;
    notifyListeners();
  }

  void selectClass(Classes? val) {
    selectedClasses = val;
    notifyListeners();
  }

  void selectUserType(String? val) {
    selectedUserType = val;
    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    notifyListeners();
  }

  Future<void> addUser() async {
    final email = emailController.text.trim();
    final firstName = firstNameController.text.trim();
    final surName = lastNameController.text.trim();
    final job = jobTitle.text.trim();
    final permission = permissionLvl.text.trim();

    if (email.isEmpty ||
        firstName.isEmpty ||
        surName.isEmpty ||
        selectedUserType == null ||
        selectedClasses == null ||
        selectedSchool == null ||
        (selectedUserType == "Student" && selectedLevel == null) ||
        (selectedUserType == "Teacher" &&
            (job.isEmpty || permission.isEmpty))) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please fill all required fields before adding user.",
        "Failed",
        ContentType.failure,
      );
      return;
    }

    try {
      GlobalLoader.show();
      await _repo.addUser(
        email: email,
        firstName: firstName,
        surName: surName,
        userType: selectedUserType!,
        classes: selectedClasses!,
        school: selectedSchool!,
        lvl: selectedLevel!,
        jobType: job,
        permissionLvl: permission,
      );
      reset();
    } catch (e) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Failed to add user: $e",
        "Failed",
        ContentType.failure,
      );
    } finally {
      GlobalLoader.hide();
    }
  }

  reset() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    jobTitle.clear();
    permissionLvl.clear();
    selectedClasses = null;
    selectedLevel = null;
    selectedSchool = null;
    selectedUserType = null;
    notifyListeners();
  }
}
