import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/data/phrases_repo.dart';

import '../../home/model/phrases_model.dart';
import '../../home/model/school_language.dart';
import '../model/phrases_categories.dart';

class PhrasesViewModel extends ChangeNotifier {
  final PhrasesRepo _repo = PhrasesRepo();
  List<PhraseModel> phrases = [];
  List<PhraseModel> filteredPhraseModel = [];
  List<Language> launguages = [];
  List<PhraseCategories> phraseCategories = [];
  PhraseCategories? selectedPhraseCategories;
  List<Level> lvl = [];
  final player = AudioPlayer();
  String? selectedLaunguage;
  String? selectedLevel;
  int currentPlayingPhraseId = -1;
  CommonViewModel? commonViewModel;

  PhrasesViewModel() {
    commonViewModel = Provider.of<CommonViewModel>(ctx!);
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

    phrases = await _repo.getPhrasesDetails();

    for (var phrase in phrases) {
      if (phrase.languageData != null &&
          !launguages.contains(phrase.languageData)) {
        launguages.add(phrase.languageData!);
      }

      if (phrase.levelData != null && !lvl.contains(phrase.levelData)) {
        lvl.add(phrase.levelData!);
      }
    }
    if (commonViewModel?.teacher?.teacher?.isNotEmpty ?? false) {
      launguages = [];
      for (SchoolLanguage element
          in commonViewModel?.teacher?.schools?.schoolLanguage ?? []) {
        launguages.add(element.language!);
      }
    }

    phrases = phrases
        .where((element) => launguages.contains(element.languageData))
        .toList();
    for (var element in phrases) {
      if (element.phraseCategories != null) {
        phraseCategories.add(element.phraseCategories!);
      }
    }
    phraseCategories = phraseCategories = {
      for (final c in phraseCategories) c.id: c,
    }.values.toList();

    applyFilter();
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
    applyFilter();
  }

  selectPhraseCategories(PhraseCategories? val) {
    selectedPhraseCategories = val;
    applyFilter();
  }

  changeLvl(String val) {
    selectedLevel = val;
    applyFilter();
  }

  Future<void> applyFilter() async {
    if ((selectedLaunguage == null || selectedLaunguage == "All") &&
        (selectedLevel == null || selectedLevel == "All") &&
        (selectedPhraseCategories == null)) {
      filteredPhraseModel = List.from(phrases);
    } else {
      filteredPhraseModel = phrases.where((table) {
        // LEVEL FILTER
        final bool lvlMatch = selectedLevel == null || selectedLevel == "All"
            ? true
            : table.levelData?.level == selectedLevel;

        // CATEGORY FILTER
        final bool categoryMatch = selectedPhraseCategories == null
            ? true
            : table.phraseCategories?.id == selectedPhraseCategories!.id;

        // LANGUAGE FILTER
        final bool languageMatch =
            selectedLaunguage == null || selectedLaunguage == "All"
            ? true
            : table.languageData?.language == selectedLaunguage;

        return lvlMatch && categoryMatch && languageMatch;
      }).toList();
    }
    notifyListeners();
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
}
