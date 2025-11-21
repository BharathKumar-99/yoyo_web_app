import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/add_user_name/data/add_user_name_repo.dart';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:http/http.dart' as http;
import '../../../config/router/navigation_helper.dart';
import '../../add_user/model/level.dart';
import '../../home/model/classes_model.dart';
import '../../home/model/school.dart';

class AddUserNameViewModel extends ChangeNotifier {
  List<School>? school = [];
  List<Level> level = [];
  School? selectedSchool;
  Classes? selectedClasses;
  Level? selectedLevel;
  final AddUserNameRepo _repo = AddUserNameRepo();
  TextEditingController userCount = TextEditingController();

  AddUserNameViewModel() {
    init();
  }

  Future<void> init() async {
    school = await _repo.getAllSchool();
    level = await _repo.getAllLevel();
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
    if (userCount.text.toString().trim().isEmpty) {
      return UsefullFunctions.showSnackBar(ctx!, "Enter User Count");
    }
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
      int.parse(userCount.text.trim().toString()),
      selectedSchool?.id ?? 0,
      selectedClasses?.id ?? 0,
      selectedLevel?.id ?? 0,
    );
  }

  Future<void> generateUsers(
    int userCountNumber,
    int school,
    int classId,
    int level,
  ) async {
    GlobalLoader.show();

    try {
      final url = Uri.parse(
        "https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/create_username",
      );

      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_SUPABASE_ANON_KEY",
        },
        body: jsonEncode({
          "user_count": userCountNumber,
          "school_id": school,
          "class_id": classId,
          "user_level": level,
        }),
      );

      if (res.statusCode != 200) {
        print("❌ Error ${res.statusCode}: ${res.body}");
        return;
      }

      final data = jsonDecode(res.body);
      final csv = data["csv"];

      if (csv == null) {
        print("❌ No CSV returned!");
        return;
      }

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
      userCount.clear();
      selectedClasses = null;
      selectedSchool = null;
      selectedLevel = null;
    }
  }
}
