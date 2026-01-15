import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../add_phrases_view_model.dart';
import '../widgets/widgets.dart';

Widget addPhrasesTablet(AddPhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddPhrasesWidgets.addPhrasesHeader(),
          AddPhrasesWidgets.noOfPhrases(viewModel),
          AddPhrasesWidgets.phraseContent(viewModel),
          // Row(
          //   spacing: 20,
          //   children: [
          //     Expanded(
          //       child: AddPhrasesWidgets.addPhrasesPhraseTextfiled(viewModel),
          //     ),
          //     Expanded(
          //       child: AddPhrasesWidgets.addPhrasesTranslationTextfiled(
          //         viewModel,
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   spacing: 20,
          //   children: [
          //     Expanded(
          //       child: AddPhrasesWidgets.addPhrasesVocabTextfiled(viewModel),
          //     ),
          //     Expanded(
          //       child: AddPhrasesWidgets.addPhrasesSoundsTextfiled(viewModel),
          //     ),
          //   ],
          // ),
          // AddPhrasesWidgets.addPhrasesFilter(viewModel),
          // AddPhrasesWidgets.mp3UploadWidget(viewModel),
          // AddPhrasesWidgets.addPhraseBtn(viewModel),
        ],
      ),
    ),
  ),
);
