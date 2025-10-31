import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/add_phrases_view_model.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../../../../config/theme/app_text_styles.dart';

class AddPhrasesWidgets {
  static addPhrasesHeader() =>
      Text('Add Phrases', style: AppTextStyles.textTheme.headlineLarge);

  static addPhrasesPhraseTextfiled(AddPhrasesViewModel vm) => TextField(
    controller: vm.phraseController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter Phrases",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.record_voice_over_rounded),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static addPhrasesTranslationTextfiled(AddPhrasesViewModel vm) => TextField(
    controller: vm.translationController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter Phrases Translation",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.translate_rounded),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static addPhrasesVocabTextfiled(AddPhrasesViewModel vm) => TextField(
    controller: vm.vocabController,
    style: AppTextStyles.textTheme.bodySmall,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter Vocab Count",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),

      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static addPhrasesSoundsTextfiled(AddPhrasesViewModel vm) => TextField(
    controller: vm.soundsController,
    style: AppTextStyles.textTheme.bodySmall,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter Sound Count",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),

      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static addPhrasesFilter(
    AddPhrasesViewModel viewmodel, {
    bool isMobile = false,
  }) => isMobile
      ? Column(
          spacing: 20,
          children: [
            SizedBox(
              width: double.infinity,
              child: CommonWidgets.buildDropdown(
                'Languages',
                viewmodel.languages
                        ?.map((val) => val.language ?? '')
                        .toList() ??
                    [],
                (val) => viewmodel.selectLanguage(val),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CommonWidgets.buildDropdown(
                "Level",
                viewmodel.lvl?.map((val) => val.level ?? '').toList() ?? [],
                (val) => viewmodel.changeLvl(val),
              ),
            ),
          ],
        )
      : Row(
          spacing: 20,
          children: [
            if (viewmodel.languages?.isNotEmpty ?? false)
              Expanded(
                child: CommonWidgets.buildDropdown(
                  'Languages',
                  viewmodel.languages
                          ?.map((val) => val.language ?? '')
                          .toList() ??
                      [],
                  (val) => viewmodel.selectLanguage(val),
                ),
              ),
            if (viewmodel.lvl?.isNotEmpty ?? false)
              Expanded(
                child: CommonWidgets.buildDropdown(
                  "Level",
                  viewmodel.lvl?.map((val) => val.level ?? '').toList() ?? [],
                  (val) => viewmodel.changeLvl(val),
                ),
              ),
          ],
        );

  static mp3UploadWidget(AddPhrasesViewModel provider) => DropTarget(
    onDragEntered: (_) => provider.onDragEntered(),
    onDragExited: (_) => provider.onDragExited(),
    onDragDone: (details) => provider.onDragDone(details),
    child: GestureDetector(
      onTap: provider.pickFile,
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          color: provider.isDragging
              ? Color(0xff9D5DE6).withValues(alpha: 0.2)
              : Colors.grey[200],
          border: Border.all(
            color: provider.isDragging ? Color(0xff9D5DE6) : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_music, size: 50, color: Color(0xff9D5DE6)),
            const SizedBox(height: 10),
            Text(
              (provider.selectedFile == null && provider.selectedBytes == null)
                  ? "Drag & drop or click to upload MP3"
                  : (provider.selectedFile != null)
                  ? provider.selectedFile!.path
                        .split(Platform.pathSeparator)
                        .last
                  : provider.fileName != null
                  ? provider.fileName ?? ''
                  : '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            if (provider.selectedFile != null || provider.selectedBytes != null)
              TextButton.icon(
                onPressed: provider.clearFile,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Remove",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  static addPhraseBtn(AddPhrasesViewModel viewmodel) => ElevatedButton(
    onPressed: () => viewmodel.addPhrase(),
    child: Text('Add Phrases'),
  );
}
