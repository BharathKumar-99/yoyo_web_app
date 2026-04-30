import 'package:flutter/material.dart';
import '../../../common/widgets.dart';
import '../categories/presentation/categories.dart';
import '../phrases/presentation/phrases.dart';
import '../phrases_view_model.dart';

Widget phrasesTablet(PhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(isTablet: true),
  body: DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.centerLeft, // or center
          child: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.only(right: 20),
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Categories'),
              Tab(text: 'Phrases'),
            ],
          ),
        ),
      ),
      body: const TabBarView(children: [CategoriesScreen(), Phrases()]),
    ),
  ),
);
