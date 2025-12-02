import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/config/utils/usefull_functions.dart';
import 'package:yoyo_web_app/features/add_phrases/data/add_phrases_repo.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../add_user/model/level.dart';

class AddPhrasesViewModel extends ChangeNotifier {
  final AddPhrasesRepo _repo = AddPhrasesRepo();
  TextEditingController phraseController = TextEditingController();
  TextEditingController translationController = TextEditingController();
  TextEditingController vocabController = TextEditingController();
  TextEditingController soundsController = TextEditingController();
  List<Language>? languages = [];
  List<Level>? lvl = [];
  File? _selectedFile;
  Uint8List? selectedBytes;
  String? fileName;
  bool _dragging = false;
  Language? selectedLaunguage;
  Level? selectedLevel;

  File? get selectedFile => _selectedFile;
  bool get isDragging => _dragging;

  AddPhrasesViewModel() {
    init();
  }

  init() async {
    languages = await _repo.getLanguages();
    lvl = await _repo.getLevel();
    notifyListeners();
  }

  void onDragEntered() {
    _dragging = true;
    notifyListeners();
  }

  void onDragExited() {
    _dragging = false;
    notifyListeners();
  }

  void onDragDone(DropDoneDetails details) async {
    final file = details.files.first;

    if (!file.name.toLowerCase().endsWith('.mp3')) return;

    _dragging = false;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      selectedBytes = bytes;
      fileName = file.name;
    } else {
      _selectedFile = File(file.path);
      fileName = file.name;
    }

    notifyListeners();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      withData: kIsWeb,
    );

    if (result != null) {
      final picked = result.files.single;
      fileName = picked.name;

      if (kIsWeb) {
        selectedBytes = picked.bytes;
      } else {
        _selectedFile = File(picked.path!);
      }

      notifyListeners();
    }
  }

  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  }

  selectLanguage(val) {
    selectedLaunguage = languages?.firstWhere((lan) => lan.language == val);
    notifyListeners();
  }

  changeLvl(val) {
    selectedLevel = lvl?.firstWhere((lan) => lan.level == val);
    notifyListeners();
  }

  addPhrase() async {
    GlobalLoader.show();
    try {
      if (selectedBytes == null ||
          fileName == null ||
          phraseController.text.trim().isEmpty ||
          translationController.text.trim().isEmpty ||
          vocabController.text.trim().isEmpty ||
          soundsController.text.trim().isEmpty ||
          selectedLaunguage == null ||
          selectedLevel == null) {
        UsefullFunctions.showAwesomeSnackbarContent(
          "All fields are required. Please fill everything and select a file.",
          'Error',
          ContentType.failure,
        );
      }

      await _repo.addPhrases(
        selectedBytes!,
        phraseController.text.trim(),
        translationController.text.trim(),
        int.parse(vocabController.text.trim()),
        int.parse(soundsController.text.trim()),
        selectedLaunguage!,
        selectedLevel!,
        fileName!,
      );

      UsefullFunctions.showAwesomeSnackbarContent(
        'Phrase uploaded successfully',
        'Success',
        ContentType.success,
      );
      reset();
    } catch (e) {
      debugPrint("❌ Error: $e");
    } finally {
      GlobalLoader.hide();
    }
  }

  reset() {
    phraseController = TextEditingController();
    translationController = TextEditingController();
    vocabController = TextEditingController();
    soundsController = TextEditingController();
    languages = [];
    lvl = [];
    _selectedFile = null;
    selectedBytes = null;
    fileName = null;
    _dragging = false;
    selectedLaunguage = null;
    selectedLevel = null;
    notifyListeners();
  }
}
