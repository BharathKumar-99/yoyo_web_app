import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/edit_user/data/edit_user_repo.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

class EditUserViewModel extends ChangeNotifier {
  String userId;
  final EditUserRepo _repo = EditUserRepo();
  UserModel user = UserModel();
  bool isLoading = true;
  List<School> schools = [];
  List<UserResult> userResult = [];
  String? firstName;
  String? surName;
  bool changeSchool = false;
  CommonViewModel? commonViewModel;
  School? selectedSchool;

  Classes? selectedClasses;

  EditUserViewModel(this.userId) {
    init();
  }

  init() async {
    commonViewModel = Provider.of<CommonViewModel>(ctx!);
    user = await _repo.getUserData(userId);
    schools = await _repo.getAllSchool();
    userResult = await _repo.getUserResult(userId);
    isLoading = false;
    firstName = user.firstName;
    surName = user.surName;
    notifyListeners();
  }

  void updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void updateSurName(String value) {
    surName = value;
    notifyListeners();
  }

  void toogleSchool() {
    changeSchool = !changeSchool;
    notifyListeners();
  }

  void selectSchools(School? value) {
    selectedSchool = value;
    selectedClasses = null;
    notifyListeners();
  }

  void selectClass(Classes? value) {
    selectedClasses = value;
    notifyListeners();
  }

  void updateFirstNameRepo() async {
    GlobalLoader.show();
    await _repo.updateFirstName(userId, firstName!);
    user = await _repo.getUserData(userId);
    notifyListeners();
    GlobalLoader.hide();
  }

  void updateSurNameRepo() async {
    GlobalLoader.show();
    await _repo.updateSurName(userId, surName!);
    user = await _repo.getUserData(userId);
    notifyListeners();
    GlobalLoader.hide();
  }

  void updateSchoolAndClass() async {
    GlobalLoader.show();
    await _repo.updateSchoolAndClass(
      userId,
      selectedSchool!.id!,
      selectedClasses!.id!,
    );
    user = await _repo.getUserData(userId);
    notifyListeners();
    GlobalLoader.hide();
  }

  void updateTester(bool val) async {
    GlobalLoader.show();
    await _repo.updateTester(userId, val);
    user = await _repo.getUserData(userId);
    notifyListeners();
    GlobalLoader.hide();
  }

  void deleteAccount(String userId) async {
    GlobalLoader.show();
    bool result = await _repo.deleteUser(userId);
    GlobalLoader.hide();

    if (result) {
      NavigationHelper.go(RouteNames.users);
      UsefullFunctions.showAwesomeSnackbarContent(
        'User Deleted',
        'Success',
        ContentType.success,
      );
    } else {
      UsefullFunctions.showAwesomeSnackbarContent(
        'Failed to delete user',
        'Failed',
        ContentType.failure,
      );
    }
  }

  void logout() async {
    GlobalLoader.show();
    await Supabase.instance.client.auth.signOut();
    GlobalLoader.hide();
    NavigationHelper.go(RouteNames.login);
  }
}
