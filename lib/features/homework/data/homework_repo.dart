import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart' show FilePickerResult;
import 'package:http/http.dart' as http;

import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/home/model/fcm.dart';
import 'package:yoyo_web_app/features/home/model/student_classes.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

import '../../../core/api/repo.dart';
import '../../settings/model/homework_config_model.dart';
import '../model/homework_model.dart';

class HomeworkRepo extends ApiRepo {
  Future<List<HomeworkModel>>? getHomeWork(int id) async {
    List<HomeworkModel> homework = [];
    final homeworkData = await client
        .from(DbTable.homework)
        .select(
          '*,${DbTable.phrase}(*,${DbTable.language}(*),${DbTable.userResult}(*))',
        )
        .eq('school', id)
        .order('id', referencedTable: DbTable.phrase);
    for (var va in homeworkData) {
      homework.add(HomeworkModel.fromJson(va));
    }

    return homework;
  }

  Future<HomeworkConfigModel?> getHomeworkConfigs({
    required int classId,
  }) async {
    final data = await client
        .from(DbTable.homeworkConfigs)
        .select('*')
        .eq('class_id', classId);
    if (data.isEmpty) {
      return null;
    }
    return HomeworkConfigModel.fromJson(data.first);
  }

  Future<void> sendNotification(int classId) async {
    List<StudentClassesModel> studentClass = await getStudents(classId);
    List<String> fcmId = [];

    for (var element in studentClass) {
      for (Fcm fcm in element.user?.fcm ?? []) {
        if (fcm.fcmId != null && fcm.fcmId!.isNotEmpty) {
          fcmId.add(fcm.fcmId!);
        }
      }
    }

    final tokens = fcmId
        .where((e) => e.toString().trim().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    final payload = jsonEncode({
      'message': 'New Homework Added',
      'token': tokens,
    });

    await client.functions.invoke(
      'send_notification',
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> addNotification(String title, int classId) async {
    await client.from(DbTable.notificationTable).insert({
      'content': "Notification for $title is sent",
      'class_id': classId,
    });
  }

  Future<List<StudentClassesModel>> getStudents(int classId) async {
    List<StudentClassesModel> students = [];
    final data = await client
        .from(DbTable.studentClasses)
        .select('''*,${DbTable.users}(*)''')
        .eq('classes', classId);

    for (var element in data) {
      students.add(StudentClassesModel.fromJson(element));
    }

    return students;
  }

  Future<void> addAutoHomework(
    int schoolId,
    int classId,
    bool isEnabled,
    String prompt,
    FilePickerResult? filePickerResult,
  ) async {
    try {
      String publicUrl = '';
      if (filePickerResult != null) {
        final fileBytes = filePickerResult.files.first.bytes;

        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${filePickerResult.files.first.name}';

        final String uploadPath = 'homework/$classId/$fileName';

        await client.storage
            .from('homework')
            .uploadBinary(uploadPath, fileBytes!);

        publicUrl = client.storage.from('homework').getPublicUrl(uploadPath);
      }
      await client.from(DbTable.homeworkConfigs).upsert({
        'school_id': schoolId,
        'class_id': classId,
        'is_auto_enabled': true,
        'homework_prompt': prompt,
        'homework_document': publicUrl,
      }, onConflict: 'class_id,school_id');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateHomeworkAutoConfig({
    required int classId,
    required bool isAutoEnabled,
  }) async {
    try {
      await client
          .from(DbTable.homeworkConfigs)
          .update({'is_auto_enabled': isAutoEnabled})
          .eq('class_id', classId);
    } catch (e) {
      log(e.toString());
    }
  }

  addSetHomework({
    required String prompt,
    required FilePickerResult? file,
    required int classId,
    required int schoolId,
    required bool useUploads,
  }) async {
    try {
      String publicUrl = '';
      if (file != null) {
        final fileBytes = file.files.first.bytes;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.files.first.name}';

        final String uploadPath = 'homework/$classId/$fileName';
        await client.storage
            .from('homework')
            .uploadBinary(uploadPath, fileBytes!);
        publicUrl = client.storage.from('homework').getPublicUrl(uploadPath);
      }
      final url = Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/auto-homework',
      );

      final body = {
        "class_id": classId,
        "school_id": schoolId,
        "homework_prompt": prompt,
        "homework_document": publicUrl,
        "use_uploads": useUploads,
      };
      log(body.toString());

      final response = await http.post(url, body: jsonEncode(body));
      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw data['error'] ?? "Failed to create homework";
      }
      return data;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserModel>> getAllUsers(int classId) async {
    try {
      List<UserModel> users = [];
      final data = await client
          .from(DbTable.studentClasses)
          .select('''*,${DbTable.users}(*,${DbTable.teacher}(*))''')
          .eq('classes', classId);
      for (var element in data) {
        users.add(UserModel.fromJson(element['users']));
      }
      return users;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
