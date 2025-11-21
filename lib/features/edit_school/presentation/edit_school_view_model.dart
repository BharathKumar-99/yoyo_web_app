import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/edit_school/data/edit_school_repo.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';

import '../../../config/utils/global_loader.dart';
import '../../home/model/school.dart';

class EditSchoolViewModel extends ChangeNotifier {
  int id;
  School? school;
  late RemoteConfig apiCred;
  final EditSchoolRepo _repo = EditSchoolRepo();
  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolAdrs = TextEditingController();
  TextEditingController schoolTelephone = TextEditingController();
  TextEditingController schoolPrinciple = TextEditingController();
  TextEditingController schoolStudents = TextEditingController();
  Uint8List? selectedImageBytes;
  bool loading = true;

  EditSchoolViewModel(this.id) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    school = await _repo.getSchool(id);
    apiCred = await _repo.getRemoteConfig(id);
    schoolName.text = school?.schoolName ?? '';
    schoolAdrs.text = school?.schoolAddress ?? '';
    schoolTelephone.text = school?.schoolTelephoneNo.toString() ?? '';
    schoolPrinciple.text = school?.principle ?? '';
    schoolStudents.text = school?.noOfStudents.toString() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    loading = false;
    notifyListeners();
  }

  updateImage(FilePickerResult? result) {
    if (result != null && result.files.isNotEmpty) {
      selectedImageBytes = result.files.first.bytes!;
      notifyListeners();
    }
  }

  Future<void> updateStreakEnabled(bool value) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      apiCred = await _repo.updateStreakEnabled(value);
      notifyListeners();
    } catch (e, st) {
      log("updateStreakEnabled error: $e\n$st");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void updateSlack(LanguageSlack lang) async {
    try {
      apiCred.slack = lang;
      apiCred = await _repo.updateRemote(apiCred);
      notifyListeners();
    } catch (e) {
      log("updateSlack error: $e");
    }
  }

  void updateSchool() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      final schoolNameText = schoolName.text.trim();
      final address = schoolAdrs.text.trim();
      final telephone = schoolTelephone.text.trim();
      final principle = schoolPrinciple.text.trim();
      final numberOfstudents = schoolStudents.text.trim();
      String image = school?.image ?? '';
      if (selectedImageBytes != null) {
        image = await _repo.getSupabaseUrl(selectedImageBytes!, schoolNameText);
      }
      School? updatedSchool = school;

      if (schoolNameText.trim().isNotEmpty) {
        updatedSchool?.schoolName = schoolNameText;
      }
      if (address.trim().isNotEmpty) {
        updatedSchool?.schoolAddress = address;
      }
      if (telephone.trim().isNotEmpty) {
        updatedSchool?.schoolTelephoneNo = int.parse(telephone);
      }
      if (principle.trim().isNotEmpty) {
        updatedSchool?.principle = principle;
      }
      if (numberOfstudents.trim().isNotEmpty) {
        updatedSchool?.noOfStudents = int.parse(numberOfstudents);
      }
      updatedSchool?.image = image;

      school = await _repo.updateSchool(updatedSchool);
      notifyListeners();
    } catch (e) {
      log("school error: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }
}
