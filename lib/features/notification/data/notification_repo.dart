import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';

import '../model/activation_model.dart';
import '../model/notification_model.dart';
import '../model/notification_settings_model.dart';

class NotificationRepo extends ApiRepo {
  Future<List<NotificationModel>> getActivationModel(int classId) async {
    try {
      List<NotificationModel> activationModel = [];

      final data = await client
          .from(DbTable.activationRequests)
          .select("*")
          .eq('class', classId)
          .eq('is_activated', false);

      for (var element in data) {
        activationModel.add(NotificationModel.fromJson(element));
      }

      final data1 = await client
          .from(DbTable.notificationTable)
          .select("*")
          .eq('class_id', classId);

      for (var element in data1) {
        activationModel.add(NotificationModel.fromJson(element));
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

  Future<NotificationSettingsModel?> getNotificationSettings(int i) async {
    try {
      final data = await client
          .from(DbTable.notificationSettings)
          .select("*")
          .eq('class', i);
      if (data.isEmpty) {
        return null;
      }
      return NotificationSettingsModel.fromJson(data.first);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> updateNotificationSettings(
    NotificationSettingsModel notificationSettingsModel,
    int classId,
  ) async {
    try {
      final settingsJson = notificationSettingsModel.settings?.toJson();
      if (notificationSettingsModel.id != null) {
        await client
            .from(DbTable.notificationSettings)
            .update({'settings': settingsJson})
            .eq('class', classId);
      } else {
        final response = await client
            .from(DbTable.notificationSettings)
            .insert({'class': classId, 'settings': settingsJson})
            .select()
            .single();
        notificationSettingsModel.id = response['id'];
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
