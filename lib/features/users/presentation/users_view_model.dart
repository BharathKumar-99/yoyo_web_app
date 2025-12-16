import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/users/data/user_repo.dart';

import '../../../config/router/navigation_helper.dart';
import '../../../config/utils/global_loader.dart';

class UsersViewModel extends ChangeNotifier {
  final UserRepo _repo = UserRepo();
  List<UserModel> users = [];
  List<UserModel> teacher = [];
  CommonViewModel? commonViewModel;
  UsersViewModel() {
    commonViewModel = Provider.of<CommonViewModel>(ctx!);
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    users = await _repo.getUserData(commonViewModel!);
    users.removeWhere((element) => element.firstName == null);
    teacher = users
        .where((element) => element.teacher?.isNotEmpty ?? false)
        .toList();
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }
}
