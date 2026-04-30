import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/view_school/data/school_repo.dart';

class ViewSchoolViewModel extends ChangeNotifier {
  List<School>? school;
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController schoolEmailController = TextEditingController();
  TextEditingController schoolAddressController = TextEditingController();
  TextEditingController schoolPrincipalController = TextEditingController();
  TextEditingController schoolTelePhoneController = TextEditingController();

  bool showAddStudent = false;

  Uint8List? _imageBytes;
  bool _isDragging = false;

  Uint8List? get imageBytes => _imageBytes;
  bool get isDragging => _isDragging;

  final SchoolRepo _repo = SchoolRepo();

  bool loading = true;
  ViewSchoolViewModel() {
    init();
  }

  void toggleAddUser() {
    showAddStudent = !showAddStudent;

    notifyListeners();
  }

  toEditSchool(School school) {
    CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
      ctx!,
      listen: false,
    );
    commonViewModel.selectSchoolFromOutside(school);
    NavigationHelper.go(RouteNames.editSchool, extra: school.id);
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.show());
    school = await _repo.getSchoolData();
    loading = false;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((val) => GlobalLoader.hide());
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
    GlobalLoader.show();
    try {
      String school = '';
      school = schoolNameController.text.trim();
      await _repo.addSchool(
        imageBytes!,
        school,
        schoolPrincipalController.text.trim(),
        schoolAddressController.text.trim(),
        schoolEmailController.text.trim(),
        int.parse(schoolTelePhoneController.text.trim()),
        '${schoolNameController.text.trim()}.png',
      );
      reset();
      await init();

      UsefullFunctions.showAwesomeSnackbarContent(
        "School added successfully!",
        "Success",
        ContentType.success,
      );
      CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
        ctx!,
        listen: false,
      );
      await commonViewModel.getSchoolfromOutinit();
      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.hide(),
      );
      School newSchool = commonViewModel.schools
          .where((val) => val.schoolName == school)
          .first;
      toEditSchool(newSchool);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback(
        (val) => GlobalLoader.hide(),
      );
      log("Failed to add school: $e");
    }
  }

  reset() {
    _imageBytes = null;
    schoolNameController.clear();
    schoolPrincipalController.clear();
    schoolAddressController.clear();
    schoolTelePhoneController.clear();
    schoolEmailController.clear();
    notifyListeners();
  }

  Future<void> deleteSchool(BuildContext context, int? id) async {
    if (id == null) return;

    final bool? confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete School'),
        content: const Text(
          'If you delete this school, all related students, '
          'classes, and school data will also be permanently deleted.\n\n'
          'This action cannot be undone.',
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

    if (confirmed == true) {
      try {
        WidgetsBinding.instance.addPostFrameCallback(
          (val) => GlobalLoader.show(),
        );
        await _repo.deleteSchool(id);

        if (context.mounted) {
          CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
            ctx!,
            listen: false,
          );
          await commonViewModel.getSchoolfromOutinit();
          await init();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('School deleted successfully')),
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
}
