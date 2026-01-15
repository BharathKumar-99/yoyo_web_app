import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/screens/add_phrases_mobile.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/screens/add_phrases_tablet.dart';
import 'package:yoyo_web_app/features/add_phrases/presentation/screens/add_phrases_website.dart';

import 'add_phrases_view_model.dart';

class AddPhrasesScreen extends StatelessWidget {
  const AddPhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPhrasesViewModel>(
      create: (context) => AddPhrasesViewModel(),
      child: Consumer<AddPhrasesViewModel>(
        builder: (context, viewModel, w) {
          return viewModel.loading
              ? Center(child: CircularProgressIndicator.adaptive())
              : ResponsiveLayout(
                  mobile: addPhrasesMobile(viewModel),
                  tablet: addPhrasesTablet(viewModel),
                  desktop: addPhrasesWebsite(viewModel),
                );
        },
      ),
    );
  }
}
