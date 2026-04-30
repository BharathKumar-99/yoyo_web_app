import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/email_services.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/supabase/supabase_client.dart';
import 'package:yoyo_web_app/features/add_user_name/data/add_user_name_repo.dart';
import 'dart:convert';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import '../../../config/router/navigation_helper.dart';
import '../../add_user/model/level.dart';
import '../../home/model/school.dart';
import '../model/add_user_from_excel.dart';

class AddUserNameViewModel extends ChangeNotifier {
  List<School>? school = [];
  List<Level> level = [];

  Level? selectedLevel;
  final AddUserNameRepo _repo = AddUserNameRepo();
  String? selectedFileName;
  List<UserActivationModel> list = [];
  CommonViewModel? commonViewModel;

  AddUserNameViewModel() {
    init();
  }

  Future<void> init() async {
    commonViewModel = Provider.of<CommonViewModel>(ctx!, listen: false);
    school = await _repo.getAllSchool();
    level = await _repo.getAllLevel();

    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    notifyListeners();
  }

  createUser() async {
    await generateUsers(
      list,
      commonViewModel?.selectedSchool?.id ?? 0,
      commonViewModel?.selectedClass?.id ?? 0,
      commonViewModel?.selectedClass?.language?.id ?? 0,
    );
  }

  void showError(String msg) {
    showDialog(
      context: ctx!,
      builder: (_) => AlertDialog(
        title: const Text("Invalid File"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx!),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xls", "xlsx", "csv"],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    selectedFileName = file.name;
    notifyListeners();

    final bytes = file.bytes;
    if (bytes == null) {
      showError("Unable to read file");
      return;
    }

    validateAndParse(bytes, file.extension!);
  }

  Future<void> validateAndParse(Uint8List bytes, String ext) async {
    List<List<dynamic>> rows = [];

    try {
      if (ext == "csv") {
        final csvText = utf8.decode(bytes);
        rows = const CsvToListConverter().convert(csvText);
      } else {
        final excel = Excel.decodeBytes(bytes);
        final sheet = excel.tables[excel.tables.keys.first];
        if (sheet == null) {
          showError("Excel has no sheets.");
          return;
        }
        rows = sheet.rows.map((e) => e.map((c) => c?.value).toList()).toList();
      }
    } catch (e) {
      showError("Failed to read file.");
      return;
    }

    if (rows.isEmpty) {
      showError("Empty file.");
      return;
    }

    // Validate Header
    final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();

    if (!headers.contains("username") ||
        !headers.contains("activation code") &&
            !headers.contains("activation_code")) {
      showError("File must contain 'username' and 'activation_code' columns.");
      return;
    }
    final firstName = headers.indexOf("first_name");
    final surname = headers.indexOf("surname");
    final usernameIndex = headers.indexOf("username");
    final activationIndex = headers.indexWhere(
      (e) => e == "activation_code" || e == "activation code",
    );

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length <= usernameIndex || row.length <= activationIndex) {
        continue;
      }

      list.add(
        UserActivationModel(
          username: row[usernameIndex].toString(),
          activationCode: row[activationIndex].toString(),
          firstName: row[firstName].toString(),
          surname: row[surname].toString(),
        ),
      );
    }
  }

  Future<void> generateUsers(
    List<UserActivationModel> users,
    int school,
    int classId,
    int level,
  ) async {
    GlobalLoader.show();
    final client = SupabaseClientService.instance.client;

    try {
      for (final user in users) {
        final email = generateRandomEmail();

        // 1. Create Auth user
        final userAuth = await client.auth.admin.createUser(
          AdminUserAttributes(email: email, emailConfirm: true),
        );

        final userId = userAuth.user?.id ?? "";

        // 2. Insert user in main users table
        await client.from(DbTable.users).upsert({
          'user_id': userId,
          'first_name': user.firstName,
          'sur_name': user.surname,
          'email': email,
          'school': school,
          'last_login': null,
          'onboarding': false,
          'activation_code': user.activationCode,
          'is_activated': false,
          'username': user.username,
          'teacher_tag': null,
        });

        // 3. Insert student record
        await client.from(DbTable.student).upsert({
          'user_id': userId,
          'vocab': 0,
          'effort': 0,
          'score': 0,
          'language_level': level,
          'user_name': user.username,
        });

        await client.from(DbTable.studentClasses).upsert({
          'user': userId,
          'classes': classId,
        });
      }
      ctx!.pop();
      UsefullFunctions.showSnackBar(ctx!, 'User Created');
    } catch (e) {
      UsefullFunctions.showSnackBar(ctx!, "Error generating CSV: $e");
    } finally {
      GlobalLoader.hide();
      selectedLevel = null;
      selectedFileName = null;
      list = [];
      notifyListeners();
    }
  }
}
