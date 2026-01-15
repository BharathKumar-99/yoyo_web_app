import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/add_phrases/data/add_phrases_repo.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';
import '../../add_user/model/level.dart';

class AddPhrasesViewModel extends ChangeNotifier {
  final AddPhrasesRepo _repo = AddPhrasesRepo();
  TextEditingController phraseAiText = TextEditingController();
  TextEditingController phraseCount = TextEditingController();
  TextEditingController sourceCont = TextEditingController();
  TextEditingController moduleCont = TextEditingController();
  List<Language>? languages = [];
  List<Level>? lvl = [];
  List<String> types = ['Q/A', 'listening', 'Reading', 'Phrase'];
  List<String> theme = ['Persnalized'];
  List<PhraseCategories> categories = [];
  File? _selectedFile;
  Uint8List? selectedBytes;
  String? fileName;
  bool _dragging = false;
  Language? selectedLaunguage;
  Level? selectedLevel;
  bool loading = true;
  File? get selectedFile => _selectedFile;
  bool get isDragging => _dragging;
  CommonViewModel? commonVM;

  AddPhrasesViewModel() {
    commonVM = ctx!.read<CommonViewModel>();
    init();
  }

  init() async {
    loading = true;
    notifyListeners();
    languages = await _repo.getLanguages();
    lvl = await _repo.getLevel();
    categories = await _repo.getPhraseCategories(
      commonVM!.selectedSchool?.id ?? 0,
    );
    loading = false;
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
}
