import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/add_phrases_view_model.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../../../../config/theme/app_text_styles.dart';

class AddPhrasesWidgets {
  static addPhrasesHeader() => Text(
    'Add Phrases',
    style: AppTextStyles.textTheme.headlineLarge!.copyWith(
      color: Theme.of(ctx!).colorScheme.primary,
    ),
  );

  static noOfPhrases(AddPhrasesViewModel vm) => Row(
    spacing: 10,
    children: [
      Text(
        'No. of Phrases ',
        style: AppTextStyles.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      IconButton(onPressed: () {}, icon: Icon(Icons.remove, size: 15)),
      SizedBox(
        width: 60,
        child: TextField(
          controller: vm.phraseCount,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 1),
          ),
        ),
      ),
      IconButton(onPressed: () {}, icon: Icon(Icons.add, size: 15)),
      Text(
        '(maximum 100 - limit of 500 per school. per month)',
        style: AppTextStyles.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  static phraseContent(AddPhrasesViewModel vm) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: MediaQuery.of(ctx!).size.width * 0.1,
    children: [
      Expanded(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where will the phrases be?',
              style: Theme.of(ctx!).textTheme.bodyLarge!.copyWith(
                color: Theme.of(ctx!).colorScheme.primary,
              ),
            ),
            Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Language '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.languages?.map((val) => val.language ?? '').toList() ??
                          [],
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.categories.map((val) => val.name ?? '').toList(),
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Class '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.commonVM?.selectedSchool?.classes
                              ?.map((val) => val.className ?? '')
                              .toList() ??
                          [],
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.lvl?.map((val) => val.level ?? '').toList() ?? [],
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Phrase Type',
              style: Theme.of(ctx!).textTheme.bodyLarge!.copyWith(
                color: Theme.of(ctx!).colorScheme.primary,
              ),
            ),
            Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.types.map((val) => val).toList(),
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Theme '),
                    CommonWidgets.buildDropdown(
                      null,
                      vm.theme.map((val) => val).toList(),
                      (val) => vm.selectLanguage(val),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 30,
          children: [
            Text(
              'Phrase Source',
              style: Theme.of(ctx!).textTheme.bodyLarge!.copyWith(
                color: Theme.of(ctx!).colorScheme.primary,
              ),
            ),
            Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Text Book '),
                    SizedBox(
                      width: 160,
                      child: TextField(
                        controller: vm.sourceCont,
                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Module '),
                    SizedBox(
                      width: 160,
                      child: TextField(
                        controller: vm.moduleCont,
                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'AI Prompt',
              style: Theme.of(ctx!).textTheme.bodyLarge!.copyWith(
                color: Theme.of(ctx!).colorScheme.primary,
              ),
            ),
            Row(
              spacing: 30,
              children: [
                Text('Module '),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  // static addPhrasesPhraseTextfiled(AddPhrasesViewModel vm) => TextField(
  //   controller: vm.phraseController,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Phrases",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),
  //     prefixIcon: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: Icon(Icons.record_voice_over_rounded),
  //     ),
  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );

  // static addPhrasesTranslationTextfiled(AddPhrasesViewModel vm) => TextField(
  //   controller: vm.translationController,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Phrases Translation",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),
  //     prefixIcon: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: Icon(Icons.translate_rounded),
  //     ),
  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );

  // static addPhrasesVocabTextfiled(AddPhrasesViewModel vm) => TextField(
  //   controller: vm.vocabController,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   keyboardType: TextInputType.number,
  //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Vocab Count",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),

  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );

  // static addPhrasesSoundsTextfiled(AddPhrasesViewModel vm) => TextField(
  //   controller: vm.soundsController,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   keyboardType: TextInputType.number,
  //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Sound Count",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),

  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );

  // static addPhrasesFilter(
  //   AddPhrasesViewModel viewmodel, {
  //   bool isMobile = false,
  // }) => isMobile
  //     ? Column(
  //         spacing: 20,
  //         children: [
  //           SizedBox(
  //             width: double.infinity,
  //             child: CommonWidgets.buildDropdown(
  //               'Languages',
  //               viewmodel.languages
  //                       ?.map((val) => val.language ?? '')
  //                       .toList() ??
  //                   [],
  //               (val) => viewmodel.selectLanguage(val),
  //             ),
  //           ),
  //           SizedBox(
  //             width: double.infinity,
  //             child: CommonWidgets.buildDropdown(
  //               "Level",
  //               viewmodel.lvl?.map((val) => val.level ?? '').toList() ?? [],
  //               (val) => viewmodel.changeLvl(val),
  //             ),
  //           ),
  //         ],
  //       )
  //     : Row(
  //         spacing: 20,
  //         children: [
  //           if (viewmodel.languages?.isNotEmpty ?? false)
  //             Expanded(
  //               child: CommonWidgets.buildDropdown(
  //                 'Languages',
  //                 viewmodel.languages
  //                         ?.map((val) => val.language ?? '')
  //                         .toList() ??
  //                     [],
  //                 (val) => viewmodel.selectLanguage(val),
  //               ),
  //             ),
  //           if (viewmodel.lvl?.isNotEmpty ?? false)
  //             Expanded(
  //               child: CommonWidgets.buildDropdown(
  //                 "Level",
  //                 viewmodel.lvl?.map((val) => val.level ?? '').toList() ?? [],
  //                 (val) => viewmodel.changeLvl(val),
  //               ),
  //             ),
  //         ],
  //       );

  // static mp3UploadWidget(AddPhrasesViewModel provider) => DropTarget(
  //   onDragEntered: (_) => provider.onDragEntered(),
  //   onDragExited: (_) => provider.onDragExited(),
  //   onDragDone: (details) => provider.onDragDone(details),
  //   child: GestureDetector(
  //     onTap: provider.pickFile,
  //     child: Container(
  //       width: 300,
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: provider.isDragging
  //             ? Color(0xff9D5DE6).withValues(alpha: 0.2)
  //             : Colors.grey[200],
  //         border: Border.all(
  //           color: provider.isDragging ? Color(0xff9D5DE6) : Colors.grey,
  //           width: 2,
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Icon(Icons.library_music, size: 50, color: Color(0xff9D5DE6)),
  //           const SizedBox(height: 10),
  //           Text(
  //             (provider.selectedFile == null && provider.selectedBytes == null)
  //                 ? "Drag & drop or click to upload MP3"
  //                 : (provider.selectedFile != null)
  //                 ? provider.selectedFile!.path
  //                       .split(Platform.pathSeparator)
  //                       .last
  //                 : provider.fileName != null
  //                 ? provider.fileName ?? ''
  //                 : '',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(fontSize: 14),
  //           ),
  //           if (provider.selectedFile != null || provider.selectedBytes != null)
  //             TextButton.icon(
  //               onPressed: provider.clearFile,
  //               icon: const Icon(Icons.delete, color: Colors.red),
  //               label: const Text(
  //                 "Remove",
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );

  // static addPhraseBtn(AddPhrasesViewModel viewmodel) => ElevatedButton(
  //   onPressed: () => viewmodel.addPhrase(),
  //   child: Text('Add Phrases'),
  // );
}
