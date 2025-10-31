import 'dart:developer';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/add_school/data/add_school_repo.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';

class AddSchoolViewModel extends ChangeNotifier {
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController schoolAddressController = TextEditingController();
  TextEditingController schoolPrincipalController = TextEditingController();
  TextEditingController schoolTelePhoneController = TextEditingController();
  TextEditingController schoolNoOfStudentsController = TextEditingController();
  List<Language>? languageList = [];
  List<Language> selectedLanguageList = [];
  final AddSchoolRepo _repo = AddSchoolRepo();

  Uint8List? _imageBytes;
  bool _isDragging = false;

  Uint8List? get imageBytes => _imageBytes;
  bool get isDragging => _isDragging;

  AddSchoolViewModel() {
    init();
  }

  init() async {
    languageList = await _repo.getLanguages();
    notifyListeners();
  }

  void selectLanguage(bool? val, Language? language) {
    if (val == true) {
      selectedLanguageList.add(language!);
    } else {
      selectedLanguageList.remove(language);
    }
    notifyListeners();
  }

  /// Pick image using file picker
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      _imageBytes = result.files.single.bytes;
      notifyListeners();
    }
  }

  /// Handle drag enter
  void onDragEntered() {
    _isDragging = true;
    notifyListeners();
  }

  /// Handle drag leave
  void onDragExited() {
    _isDragging = false;
    notifyListeners();
  }

  /// Handle drop
  void onDrop(Uint8List data) {
    _isDragging = false;
    _imageBytes = data;
    notifyListeners();
  }

  void clear() {
    _imageBytes = null;
    notifyListeners();
  }

  bool validateForm() {
    if (schoolNameController.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please enter school name",
        "Error",
        ContentType.failure,
      );

      return false;
    }
    if (schoolAddressController.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please enter school address",
        "Error",
        ContentType.failure,
      );
      return false;
    }
    if (schoolTelePhoneController.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please enter school telephone number",
        "Error",
        ContentType.failure,
      );

      return false;
    }
    if (schoolPrincipalController.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please enter school Principal",
        "Error",
        ContentType.failure,
      );

      return false;
    }
    if (schoolNoOfStudentsController.text.trim().isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please enter number of students",
        "Error",
        ContentType.failure,
      );
      return false;
    }
    if (selectedLanguageList.isEmpty) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please select at least one language",
        "Error",
        ContentType.failure,
      );

      return false;
    }
    if (_imageBytes == null) {
      UsefullFunctions.showAwesomeSnackbarContent(
        "Please select an image",
        "Error",
        ContentType.failure,
      );
      return false;
    }
    return true;
  }

  Future<void> addSchool() async {
    if (!validateForm()) return;

    try {
      _repo.addSchool(
        imageBytes!,
        schoolNameController.text.trim(),
        schoolPrincipalController.text.trim(),
        schoolAddressController.text.trim(),
        int.parse(schoolTelePhoneController.text.trim()),
        int.parse(schoolNoOfStudentsController.text.trim()),
        selectedLanguageList,
        '${schoolNameController.text.trim()}.png',
      );
      reset();
      UsefullFunctions.showAwesomeSnackbarContent(
        "School added successfully!",
        "Success",
        ContentType.success,
      );
    } catch (e) {
      log("Failed to add school: $e");
    }
  }

  reset() {
    _imageBytes = null;
    schoolNameController.clear();
    schoolPrincipalController.clear();
    schoolAddressController.clear();
    schoolTelePhoneController.clear();
    schoolNoOfStudentsController.clear();
    selectedLanguageList.clear();
    notifyListeners();
  }
}
