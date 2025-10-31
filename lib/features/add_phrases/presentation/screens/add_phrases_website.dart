import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/widgets/widgets.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../add_phrases_view_model.dart';

Widget addPhrasesWebsite(AddPhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
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
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: AddPhrasesWidgets.addPhrasesPhraseTextfiled(viewModel),
              ),
              Expanded(
                child: AddPhrasesWidgets.addPhrasesTranslationTextfiled(
                  viewModel,
                ),
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: AddPhrasesWidgets.addPhrasesVocabTextfiled(viewModel),
              ),
              Expanded(
                child: AddPhrasesWidgets.addPhrasesSoundsTextfiled(viewModel),
              ),
            ],
          ),
          AddPhrasesWidgets.addPhrasesFilter(viewModel),
          AddPhrasesWidgets.mp3UploadWidget(viewModel),
          AddPhrasesWidgets.addPhraseBtn(viewModel),
        ],
      ),
    ),
  ),
);
