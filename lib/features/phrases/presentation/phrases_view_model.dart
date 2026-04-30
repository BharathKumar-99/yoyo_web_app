import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/data/phrases_repo.dart';

import '../../home/model/class_level_model.dart';
import '../../home/model/classes_model.dart';
import '../../home/model/phrases_model.dart';
import '../model/phrases_categories.dart';

class PhrasesViewModel extends ChangeNotifier {
  final PhrasesRepo _repo = PhrasesRepo();
  TextEditingController addCategoryController = TextEditingController();
  TextEditingController addPhrase = TextEditingController();
  TextEditingController addQuestionsPhrase = TextEditingController();
  List<PhraseModel> phrases = [];
  List<Language> launguages = [];
  List<PhraseCategories> phraseCategories = [];
  PhraseCategories? selectedPhraseCategories;
  List<Level> lvl = [];
  final player = AudioPlayer();
  String? selectedLaunguage;
  Level? selectedLevel;
  int currentPlayingPhraseId = -1;
  CommonViewModel commonViewModel;
  Language? selectedLanguage;
  List<String> phraseTypes = ['Standard', 'Question', 'Listening', 'Reading'];
  String? selectedPhraseType;
  bool isloading = false;
  FilePickerResult? filePickerResult;
  String? fileName;
  bool useUploads = false;

  PhrasesViewModel(this.commonViewModel) {
    commonViewModel.addListener(_onSchoolChange);
    init();
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.playing == false) {
        currentPlayingPhraseId = -1;
        notifyListeners();
      } else if (state.playing) {
        notifyListeners();
      }
    });
  }

  TextEditingController buildPromptController = TextEditingController();
  TextEditingController promptCountController = TextEditingController(
    text: "10",
  );

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    PhraseModel? lastPhrase = await _repo.getLastCategories();

    addCategoryController.clear();
    launguages =
        commonViewModel.selectedSchool?.classes
            ?.map((e) => e.language!)
            .toList() ??
        [];
    launguages = launguages.toSet().toList();
    selectedLanguage = launguages.isNotEmpty ? launguages[0] : null;

    phraseCategories = await _repo.getPhraseCategories(
      commonViewModel.selectedSchool?.id ?? 0,
    );

    phraseCategories = commonViewModel.selectedClass == null
        ? phraseCategories
        : phraseCategories = phraseCategories
              .where(
                (cat) =>
                    cat.language == commonViewModel.selectedClass?.language?.id,
              )
              .toList();

    selectedPhraseCategories = phraseCategories.isNotEmpty
        ? lastPhrase == null
              ? phraseCategories[0]
              : phraseCategories
                    .where((val) => val.id == lastPhrase.categories)
                    .firstOrNull
        : null;
    lvl = [];
    for (Classes classes in commonViewModel.selectedSchool?.classes ?? []) {
      for (ClassLevel element in classes.classLevel ?? []) {
        if (!lvl.contains(element.levelModel)) lvl.add(element.levelModel!);
      }
    }

    selectedLevel = lvl.isNotEmpty ? lvl[0] : null;
    selectedPhraseType = phraseTypes[0];
    phrases = await _repo.getPhrasesDetails(
      phraseCategories.map((e) => e.id ?? 0).toList(),
    );
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<void> playPhrase(String url, int index) async {
    if (player.playing && currentPlayingPhraseId == index) {
      await player.stop();
      currentPlayingPhraseId = -1;
      notifyListeners();
      return;
    }

    if (player.playing) {
      await player.stop();
    }

    currentPlayingPhraseId = index;
    notifyListeners();

    await player.setUrl(url);
    await player.play();
  }

  changeLanguage(String val) {
    selectedLaunguage = val;
  }

  selectPhraseCategories(PhraseCategories? val) {
    selectedPhraseCategories = val;
  }

  changeLvl(Level? val) {
    selectedLevel = val;
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      filePickerResult = result;

      fileName = result.files.single.name;
      notifyListeners();
    }
  }

  Future<void> removePhrase(int? id, String? url) async {
    if (id == null || url == null) return;

    final bool? confirmDelete = await showDialog<bool>(
      context: ctx!,
      builder: (context) => AlertDialog(
        title: const Text('Delete Phrase'),
        content: const Text('Are you sure you want to delete this phrase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      _repo.deletePhrase(id, url);
      ScaffoldMessenger.of(ctx!).showSnackBar(
        const SnackBar(content: Text('Phrase deleted successfully')),
      );
    }
  }

  void removeFile() {
    fileName = null;
    notifyListeners();
  }

  disablePhrase(int phraseId, List<int> schoolId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _repo.disablePharase(phraseId, schoolId);
    await init();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void disableCategories(bool val) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _repo.disableCategories(val, selectedPhraseCategories?.id ?? 0);
    selectedPhraseCategories = null;
    await init();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void addCategory() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _repo.addCategory(
      addCategoryController.text.toString(),
      commonViewModel.selectedSchool?.id ?? 0,
      commonViewModel.selectedClass?.language?.id ?? 0,
    );
    await init();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void selectLanguage(Language? val) {
    selectedLanguage = val;
    notifyListeners();
  }

  void _onSchoolChange() async {
    await init();
  }

  void toggleCategoryActive(PhraseCategories category, bool v) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _repo.disableCategories(v, category.id ?? 0);
    await init();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void selectType(String? val) {
    selectedPhraseType = val;
    notifyListeners();
  }

  bool _hasInvalidForm() {
    return addPhrase.text.isEmpty ||
        (selectedPhraseType == 'Question' && addQuestionsPhrase.text.isEmpty) ||
        selectedPhraseCategories == null ||
        selectedLanguage == null;
  }

  void _showError() {
    ScaffoldMessenger.of(
      ctx!,
    ).showSnackBar(const SnackBar(content: Text('Please fill all the fields')));
  }

  Future<void> addPhrases(BuildContext context) async {
    if (_hasInvalidForm()) {
      _showError();
      return;
    }

    isloading = true;
    notifyListeners();

    try {
      final newPhrase = await _repo.addPhrases(
        addPhrase.text,
        addQuestionsPhrase.text,
        selectedPhraseType ?? '',
        selectedPhraseCategories!.id!,

        selectedLanguage!.id!,
      );

      // 🔹 Fire & forget webhook
      unawaited(
        _repo.callWebhook(
          newPhrase.id!,
          newPhrase.phrase!,
          newPhrase.language!,
          newPhrase.question,
        ),
      );
      await init();
      // 🔹 Listen for completion (non-blocking)
      _repo.listenForPhraseCompletion(
        newPhrase.id!,
        onCompleted: () async {
          await init();
          isloading = false;
          notifyListeners();
        },
      );

      _resetForm();
    } catch (e) {
      isloading = false;
      notifyListeners();
    }
  }

  void _resetForm() {
    addPhrase.clear();
    addQuestionsPhrase.clear();

    selectedLanguage = launguages.isNotEmpty ? launguages[0] : null;
    selectedLevel = lvl.isNotEmpty ? lvl[0] : null;
    selectedPhraseType = phraseTypes[0];
    selectedPhraseCategories = phraseCategories.isNotEmpty
        ? phraseCategories[0]
        : null;
  }

  Future<void> deleteCategories(int id) async {
    if (ctx == null) return;

    final hasPhrases = phrases.any((val) => val.categories == id);

    bool shouldDelete = true;

    if (hasPhrases) {
      shouldDelete =
          await showDialog<bool>(
            context: ctx!,
            barrierDismissible: false,
            builder: (c) => AlertDialog.adaptive(
              title: const Text('Are you sure?'),
              content: const Text(
                'All the phrases in this category will be deleted.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    if (!shouldDelete) return;

    GlobalLoader.show();

    try {
      await _repo.deletePhrases(id);
      await _repo.deleteCategories(id);
      await init();
    } catch (e) {
      debugPrint('Delete category failed: $e');
    } finally {
      GlobalLoader.hide();
    }
  }

  Future<void> saveconfig(BuildContext context) async {
    try {
      isloading = true;
      notifyListeners();

     final data= await _repo.generatePhrases(
        prompt: buildPromptController.text.trim(),
        useUploads: useUploads,
        fileResult: filePickerResult,
        categoryId: selectedPhraseCategories?.id ?? 0,
        languageId: selectedLanguage?.id ?? 0,
        phraseCount: int.tryParse(promptCountController.text.trim()) ?? 10,
      );

      await init();
      // 🔹 Listen for completion (non-blocking)
      final List<dynamic> inserted = data['inserted'] ?? [];
      final List<int> phraseIds = inserted.map((e) => e['id'] as int).toList();

      if (phraseIds.isNotEmpty) {
        _repo.listenForPhraseGroupCompletion(
          phraseIds,
          onCompleted: () async {
            await init();
            isloading = false;
            notifyListeners();
          },
        );
      } else {
        isloading = false;
      }

      buildPromptController.clear();
      useUploads = false;
      filePickerResult = null;
      fileName = null;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void setUseUploads(bool v) {
    useUploads = v;
    notifyListeners();
  }
}
