import 'dart:math';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/core/supabase/supabase_client.dart';
import 'package:yoyo_web_app/features/add_user_name/data/add_user_name_repo.dart';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import '../../../config/router/navigation_helper.dart';
import '../../add_user/model/level.dart';
import '../../home/model/classes_model.dart';
import '../../home/model/school.dart';
import '../model/add_user_from_excel.dart';

class AddUserNameViewModel extends ChangeNotifier {
  List<School>? school = [];
  List<Level> level = [];
  School? selectedSchool;
  Classes? selectedClasses;
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
    if (commonViewModel?.teacher?.teacher != null &&
        (school?.isNotEmpty ?? false)) {
      selectSchools(
        school?.firstWhere(
          (tes) => tes.id == commonViewModel!.teacher!.schools?.id,
        ),
      );
    }
    notifyListeners();
  }

  void selectSchools(School? val) {
    selectedSchool = val;
    notifyListeners();
  }

  void selectClass(Classes? val) {
    selectedClasses = val;
    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    notifyListeners();
  }

  createUser() async {
    if (selectedSchool == null) {
      return UsefullFunctions.showSnackBar(ctx!, "Select School");
    }
    if (selectedClasses == null) {
      return UsefullFunctions.showSnackBar(ctx!, "Select Class");
    }
    if (selectedLevel == null) {
      return UsefullFunctions.showSnackBar(ctx!, "Select USer Language Level");
    }
    await generateUsers(
      list,
      selectedSchool?.id ?? 0,
      selectedClasses?.id ?? 0,
      selectedLevel?.id ?? 0,
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
        ),
      );
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

  Future<void> generateUsers(
    List<UserActivationModel> users,
    int school,
    int classId,
    int level,
  ) async {
    GlobalLoader.show();
    final client = SupabaseClientService.instance.client;

    // 📌 Store rows for CSV
    List<Map<String, dynamic>> csvRows = [];

    try {
      for (final user in users) {
        final email = generateRandomEmail();

        // 1. Create Auth user
        final userAuth = await client.auth.admin.createUser(
          AdminUserAttributes(email: email, emailConfirm: true),
        );

        final userId = userAuth.user?.id ?? "";

        // 2. Insert user in main users table
        await client.from(DbTable.users).insert({
          'user_id': userId,
          'first_name': null,
          'sur_name': null,
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
        await client.from(DbTable.student).insert({
          'user_id': userId,
          'class': classId,
          'vocab': 0,
          'effort': 0,
          'score': 0,
          'language_level': level,
          'user_name': user.username,
        });

        // 4. Add row for CSV (firstname, surname empty)
        csvRows.add({
          "user_name": user.username,
          "activation_code": user.activationCode,
          "first_name": "",
          "sur_name": "",
        });
      }

      final csvHeader = [
        "user_name",
        "activation_code",
        "first_name",
        "sur_name",
      ];

      // Create a List of Lists of dynamic types for the converter
      final List<List<dynamic>> csvData = [
        csvHeader,
        ...csvRows.map(
          (row) => [
            row["user_name"],
            row["activation_code"],
            row["first_name"],
            row["sur_name"],
          ],
        ),
      ];

      final csv = const ListToCsvConverter().convert(csvData);

      final bytes = utf8.encode(csv);
      final uint8List = Uint8List.fromList(bytes);

      final jsUint8 = uint8List.toJS;
      final jsArray = <web.BlobPart>[jsUint8].toJS;

      final blob = web.Blob(jsArray, web.BlobPropertyBag(type: "text/csv"));

      final urlBlob = web.URL.createObjectURL(blob);

      final anchor = web.HTMLAnchorElement()
        ..href = urlBlob
        ..download = "students.csv";

      anchor.click();

      web.URL.revokeObjectURL(urlBlob);
    } catch (e) {
      UsefullFunctions.showSnackBar(ctx!, "Error generating CSV: $e");
    } finally {
      GlobalLoader.hide();
      selectedClasses = null;
      selectedSchool = null;
      selectedLevel = null;
      selectedFileName = null;
      list = [];
      notifyListeners();
    }
  }
}
