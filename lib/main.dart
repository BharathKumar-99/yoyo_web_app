import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';
import 'package:yoyo_web_app/features/homework/presentation/set_homework_viewmodel.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import 'package:yoyo_web_app/features/users/presentation/users_view_model.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/supabase/supabase_client.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientService.instance.init(dev: false);
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommonViewModel()),
        ChangeNotifierProvider<DashboardViewModel>(
          create: (_) => DashboardViewModel(),
        ),
        ChangeNotifierProxyProvider<CommonViewModel, HomeViewModel>(
          create: (ctx) => HomeViewModel(ctx.read<CommonViewModel>()),
          update: (ctx, schoolProvider, studentProvider) => studentProvider!,
        ),
        ChangeNotifierProxyProvider<CommonViewModel, PhrasesViewModel>(
          create: (ctx) => PhrasesViewModel(ctx.read<CommonViewModel>()),
          update: (ctx, schoolProvider, studentProvider) => studentProvider!,
        ),
        ChangeNotifierProxyProvider2<
          CommonViewModel,
          DashboardViewModel,
          SetHomeworkViewmodel
        >(
          create: (ctx) => SetHomeworkViewmodel(
            ctx.read<CommonViewModel>(),
            ctx.read<DashboardViewModel>(),
          ),
          update: (ctx, schoolProvider, dashboard, studentProvider) =>
              studentProvider!,
        ),
        ChangeNotifierProxyProvider<CommonViewModel, EditSchoolViewModel>(
          create: (ctx) => EditSchoolViewModel(ctx.read<CommonViewModel>()),
          update: (ctx, schoolProvider, studentProvider) => studentProvider!,
        ),
        ChangeNotifierProxyProvider<CommonViewModel, UsersViewModel>(
          create: (ctx) => UsersViewModel(ctx.read<CommonViewModel>()),
          update: (ctx, schoolProvider, studentProvider) => studentProvider!,
        ),
        ChangeNotifierProxyProvider<CommonViewModel, NotificationViewModel>(
          create: (ctx) => NotificationViewModel(ctx.read<CommonViewModel>()),
          update: (ctx, schoolProvider, studentProvider) => studentProvider!,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en')],
        routerConfig: AppRoutes.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
