import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/features/settings/model/ai_prompt_model.dart';

import '../../../config/constants/constants.dart';
import '../../../core/supabase/supabase_client.dart';
import '../model/homework_config_model.dart';

class SettingsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  String convertTo24Hour(String time) {
    final parts = time.split(' ');
    int hour = int.parse(parts[0]);
    final period = parts[1];

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return '${hour.toString().padLeft(2, '0')}:00:00';
  }

  int getDayFromCadence(String cadence) {
    const map = {
      'Every Sunday': 0,
      'Every Monday': 1,
      'Every Tuesday': 2,
      'Every Wednesday': 3,
      'Every Thursday': 4,
      'Every Friday': 5,
      'Every Saturday': 6,
    };

    return map[cadence] ?? 0;
  }

  int getNotificationDays(String notification) {
    if (notification.contains('2')) return 2;
    return 1;
  }

  Future<void> updateHomeworkConfigs({
    required String manualCadance,
    required String autoCadance,
    required String autoCadanceTime,
    required String notification,
    required int schoolId,
    required int classId,
  }) async {
    try {
      final formattedTime = convertTo24Hour(autoCadanceTime);

      final response = await _client
          .from(DbTable.homeworkConfigs)
          .upsert({
            'manual_cadence': manualCadance,
            'auto_cadence': autoCadance,
            'auto_cadence_time': formattedTime,
            'notification': notification,
            'school_id': schoolId,
            'class_id': classId,
            'is_auto_enabled': true,
          }, onConflict: 'class_id,school_id')
          .select()
          .maybeSingle();

      debugPrint("Saved config: $response");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<HomeworkConfigModel?> getHomeworkConfigs({
    required int classId,
  }) async {
    try {
      final response = await _client
          .from(DbTable.homeworkConfigs)
          .select()
          .eq('class_id', classId)
          .maybeSingle();

      if (response != null) {
        return HomeworkConfigModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  Future<void> updateClassActivation(bool v, int i) async {
    await _client
        .from(DbTable.classes)
        .update({'activation_code_teacher': v})
        .eq('id', i);
  }

  Future<void> updateClassAllowTeachersToSetCategories(bool v, int i) async {
    await _client
        .from(DbTable.classes)
        .update({'allow_teachers_to_set_categories': v})
        .eq('id', i);
  }

  Future<void> updateClassAllowTeachersToSetPhrases(bool v, int i) async {
    await _client
        .from(DbTable.classes)
        .update({'allow_teachers_to_set_phrases': v})
        .eq('id', i);
  }

  Future<void> updateClassAllowTeachersToSetBulkPhrases(bool v, int i) async {
    await _client
        .from(DbTable.classes)
        .update({'allow_teachers_to_set_bulk_phrases': v})
        .eq('id', i);
  }

  Future<AiPrompt?> getAiPrompt() async {
    try {
      final response = await _client.from(DbTable.aiPrompt).select().limit(1);
      if (response.isNotEmpty) return AiPrompt.fromJson(response.first);
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<void> updateAiPrompt({
    required String phrasePrompt,
    required String setHomeworkPrompt,
    required String autoHomeworkPrompt,
    required String docHomeworkPrompt,
  }) async {
    try {
      final response = await _client
          .from(DbTable.aiPrompt)
          .update({
            'phrase_prompt': phrasePrompt,
            'set_homework_promt': setHomeworkPrompt,
            'auto_homework_prompt': autoHomeworkPrompt,
            'attached_prompt': docHomeworkPrompt,
          })
          .eq('id', 1)
          .select()
          .maybeSingle();

      debugPrint("Saved config: $response");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
