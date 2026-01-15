import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import '../../../common/widgets.dart';
import '../categories/presentation/categories.dart';
import '../phrases/presentation/phrases.dart';

Widget phrasesMobile(PhrasesViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBarMobile(),
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
  ),
);
