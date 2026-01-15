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
          AddPhrasesWidgets.noOfPhrases(viewModel),
          AddPhrasesWidgets.phraseContent(viewModel),
        ],
      ),
    ),
  ),
);
