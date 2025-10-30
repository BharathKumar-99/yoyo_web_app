import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/data/phrases_repo.dart';

import '../../home/model/phrases_model.dart';

class PhrasesViewModel extends ChangeNotifier {
  final PhrasesRepo _repo = PhrasesRepo();
  List<PhraseModel> phrases = [];
  List<PhraseModel> filteredPhraseModel = [];
  List<Language> launguages = [];
  List<Level> lvl = [];
  final player = AudioPlayer();
  String? selectedLaunguage;
  String? selectedLevel;
  int currentPlayingPhraseId = -1;

  PhrasesViewModel() {
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
    applyFilter();
    notifyListeners();
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

  changeLvl(String val) {
    selectedLevel = val;
    applyFilter();
  }

  Future<void> applyFilter() async {
    if ((selectedLaunguage == null || selectedLaunguage == "All") &&
        (selectedLevel == null || selectedLevel == "All")) {
      filteredPhraseModel = List.from(phrases);
    } else {
      filteredPhraseModel = phrases.where((table) {
        final lvlMatch = (selectedLevel == "All" || selectedLevel == null)
            ? true
            : table.levelData?.level == selectedLevel;

        final languageMatch =
            (selectedLaunguage == "All" || selectedLaunguage == null)
            ? true
            : table.languageData?.language == selectedLaunguage;

        return lvlMatch && languageMatch;
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
