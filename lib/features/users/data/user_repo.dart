import 'dart:developer';

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class UserRepo extends ApiRepo {
  Future<List<UserModel>> getUserData() async {
    List<UserModel> users = [];
    try {
      final data = await client
          .from(DbTable.users)
          .select(
            '*,${DbTable.student}(*,${DbTable.classes}(*)),${DbTable.school}(*)',
          );

      for (var val in data) {
        users.add(UserModel.fromJson(val));
      }
    } catch (e) {
      log(e.toString());
    }

    return users;
  }
}
