import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/features/add_teacher/model/teacher_model.dart';

class DashboardViewModel extends ChangeNotifier {
  int selectedIndex = 0;
  bool isinTabMode = false;
  bool isSettingsOpen = false;
  TeacherModel? model;

  changeIndex(int index) {
    selectedIndex = index;
    isSettingsOpen = false;
    changeScreen(index);
    notifyListeners();
  }

  void openSettings() {
    isSettingsOpen = true;
    notifyListeners();
    NavigationHelper.go(RouteNames.settings);
  }

  changeScreen(index) {
    switch (index) {
      case 0:
        ctx!.go(RouteNames.home);
        break;
      case 2:
        ctx!.go(RouteNames.phrases);
        break;
      case 3:
        ctx!.go(RouteNames.users);
        break;
      case 4:
        ctx!.go(RouteNames.notification);
        break;
      default:
        ctx!.go(RouteNames.home);
        break;
    }
  }

  void changeDrawer() {
    isinTabMode = !isinTabMode;
    notifyListeners();
  }
}
