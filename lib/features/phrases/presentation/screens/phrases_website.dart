import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/phrases/presentation/categories/presentation/categories.dart';
import '../../../common/widgets.dart';
import '../build_phrases_block.dart';
import '../phrases/presentation/phrases.dart';
import '../phrases_view_model.dart';

Widget phrasesWebsite(PhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.only(right: 20),
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Add New Phrase'),
              if (viewModel
                          .commonViewModel
                          .selectedClass
                          ?.allowTeachersToSetBulkPhrases ==
                      true ||
                  viewModel.commonViewModel.isAdmin == true)
                Tab(text: 'Build Phrases Blocks'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: TabBarView(
          children: [
            CategoriesScreen(),
            Phrases(),
            if (viewModel
                        .commonViewModel
                        .selectedClass
                        ?.allowTeachersToSetBulkPhrases ==
                    true ||
                viewModel.commonViewModel.isAdmin == true)
              PhrasesBlocksScreen(),
          ],
        ),
      ),
    ),
  ),
);
