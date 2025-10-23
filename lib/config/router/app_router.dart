import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/core/supabase/supabase_client.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:yoyo_web_app/features/home/presentation/home_screen.dart';
import '../../features/login/presentation/screens/login_screen.dart';
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
      ShellRoute(
        builder: (context, state, child) => DashboardScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final supabase = SupabaseClientService.instance.client;
      final currentUser = supabase.auth.currentUser;
      final goingToLogin = state.fullPath == RouteNames.login;

      if (supabase.auth.currentSession == null &&
          currentUser == null &&
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
