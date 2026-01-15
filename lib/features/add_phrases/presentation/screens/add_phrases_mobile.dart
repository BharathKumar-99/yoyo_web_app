import 'package:flutter/material.dart';

import '../../../common/widgets.dart';
import '../add_phrases_view_model.dart';
import '../widgets/widgets.dart';

Widget addPhrasesMobile(AddPhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
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
          // AddPhrasesWidgets.addPhrasesPhraseTextfiled(viewModel),
          // AddPhrasesWidgets.addPhrasesTranslationTextfiled(viewModel),
          // AddPhrasesWidgets.addPhrasesVocabTextfiled(viewModel),
          // AddPhrasesWidgets.addPhrasesSoundsTextfiled(viewModel),
          // AddPhrasesWidgets.addPhrasesFilter(viewModel, isMobile: true),
          // AddPhrasesWidgets.mp3UploadWidget(viewModel),
          // AddPhrasesWidgets.addPhraseBtn(viewModel),
        ],
      ),
    ),
  ),
);
