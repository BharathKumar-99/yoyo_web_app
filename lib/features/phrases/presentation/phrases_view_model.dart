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

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    launguages =
        commonViewModel.selectedSchool?.schoolLanguage
            ?.map((e) => e.language!)
            .toList() ??
        [];
    selectedLanguage = launguages.isNotEmpty ? launguages[0] : null;

    phraseCategories = await _repo.getPhraseCategories(
      commonViewModel.selectedSchool?.id ?? 0,
    );
    selectedPhraseCategories = phraseCategories.isNotEmpty
        ? phraseCategories[0]
        : null;
    lvl = [];
    for (Classes classes in commonViewModel.selectedSchool?.classes ?? []) {
      for (ClassLevel element in classes.classLevel ?? []) {
        lvl.add(element.levelModel!);
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
      selectedLanguage?.id ?? 0,
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

  addPhrases() async {
    if (addPhrase.text.isEmpty ||
        (selectedPhraseType == 'Question' && addQuestionsPhrase.text.isEmpty) ||
        selectedPhraseCategories == null ||
        selectedLevel == null ||
        selectedLanguage == null) {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    isloading = true;
    notifyListeners();
    await _repo.addPhrases(
      addPhrase.text.toString(),
      addQuestionsPhrase.text.toString(),
      selectedPhraseType ?? '',
      selectedPhraseCategories?.id ?? 0,
      selectedLevel?.id ?? 0,
      selectedLanguage?.id ?? 0,
    );
    isloading = false;
    notifyListeners();
    await init();
    addPhrase.clear();
    addQuestionsPhrase.clear();
    selectedLanguage = launguages.isNotEmpty ? launguages[0] : null;
    selectedLevel = lvl.isNotEmpty ? lvl[0] : null;
    selectedPhraseType = phraseTypes[0];
    selectedPhraseCategories = phraseCategories.isNotEmpty
        ? phraseCategories[0]
        : null;
  }
}
