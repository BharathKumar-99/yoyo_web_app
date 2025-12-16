import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

import '../../common/common_view_model.dart';

class UserRepo extends ApiRepo {
  Future<List<UserModel>> getUserData(CommonViewModel commonViewModel) async {
    List<UserModel> users = [];

    try {
      final data = await client
          .from(DbTable.users)
          .select(
            '*,${DbTable.teacher}(*),${DbTable.student}(*,${DbTable.classes}(*)),${DbTable.school}(*)',
          );

      for (var val in data) {
        UserModel user = UserModel.fromJson(val);
        if (commonViewModel.teacher?.teacher?.isNotEmpty ?? false) {
          if (user.schools?.id == commonViewModel.teacher?.schools?.id) {
            users.add(user);
          }
        } else {
          users.add(user);
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return users;
  }
}
