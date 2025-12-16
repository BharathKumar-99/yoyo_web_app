import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/add_teacher/data/add_teacher_repo.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class AddTeacherViewModel extends ChangeNotifier {
  List<School> school = [];
  School? selectedSchool;
  final AddTeacherRepo _repo = AddTeacherRepo();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  Classes? selectedClasses;

  List<String> permission = ["Teacher", "Principle"];
  String? selectedPermission;

  void selectPermission(String? value) {
    selectedPermission = value;
    notifyListeners();
  }

  AddTeacherViewModel() {
    getSchool();
  }

  getSchool() async {
    school = await _repo.getAllSchools();
    notifyListeners();
  }

  void selectSchools(School? value) {
    selectedSchool = value;
    notifyListeners();
  }

  void selectClass(Classes? value) {
    selectedClasses = value;
    notifyListeners();
  }

  void addTeacher() async {
    if (selectedSchool == null) {
      UsefullFunctions.showSnackBar(ctx!, "Please select a school");
      return;
    }

    if (selectedClasses == null) {
      UsefullFunctions.showSnackBar(ctx!, "Please select a class");
      return;
    }

    if (firstNameController.text.trim().isEmpty) {
      UsefullFunctions.showSnackBar(ctx!, "First name is required");
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      UsefullFunctions.showSnackBar(ctx!, "Last name is required");
      return;
    }

    if (userNameController.text.trim().isEmpty) {
      UsefullFunctions.showSnackBar(ctx!, "Username is required");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      UsefullFunctions.showSnackBar(ctx!, "Email is required");
      return;
    }

    // --- EMAIL FORMAT VALIDATION ---
    final email = emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      UsefullFunctions.showSnackBar(ctx!, "Please enter a valid email address");
      return;
    }

    if (jobController.text.trim().isEmpty) {
      UsefullFunctions.showSnackBar(ctx!, "Job title is required");
      return;
    }

    if (selectedPermission == null) {
      UsefullFunctions.showSnackBar(ctx!, "Permission field is required");
      return;
    }

    GlobalLoader.show();

    // --- API CALL ---
    final result = await _repo.addTeacher(
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      userNameController.text.trim(),
      email,
      jobController.text.trim(),
      selectedPermission ?? '',
      selectedSchool!.id,
      selectedClasses!.id,
    );

    GlobalLoader.hide();

    if (result) {
      UsefullFunctions.showSnackBar(ctx!, "Teacher added successfully!");

      firstNameController.clear();
      lastNameController.clear();
      userNameController.clear();
      emailController.clear();
      jobController.clear();
      selectedPermission = null;
      selectedSchool = null;
      selectedClasses = null;

      notifyListeners();
      NavigationHelper.go(RouteNames.users);
    }
  }
}
