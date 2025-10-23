import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/profile/presentation/profile_view_model.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/supabase/supabase_client.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientService.instance.init();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProfileViewModel())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en')],
        routerConfig: AppRoutes.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
