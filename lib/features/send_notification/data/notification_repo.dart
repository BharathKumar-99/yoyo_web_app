import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class SendNotificationRepo extends ApiRepo {
  Future<bool> sendNotification(
    String title,
    String message,
    List<UserModel> users,
  ) async {
    try {
      final url = Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/fcm-test',
      );

      final tokens = users
          .expand((u) => u.fcm ?? [])
          .map((f) => f.fcmId)
          .whereType<String>()
          .toList();

      if (tokens.isEmpty) return false;

      final payload = [
        {"tokens": tokens, "title": title, "body": message},
      ];

      final response = await http.post(url, body: jsonEncode(payload));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final decoded = jsonDecode(response.body);

      return decoded is Map && decoded['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
