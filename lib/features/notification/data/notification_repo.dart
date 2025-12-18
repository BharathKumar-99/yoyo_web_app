import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';

import '../model/activation_model.dart';

class NotificationRepo extends ApiRepo {
  Future<List<ActivationRequestModel>> getActivationModel(int classId) async {
    try {
      List<ActivationRequestModel> activationModel = [];

      final data = await client
          .from(DbTable.activationRequests)
          .select("*")
          .eq('class', classId)
          .eq('is_activated', false);

      for (var element in data) {
        activationModel.add(ActivationRequestModel.fromJson(element));
      }

      return activationModel;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> updateActivationCode(
    ActivationRequestModel activationModel,
  ) async {
    try {
      await client
          .from(DbTable.activationRequests)
          .update({'is_activated': true})
          .eq('class', activationModel.classes ?? 0);
      await client
          .from(DbTable.users)
          .update({
            'activation_code': activationModel.code,
            'is_activated': false,
          })
          .eq('username', activationModel.username ?? '');
      final data = await client
          .from(DbTable.activationRequests)
          .select("*")
          .eq('is_activated', false)
          .eq('class', activationModel.classes ?? 0)
          .count(CountOption.exact);
      int requestCount = data.count;
      await client
          .from(DbTable.teacher)
          .update({'notification': requestCount > 1})
          .eq('classes', activationModel.classes ?? 0);
    } catch (e) {
      log(e.toString());
    }
  }
}
