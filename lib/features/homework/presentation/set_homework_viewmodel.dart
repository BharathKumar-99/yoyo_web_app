import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/homework/data/homework_repo.dart';
import 'package:yoyo_web_app/features/homework/model/homework_model.dart';
import 'package:yoyo_web_app/features/settings/model/homework_config_model.dart';

import '../../../config/utils/popup_global.dart';
import '../../dashboard/presentation/dashboard_view_model.dart';

class SetHomeworkViewmodel extends ChangeNotifier {
  List<String> selectedStructure = [];
  List<String> selectedSubject = [];
  DateTime? selectedDate;
  TextEditingController anythingElseController = TextEditingController();
  bool isLoading = false;
  bool isschoolSelected = false;
  CommonViewModel commonViewModel;
  DashboardViewModel dashboardViewModel;
  final HomeworkRepo _repo = HomeworkRepo();
  List<HomeworkModel>? previousHomework = [];
  FilePickerResult? filePickerResult;
  FilePickerResult? setFilePickerResult;
  bool isEnabled = false;
  bool isByPrompt = true;

  void setIsByPrompt(bool val) {
    isByPrompt = val;
    notifyListeners();
  }

  final TextEditingController promptController = TextEditingController();
  final TextEditingController setPromptController = TextEditingController();

  String? fileName;
  String? setFileName;

  final List<String> structures = [
    "Conversation",
    "Present Tense",
    "Past Tense",
    "Future Tense",
    "Opinions",
    "Reasons",
    "Descriptions",
    "Questions",
    "Negatives",
    "Comparisons",
  ];

  final List<String> subjects = [
    "Myself",
    "Family",
    "Friends",
    "School",
    "Home",
    "Free Time",
    "Hobbies",
    "Food And Drink",
    "Holidays",
    "Town Local Area",
  ];

  bool useUploads = false;

  SetHomeworkViewmodel(this.commonViewModel, this.dashboardViewModel) {
    if (commonViewModel.selectedSchool?.id != null) listener();
    commonViewModel.addListener(listener);
  }

  listener() async {
    previousHomework = await _repo.getHomeWork(
      commonViewModel.selectedSchool?.id ?? 0,
    );
    await getHomeworkConfigs();
    previousHomework = previousHomework!
      ..sort((a, b) => b.setDate!.compareTo(a.setDate!));
    notifyListeners();
  }

  getHomeworkConfigs() async {
    HomeworkConfigModel? homeworkConfigModel = await _repo.getHomeworkConfigs(
      classId: commonViewModel.selectedClass?.id ?? 0,
    );

    isEnabled = homeworkConfigModel?.isAutoEnabled ?? false;
    promptController.text = homeworkConfigModel?.homeworkPrompt ?? '';
  }

  void selectStructure(String text) {
    if (selectedStructure.contains(text)) {
      selectedStructure.clear(); // deselect if same tapped
    } else {
      selectedStructure
        ..clear()
        ..add(text); // keep only one
    }
    notifyListeners();
  }

  void selectSubject(String text) {
    if (selectedSubject.contains(text)) {
      selectedSubject.remove(text);
    } else {
      if (selectedSubject.length >= 2) {
        selectedSubject.removeAt(0); // remove oldest
      }
      selectedSubject.add(text);
    }
    notifyListeners();
  }

  void pickDate(DateTime pickedDate) {
    selectedDate = pickedDate;
    notifyListeners();
  }

  Future<void> createHomework(BuildContext context) async {
    try {
      if (selectedDate == null) {
        throw "Select due date";
      }

      isLoading = true;
      notifyListeners();

      final int schoolId = commonViewModel.selectedSchool?.id ?? 0;
      final int classId = commonViewModel.selectedClass?.id ?? 0;
      final int languageId = commonViewModel.selectedClass?.language?.id ?? 0;

      final url = Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/add_homework',
      );

      final body = {
        "due_date": selectedDate!.toIso8601String(),
        "structures": selectedStructure,
        "subjects": selectedSubject,
        "anythingelse": anythingElseController.text.trim(),
        "schoolId": schoolId,
        "classId": classId,
        "phraseCount": 10,
        "languageId": languageId,
      };

      final response = await http.post(url, body: jsonEncode(body));

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        throw data['error'] ?? "Failed to create homework";
      }
      UserModel? model;
      if (commonViewModel.isAdmin) {
        List<UserModel> users = await _repo.getAllUsers(
          commonViewModel.selectedClass?.id ?? 0,
        );
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text("Select Teacher"),
            content: SizedBox(
              width: 400,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.username ?? ''),
                    subtitle: Text("${user.firstName} ${user.surName}"),
                    onTap: () async {
                      model = await commonViewModel.getCode(user.username!);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        );
      } else {
        model = await commonViewModel.getCode(commonViewModel.user!.username!);
      }

      // await _repo.sendNotification(commonViewModel.selectedClass?.id ?? 0);
      await _repo.addNotification(
        commonViewModel.selectedClass?.className ?? '',
        commonViewModel.selectedClass?.id ?? 0,
      );

      isLoading = false;
      notifyListeners();
      if (model != null) {
        PopupDialog.show(selectedDate!, model!, data['homework_id']);
      }
      selectedDate = null;
      selectedStructure.clear();
      selectedSubject.clear();
      anythingElseController.clear();
      await listener();
    } catch (e) {
      GlobalLoader.hide();
      debugPrint("Error: $e");
      isLoading = false;
      notifyListeners();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void setIsEnabled(bool val) async {
    isEnabled = val;
    GlobalLoader.show();
    await _repo.updateHomeworkAutoConfig(
      classId: commonViewModel.selectedClass?.id ?? 0,
      isAutoEnabled: isEnabled,
    );
    GlobalLoader.hide();
    notifyListeners();
  }

  Future<void> saveconfig(BuildContext context) async {
    try {
      if (promptController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter prompt"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      isLoading = true;
      notifyListeners();

      GlobalLoader.show();

      final int schoolId = commonViewModel.selectedSchool?.id ?? 0;
      final int classId = commonViewModel.selectedClass?.id ?? 0;

      await _repo.addAutoHomework(
        schoolId,
        classId,
        isEnabled,
        promptController.text.trim(),
        filePickerResult,
      );

      isLoading = false;
      notifyListeners();

      promptController.clear();
      filePickerResult = null;
      fileName = null;
      await getHomeworkConfigs();
      GlobalLoader.hide();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Auto homework saved successfully"),
          backgroundColor: Colors.green,
        ),
      );
      promptController.clear();

      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      filePickerResult = result;

      fileName = result.files.single.name;
      notifyListeners();
    }
  }

  Future<void> pickSetFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setFilePickerResult = result;

      setFileName = result.files.single.name;
      notifyListeners();
    }
  }

  void removeFile() {
    fileName = null;
    notifyListeners();
  }

  void removeSetFile() {
    setFileName = null;
    notifyListeners();
  }

  void saveSetHomework(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final data = await _repo.addSetHomework(
      prompt: setPromptController.text.trim(),
      file: setFilePickerResult,
      classId: commonViewModel.selectedClass?.id ?? 0,
      schoolId: commonViewModel.selectedSchool?.id ?? 0,
      useUploads: useUploads,
    );
    setPromptController.clear();
    setFilePickerResult = null;
    setFileName = null;
    notifyListeners();

    UserModel? model;
    if (commonViewModel.isAdmin) {
      List<UserModel> users = await _repo.getAllUsers(
        commonViewModel.selectedClass?.id ?? 0,
      );
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text("Select a user to login as"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.username ?? ''),
                  subtitle: Text("${user.firstName} ${user.surName}"),
                  onTap: () async {
                    model = await commonViewModel.getCode(user.username!);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      model = await commonViewModel.getCode(commonViewModel.user!.username!);
    }

    // await _repo.sendNotification(commonViewModel.selectedClass?.id ?? 0);
    await _repo.addNotification(
      commonViewModel.selectedClass?.className ?? '',
      commonViewModel.selectedClass?.id ?? 0,
    );

    GlobalLoader.hide();
    isLoading = false;
    notifyListeners();
    if (model != null) {
      PopupDialog.show(
        DateTime.now().add(Duration(days: 7)),
        model!,
        data['homework_id'],
      );
    }
    setPromptController.clear();
    setFilePickerResult = null;
    setFileName = null;
    notifyListeners();
    await listener();
  }

  void setUseUploads(bool v) {
    useUploads = v;
    notifyListeners();
  }
}
