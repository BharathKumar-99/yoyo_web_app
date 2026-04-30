import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/users/data/user_repo.dart';
import 'package:yoyo_web_app/features/users/presentation/builk_upload_dialog.dart';

import '../../../config/utils/global_loader.dart';
import '../model/student_langugaes.dart';

class UsersViewModel extends ChangeNotifier {
  final UserRepo _repo = UserRepo();
  List<UserModel> users = [];
  List<UserModel> teacher = [];
  CommonViewModel commonViewModel;
  String selectedUserType = 'Student';
  List<String> permission = ["Teacher", "Teacher Admin"];
  List<String> userTypes = ['Student', 'Teacher'];
  bool showAddStudent = false;
  bool showAddTeacher = false;
  List<StudentLanguageModel> studentLanguage = [];
  UsersViewModel(this.commonViewModel) {
    commonViewModel.addListener(_onSchoolChange);
    if (commonViewModel.user?.isAdmin == true) {
      userTypes.add('Admin');
    }
    init();
  }
  void _onSchoolChange() async {
    await init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    users = await _repo.getUserData(commonViewModel);
    studentLanguage = await _repo.getStudentLanguage();
    users.removeWhere((element) => element.firstName == null);
    teacher = users
        .where(
          (element) =>
              (element.studentClasses?.isNotEmpty ?? false) &&
              (commonViewModel.selectedSchool == null
                  ? element.studentClasses?.isNotEmpty ?? false
                  : commonViewModel.selectedClass == null
                  ? element.schools?.id == commonViewModel.selectedSchool?.id
                  : element.studentClasses?.first.classId ==
                        commonViewModel.selectedClass?.id),
        )
        .toList();
    if (commonViewModel.selectedSchool == null) {
      showAddStudent = false;
      showAddTeacher = false;
    }
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void selectUser(String? val) {
    selectedUserType = val ?? 'All';

    notifyListeners();
  }

  void toggleAddUser(bool isTeacher) {
    if (isTeacher) {
      showAddStudent = false;
      showAddTeacher = !showAddTeacher;
    } else {
      showAddTeacher = false;
      showAddStudent = !showAddStudent;
    }
    notifyListeners();
  }

  Future<void> addStudent(
    String name,
    String surName,
    String username,
    String activation,
    int? language,
  ) async {
    // 🧹 Trim inputs
    name = name.trim();
    surName = surName.trim();
    username = username.trim();
    activation = activation.trim();

    if (name.isEmpty ||
        surName.isEmpty ||
        username.isEmpty ||
        activation.isEmpty) {
      _showError("All fields are required");
      return;
    }

    final selectedClass = commonViewModel.selectedClass;
    final selectedSchool = commonViewModel.selectedSchool;

    if (selectedClass == null || selectedClass.id == null) {
      _showError("Please select a class");
      return;
    }

    if (selectedSchool == null || selectedSchool.id == null) {
      _showError("Please select a school");
      return;
    }

    if (language == null) {
      _showError("Please select a language");
      return;
    }

    GlobalLoader.show();

    try {
      await _repo.addStudent(
        name,
        surName,
        username,
        activation,
        selectedClass.id!,
        selectedSchool.id!,
        isAdmin: selectedUserType == 'Admin',
        language: language,
      );

      await init();
      await commonViewModel.getSchools();
      commonViewModel.getClassFromOut(selectedSchool, selectedClass);
      toggleAddUser(false);
      GlobalLoader.hide();
    } catch (e, stack) {
      debugPrint("addUser error: $e");
      debugPrintStack(stackTrace: stack);

      _showError("Failed to add user. Please try again.");
    } finally {
      GlobalLoader.hide();
    }
  }

  void _showError(String s) {
    UsefullFunctions.showSnackBar(ctx!, s);
  }

  Future<void> addTeacher(
    String name,
    String surName,
    String email,
    String jobTitle,
    String username,
    String activationCode,
    String selectedPermission,
  ) async {
    name = name.trim();
    surName = surName.trim();
    email = email.trim();
    jobTitle = jobTitle.trim();
    username = username.trim();
    activationCode = activationCode.trim();

    if (name.isEmpty ||
        surName.isEmpty ||
        email.isEmpty ||
        jobTitle.isEmpty ||
        username.isEmpty ||
        activationCode.isEmpty) {
      _showError("All fields are required");
      return;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    final selectedClass = commonViewModel.selectedClass;
    final selectedSchool = commonViewModel.selectedSchool;

    if (selectedClass == null || selectedClass.id == null) {
      _showError("Please select a class");
      return;
    }
    if (selectedSchool == null || selectedSchool.id == null) {
      _showError("Please select a school");
      return;
    }

    GlobalLoader.show();

    try {
      await _repo.addTeacher(
        name,
        surName,
        email,
        jobTitle,
        username,
        activationCode,
        selectedPermission,
        selectedSchool.id!,
        selectedClass.id!,
      );

      await init();
      toggleAddUser(true);
      GlobalLoader.hide();
    } catch (e, stack) {
      debugPrint("addTeacher error: $e");
      debugPrintStack(stackTrace: stack);

      _showError("Failed to add teacher. Please try again.");
    } finally {
      GlobalLoader.hide();
    }
  }

  void showBulkUploadDialog(bool isMobile, bool isTab) {
    showDialog(
      context: ctx!,
      builder: (con) => Dialog(
        backgroundColor: Colors.white,
        child: UploadStudents(isMobile: isMobile, isTab: isTab),
      ),
    );
  }
}
