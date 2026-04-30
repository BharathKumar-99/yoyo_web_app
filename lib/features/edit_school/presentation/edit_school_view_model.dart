import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/data/edit_school_repo.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';

import '../../../config/utils/global_loader.dart';
import '../../home/model/school.dart';

class EditSchoolViewModel extends ChangeNotifier {
  RemoteConfig? apiCred;
  final EditSchoolRepo _repo = EditSchoolRepo();
  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolAdrs = TextEditingController();
  TextEditingController schoolTelephone = TextEditingController();
  TextEditingController schoolPrinciple = TextEditingController();
  TextEditingController schoolStudents = TextEditingController();
  TextEditingController schoolEmail = TextEditingController();
  TextEditingController className = TextEditingController();
  TextEditingController passThreshold = TextEditingController();
  TextEditingController lowerThreshold = TextEditingController();
  List<Language> languages = [];
  Language? selectedLanguage;
  String? selectedYear;
  Uint8List? selectedImageBytes;
  bool loading = true;
  bool addClass = false;
  CommonViewModel commonViewModel;
  EditSchoolViewModel(this.commonViewModel) {
    commonViewModel.addListener(_onSchoolChange);
    init();
  }

  void _onSchoolChange() async {
    await init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    if (commonViewModel.selectedSchool == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      return;
    }
    apiCred = await _repo.getRemoteConfig(
      commonViewModel.selectedSchool?.id ?? 0,
    );
    lowerThreshold.text = apiCred?.lowerThreshold.toString() ?? '0';
    passThreshold.text = apiCred?.successThreshold.toString() ?? '0';
    schoolName.text = commonViewModel.selectedSchool?.schoolName ?? '';
    schoolAdrs.text = commonViewModel.selectedSchool?.schoolAddress ?? '';
    schoolEmail.text = commonViewModel.selectedSchool?.schoolEmail ?? '';
    schoolTelephone.text =
        commonViewModel.selectedSchool?.schoolTelephoneNo.toString() ?? '';
    schoolPrinciple.text = commonViewModel.selectedSchool?.principle ?? '';
    schoolStudents.text =
        commonViewModel.selectedSchool?.noOfStudents.toString() ?? '';
    languages = await _repo.getLanguage();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    loading = false;
    notifyListeners();
  }

  selectLang(Language? val) {
    selectedLanguage = val;
    notifyListeners();
  }

  updateImage(FilePickerResult? result) {
    if (result != null && result.files.isNotEmpty) {
      selectedImageBytes = result.files.first.bytes!;
      notifyListeners();
    }
  }

  Future<void> updateStreakEnabled(bool value, int school) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      apiCred = await _repo.updateStreakEnabled(value, school);
      notifyListeners();
    } catch (e, st) {
      log("updateStreakEnabled error: $e\n$st");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  Future<void> updateMasterEnabled(bool value, int school) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      apiCred = await _repo.updateMasteryEnabled(value, school);
      notifyListeners();
    } catch (e, st) {
      log("updateMasteryEnabled error: $e\n$st");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  Future<void> updateWarmupEnabled(bool value, int school) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      apiCred = await _repo.updateWarmupEnabled(value, school);
      notifyListeners();
    } catch (e, st) {
      log("updateWarmupEnabled error: $e\n$st");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void updateSlack(LanguageSlack lang) async {
    try {
      apiCred?.slack = lang;
      apiCred = await _repo.updateRemote(apiCred!);
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
      String image = commonViewModel.selectedSchool?.image ?? '';
      if (selectedImageBytes != null) {
        image = await _repo.getSupabaseUrl(selectedImageBytes!, schoolNameText);
      }
      School? updatedSchool = commonViewModel.selectedSchool;

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

      commonViewModel.selectedSchool = await _repo.updateSchool(updatedSchool);
      notifyListeners();
    } catch (e) {
      log("school error: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void toggleAddClass() {
    addClass = !addClass;
    notifyListeners();
  }

  Future<void> addClasses() async {
    try {
      GlobalLoader.show();
      final name = className.text.trim();
      if (name.isEmpty || selectedLanguage == null || selectedYear == null) {
        UsefullFunctions.showAwesomeSnackbarContent(
          'Please add required fields',
          'Error',
          ContentType.failure,
        );
        return;
      }

      await _repo.addClass(
        name,
        selectedLanguage?.id,
        int.parse(selectedYear!),
        commonViewModel.selectedSchool?.id,
      );
      className.clear();
      selectedLanguage = null;
      selectedYear = null;
      notifyListeners();
      UsefullFunctions.showAwesomeSnackbarContent(
        'Class Added',
        'Success',
        ContentType.success,
      );
      await commonViewModel.getSchoolfromOut(commonViewModel.selectedSchool);
    } catch (e) {
      log("Error Class:$e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void updateClass(String name, int id) async {
    try {
      GlobalLoader.show();
      await _repo.updateClass(name, id);
      UsefullFunctions.showAwesomeSnackbarContent(
        'Class Updated',
        'Success',
        ContentType.success,
      );
      await commonViewModel.getSchoolfromOut(commonViewModel.selectedSchool);
    } catch (e) {
      log("Error Class:$e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void updatePass() async {
    try {
      GlobalLoader.show();
      await _repo.updatePass(int.parse(passThreshold.text), apiCred?.id);
    } catch (e) {
      log(e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void updateLow() async {
    try {
      GlobalLoader.show();
      await _repo.updateLow(int.parse(lowerThreshold.text), apiCred?.id);
    } catch (e) {
      log(e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  Future<void> confirmDeleteClass(BuildContext context, int classId) async {
    final bool? confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete Class'),
        content: const Text(
          'Deleting this class will permanently remove all students '
          'and their data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.show(),
      );
      await _repo.deleteClass(classId);
      await commonViewModel.getSchoolfromOut(commonViewModel.selectedSchool);
      await init();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.hide(),
      );
    }
  }
}
