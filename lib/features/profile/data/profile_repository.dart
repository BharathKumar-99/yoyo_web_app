import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';
import '../../../config/constants/constants.dart';
import '../../../config/utils/get_user_details.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../home/model/classes_model.dart';
import '../../home/model/school.dart';
import '../model/user_view_data_model.dart';

class ProfileRepository {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<School?> getSchoolData(int id) async {
    try {
      final data = await _client
          .from(DbTable.school)
          .select(
            '''*,${DbTable.classes}(*,${DbTable.language}(*,${DbTable.level}(*),${DbTable.phrase}(*)),${DbTable.studentClasses}(*,${DbTable.classes}(*), ${DbTable.users}(*,${DbTable.student}(*),${DbTable.userResult}(*,${DbTable.phrase}(*)))))''',
          )
          .eq('id', id)
          .maybeSingle();
      return School.fromJson(data!);
    } catch (e) {
      return null;
    }
  }

  Stream<UserViewDataModel?> getUserDataStream(String userId) {
    try {
      return _client
          .from(DbTable.userView)
          .stream(primaryKey: ['user_id'])
          .eq('user_id', userId)
          .map((event) {
            if (event.isNotEmpty) {
              return UserViewDataModel.fromJson(event.first);
            }
            return null;
          });
    } catch (e, st) {
      log('Realtime UserData Error: $e\n$st');
      return const Stream.empty();
    }
  }

  void updateLastLogin() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    await _client
        .from(DbTable.users)
        .update({'last_login': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<Classes?> getClass() async {
    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";

      final data = await _client
          .from(DbTable.studentClasses)
          .select('''*,${DbTable.classes}(*)''')
          .eq('user', userId)
          .maybeSingle();
      return Classes.fromJson(data![DbTable.classes]);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<UserResult>?> getResults(String userId) async {
    try {
      List<UserResult> results = [];
      final data = await _client
          .from(DbTable.userResult)
          .select('''*,${DbTable.phrase}(*)''')
          .eq('user_id', userId);

      for (var element in data) {
        results.add(UserResult.fromJson(element));
      }
      return results;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
