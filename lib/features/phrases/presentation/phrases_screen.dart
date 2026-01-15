import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import 'package:yoyo_web_app/features/phrases/presentation/screens/phrases_mobile.dart';
import 'package:yoyo_web_app/features/phrases/presentation/screens/phrases_tablet.dart';
import 'package:yoyo_web_app/features/phrases/presentation/screens/phrases_website.dart';

class PhrasesScreen extends StatelessWidget {
  const PhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PhrasesViewModel>(
      builder: (context, value, child) => ResponsiveLayout(
        mobile: phrasesMobile(value),
        tablet: phrasesTablet(value),
        desktop: phrasesWebsite(value),
      ),
    );
  }
}
