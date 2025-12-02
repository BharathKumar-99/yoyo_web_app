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
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
              ),
            ),
          ),
          AddPhrasesWidgets.addPhrasesPhraseTextfiled(viewModel),
          AddPhrasesWidgets.addPhrasesTranslationTextfiled(viewModel),
          AddPhrasesWidgets.addPhrasesVocabTextfiled(viewModel),
          AddPhrasesWidgets.addPhrasesSoundsTextfiled(viewModel),
          AddPhrasesWidgets.addPhrasesFilter(viewModel, isMobile: true),
          AddPhrasesWidgets.mp3UploadWidget(viewModel),
          AddPhrasesWidgets.addPhraseBtn(viewModel),
        ],
      ),
    ),
  ),
);
