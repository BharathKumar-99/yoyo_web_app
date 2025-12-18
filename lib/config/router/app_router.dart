import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/core/supabase/supabase_client.dart';
import 'package:yoyo_web_app/features/add_school/presentation/add_school_screen.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/add_teacher.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_screen.dart';
import 'package:yoyo_web_app/features/home/presentation/home_screen.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_screen.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_screen.dart';
import 'package:yoyo_web_app/features/settings/presentation/settings_page.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_screen.dart';
import '../../features/activate_user/presentation/activate_screen.dart';
import '../../features/add_phrases/presentation/add_phrases_screen.dart';
import '../../features/add_user/presentation/add_user.dart';
import '../../features/add_user_name/presentation/add_user_name.dart';
import '../../features/login/presentation/screens/login_screen.dart';
import '../../features/users/presentation/users_screens.dart';
import 'route_names.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.home,
    initialExtra: true,
    debugLogDiagnostics: false,

    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.activate,
        builder: (context, state) => const ActivateScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.addSchool,
            builder: (context, state) => const AddSchoolScreen(),
          ),
          GoRoute(
            path: RouteNames.viewSchool,
            builder: (context, state) =>
                ViewSchoolScreen(schoolId: state.extra as int),
          ),
          GoRoute(
            path: RouteNames.phrases,
            builder: (context, state) => const PhrasesScreen(),
          ),
          GoRoute(
            path: RouteNames.addPhrase,
            builder: (context, state) => const AddPhrasesScreen(),
          ),
          GoRoute(
            path: RouteNames.users,
            builder: (context, state) => const UsersScreens(),
          ),
          GoRoute(
            path: RouteNames.addUsers,
            builder: (context, state) =>
                AddUserScreen(isTeacher: state.extra as bool?),
          ),
          GoRoute(
            path: RouteNames.editUsers,
            builder: (context, state) =>
                EditUserScreen(userId: state.extra as String),
          ),
          GoRoute(
            path: RouteNames.addUserName,
            builder: (context, state) => const AddUserNameScreen(),
          ),
          GoRoute(
            path: RouteNames.notification,
            builder: (context, state) => NotificationScreen(),
          ),
          GoRoute(
            path: RouteNames.editSchool,
            builder: (context, state) =>
                EditSchoolScreen(id: state.extra as int),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => SettingsPage(),
          ),
          GoRoute(
            path: RouteNames.addTeacher,
            builder: (context, state) => AddTeacherScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final supabase = SupabaseClientService.instance.client;
      final currentUser = supabase.auth.currentUser;
      final goingToLogin = state.fullPath == RouteNames.login;
      final goingToActivate = state.fullPath == RouteNames.activate;

      if (supabase.auth.currentSession == null &&
          currentUser == null &&
          !goingToActivate &&
          !goingToLogin) {
        return RouteNames.login;
      }
      if (currentUser != null && goingToLogin) {
        return RouteNames.home;
      }
      return null;
    },
  );
}
