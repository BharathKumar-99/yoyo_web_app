import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';

class TeacherViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  changeIndex(int index) {
    selectedIndex = index;
    changeScreen(index);
    notifyListeners();
  }

  changeScreen(index) {
    switch (index) {
      case 0:
        ctx!.go(RouteNames.home);
        break;
      case 1:
        ctx!.go(RouteNames.phrases);
        break;
      case 2:
        ctx!.go(RouteNames.users);
        break;
      default:
        ctx!.go(RouteNames.home);
        break;
    }
  }
}
