import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class EmailService {
  static const String edgeFunctionUrl =
      "https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/send_email";

  static Future<bool> sendEmail({
    required String to,
    required String subject,
    required String html,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(edgeFunctionUrl),

        body: jsonEncode({"to": to, "subject": subject, "html": html}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print("Error calling edge function: $e");
      return false;
    }
  }
}

String generateRandomEmail() {
  const letters = "abcdefghijklmnopqrstuvwxyz";
  const numbers = "0123456789";
  const allowed = "$letters$numbers";

  final rand = Random.secure();

  String prefix = List.generate(
    10,
    (i) => allowed[rand.nextInt(allowed.length)],
  ).join();
  String domain = List.generate(
    5,
    (i) => allowed[rand.nextInt(allowed.length)],
  ).join();

  return "$prefix@$domain";
}
