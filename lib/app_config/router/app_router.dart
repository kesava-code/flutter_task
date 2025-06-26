// File: lib/app_config/router/app_router.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/widgets/main_app_shell.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_state.dart';
import 'package:flutter_task/features/1_home/presentation/pages/home_screen.dart';
import 'package:flutter_task/features/2_chat/presentation/pages/chats_screen.dart';
import 'package:flutter_task/features/3_map/presentation/pages/map_screen.dart';
import 'package:flutter_task/features/4_settings/presentation/pages/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_task/features/0_auth/presentation/pages/login_page.dart';
import 'package:flutter_task/features/0_auth/presentation/pages/registration_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  GoRouter? _router;

  AppRouter({required this.authBloc});

  GoRouter get router {
    _router ??= GoRouter(
      initialLocation: '/home', // Start at home if logged in
      refreshListenable: _GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
        final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        // If not logged in and not on a login/register page, redirect to login
        if (!loggedIn && !isLoggingIn) {
          return '/login';
        }
        // If logged in and on a login/register page, redirect to home
        if (loggedIn && isLoggingIn) {
          return '/home';
        }

        return null; // No redirect needed
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) => const RegistrationPage(),
        ),
         GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
        ),
        // This StatefulShellRoute is the main UI for logged-in users
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // The UI shell
            return MainAppShell(child: navigationShell);
          },
          branches: [
            // Branch for the 'Home' tab
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
            ),
            // Branch for the 'Chats' tab
            StatefulShellBranch(
              routes: [GoRoute(path: '/chats', builder: (context, state) => const ChatsScreen())],
            ),
            // Branch for the 'Map' tab
            StatefulShellBranch(
              routes: [GoRoute(path: '/map', builder: (context, state) => const MapScreen())],
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    );
    return _router!;
  }
}

// This class makes GoRouter listen to the AuthBloc's stream for state changes.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}