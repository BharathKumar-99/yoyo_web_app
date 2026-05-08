import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/settings/model/ai_prompt_model.dart';
import 'package:yoyo_web_app/features/settings/repo/settings_repo.dart';

import '../model/homework_config_model.dart';

class SettingsViewModel extends ChangeNotifier {
  HomeworkConfigModel? homeworkConfigModel;
  final CommonViewModel commonViewModel;
  AiPrompt? aiPrompt;
  TextEditingController phrasePromptController = TextEditingController();
  TextEditingController setHomeworkPromptController = TextEditingController();
  TextEditingController autoHomeworkPromptController = TextEditingController();
  TextEditingController docHomeworkPromptController = TextEditingController();
  bool isPhrasePromptChanged = false;
  bool isSetHomeworkPromptChanged = false;
  bool isAutoHomeworkPromptChanged = false;
  bool isDocHomeworkPromptChanged = false;

  String selectedManualCadance = 'Weekly from time of setting';
  List<String> manualCadance = [
    'Daily from first day',
    'Weekly from time of setting',
    'Bi-Weekly from time of settings',
  ];

  String selectedAutoCadance = 'Every Thursday';

  List<String> autoCadance = [
    'Every Sunday',
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
  ];

  String selectedAutoCadanceTime = '2 PM';
  List<String> autoCandanceTime = [
    '12 AM',
    '1 AM',
    '2 AM',
    '3 AM',
    '4 AM',
    '5 AM',
    '6 AM',
    '7 AM',
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
    '6 PM',
    '7 PM',
    '8 PM',
    '9 PM',
    '10 PM',
    '11 PM',
  ];

  String selectedNotification = '1 Day Before';
  List<String> notification = ['1 Day Before', '2 Days Before'];

  final SettingsRepo _repo = SettingsRepo();

  SettingsViewModel({required this.commonViewModel}) {
    init();
  }

  init() async {
    aiPrompt = await _repo.getAiPrompt();
    homeworkConfigModel = await _repo.getHomeworkConfigs(
      classId: commonViewModel.selectedClass?.id ?? 0,
    );
    if (aiPrompt != null) {
      phrasePromptController.text = aiPrompt!.phrasePrompt ?? '';
      setHomeworkPromptController.text = aiPrompt!.setHomeworkPromt ?? '';
      autoHomeworkPromptController.text = aiPrompt!.autoHomeworkPrompt ?? '';
      docHomeworkPromptController.text = aiPrompt!.docHomeworkPrompt ?? '';
    }
    if (homeworkConfigModel != null) {
      selectedManualCadance = homeworkConfigModel!.manualCadence ?? '';
      selectedAutoCadance = homeworkConfigModel!.autoCadence ?? '';
      selectedNotification = homeworkConfigModel!.notification ?? '';
      selectedAutoCadanceTime = homeworkConfigModel!.autoCadenceTime ?? '';
    }
    notifyListeners();
  }

  void setManualCadance(String value) async {
    selectedManualCadance = value;
    notifyListeners();
    updateConfig();
  }

  void setAutoCadance(String value) async {
    selectedAutoCadance = value;
    notifyListeners();
    updateConfig();
  }

  void setAutoCadanceTime(String value) async {
    selectedAutoCadanceTime = value;
    notifyListeners();
    updateConfig();
  }

  void setNotification(String value) async {
    selectedNotification = value;
    notifyListeners();
    updateConfig();
  }

  updateConfig() async {
    GlobalLoader.show();
    await _repo.updateHomeworkConfigs(
      manualCadance: selectedManualCadance,
      autoCadance: selectedAutoCadance,
      autoCadanceTime: selectedAutoCadanceTime,
      notification: selectedNotification,
      schoolId: commonViewModel.selectedSchool?.id ?? 0,
      classId: commonViewModel.selectedClass?.id ?? 0,
    );
    GlobalLoader.hide();
  }

  void setActivationCodeThroughTeacher(bool v) async {
    try {
      GlobalLoader.show();
      commonViewModel.selectedClass?.activationCodeThroughTeacher = v;
      await _repo.updateClassActivation(
        v,
        commonViewModel.selectedClass?.id ?? 0,
      );
      //  await commonViewModel.getSchools();
      notifyListeners();
    } finally {
      GlobalLoader.hide();
    }
  }

  void updateAiPrompt() async {
    GlobalLoader.show();
    await _repo.updateAiPrompt(
      phrasePrompt: phrasePromptController.text,
      setHomeworkPrompt: setHomeworkPromptController.text,
      autoHomeworkPrompt: autoHomeworkPromptController.text,
      docHomeworkPrompt: docHomeworkPromptController.text,
    );
    aiPrompt = await _repo.getAiPrompt();
    if (aiPrompt != null) {
      phrasePromptController.text = aiPrompt!.phrasePrompt ?? '';
      setHomeworkPromptController.text = aiPrompt!.setHomeworkPromt ?? '';
      autoHomeworkPromptController.text = aiPrompt!.autoHomeworkPrompt ?? '';
      docHomeworkPromptController.text = aiPrompt!.docHomeworkPrompt ?? '';
    }
    isAutoHomeworkPromptChanged = false;
    isPhrasePromptChanged = false;
    isSetHomeworkPromptChanged = false;
    isDocHomeworkPromptChanged = false;
    notifyListeners();
    GlobalLoader.hide();
  }

  void checkPhrasePromptChange() {
    isPhrasePromptChanged =
        phrasePromptController.text != aiPrompt?.phrasePrompt;
    notifyListeners();
  }

  void checkSetHomeworkPromptChange() {
    isSetHomeworkPromptChanged =
        setHomeworkPromptController.text != aiPrompt?.setHomeworkPromt;
    notifyListeners();
  }

  void checkAutoHomeworkPromptChange() {
    isAutoHomeworkPromptChanged =
        autoHomeworkPromptController.text != aiPrompt?.autoHomeworkPrompt;
    notifyListeners();
  }

  void setAllowTeachersToSetCategories(bool v) async {
    try {
      GlobalLoader.show();
      commonViewModel.selectedClass?.allowTeachersToSetCategories = v;
      await _repo.updateClassAllowTeachersToSetCategories(
        v,
        commonViewModel.selectedClass?.id ?? 0,
      );
      //  await commonViewModel.getSchools();
      notifyListeners();
    } finally {
      GlobalLoader.hide();
    }
  }

  void setAllowTeachersToSetPhrases(bool v) async {
    try {
      GlobalLoader.show();
      commonViewModel.selectedClass?.allowTeachersToSetPhrases = v;
      await _repo.updateClassAllowTeachersToSetPhrases(
        v,
        commonViewModel.selectedClass?.id ?? 0,
      );
      //  await commonViewModel.getSchools();
      notifyListeners();
    } finally {
      GlobalLoader.hide();
    }
  }

  void setAllowTeachersToSetBulkPhrases(bool v) async {
    try {
      GlobalLoader.show();
      commonViewModel.selectedClass?.allowTeachersToSetBulkPhrases = v;
      await _repo.updateClassAllowTeachersToSetBulkPhrases(
        v,
        commonViewModel.selectedClass?.id ?? 0,
      );
      //  await commonViewModel.getSchools();
      notifyListeners();
    } finally {
      GlobalLoader.hide();
    }
  }

  void checkDocHomeworkPromptChange() {
    isDocHomeworkPromptChanged =
        docHomeworkPromptController.text != aiPrompt?.docHomeworkPrompt;
    notifyListeners();
  }
}
