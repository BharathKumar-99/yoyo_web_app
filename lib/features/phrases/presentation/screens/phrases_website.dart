import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/phrases/presentation/categories/presentation/categories.dart';
import '../../../common/widgets.dart';
import '../../../login/presentation/widgets/loader.dart';
import '../phrases/presentation/phrases.dart';
import '../phrases_view_model.dart';

Widget phrasesWebsite(PhrasesViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: viewModel.isloading
        ? Center(child: LoaderWithoutBg())
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Align(
                  alignment: Alignment.centerLeft,
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
