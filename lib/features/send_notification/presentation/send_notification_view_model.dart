import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/send_notification/data/notification_repo.dart';
import '../../../config/utils/usefull_functions.dart';
import '../../home/data/home_repo.dart';
import '../../home/model/school.dart';

class SendNotificationViewModel extends ChangeNotifier {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  School? selectedSchool;
  List<School> schools = [];
  final HomeRepo _repo = HomeRepo();
  List<UserModel> userModel = [];
  List<UserModel> selectedUser = [];
  CommonViewModel commonViewModel = CommonViewModel();
  final SendNotificationRepo _sendRepo = SendNotificationRepo();
  SendNotificationViewModel() {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.show());
    schools = await _repo.getHomeData();
    if (commonViewModel.teacher?.teacher?.isNotEmpty ?? false) {
      selectedSchool = schools.singleWhere(
        (school) => school.id == commonViewModel.teacher?.school,
      );
    }
    userModel = [];
    selectedSchool?.classes?.forEach(
      (v) => v.students?.forEach((std) => userModel.add(std.userModel!)),
    );
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.hide());
  }

  void selectSchool(School? val) {
    selectedSchool = val;
    userModel = [];
    selectedSchool?.classes?.forEach(
      (v) => v.students?.forEach((std) => userModel.add(std.userModel!)),
    );
    notifyListeners();
  }

  void sendNotification() async {
    if (title.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please Enter Title",
        'Error',
        ContentType.failure,
      );
    } else if (body.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please Enter Body",
        'Error',
        ContentType.failure,
      );
    } else if (selectedUser.isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please Select atleast one Student",
        'Error',
        ContentType.failure,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.show(),
      );
      await _sendRepo.sendNotification(
        title.text.trim(),
        body.text.trim(),
        selectedUser,
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.hide(),
      );

      UsefullFunctions.showAwesomeSnackbarContent(
        "Notification Sent",
        'Success',
        ContentType.failure,
      );
    }
  }

  void selectUser(UserModel row) {
    if (selectedUser.contains(row)) {
      selectedUser.removeWhere((ro) => ro == row);
    } else {
      selectedUser.add(row);
    }
    notifyListeners();
  }

  void selectAllUser() {
    if (selectedUser.length == userModel.length) {
      selectedUser.clear();
    } else {
      selectedUser = [...userModel];
    }
    notifyListeners();
  }
}
