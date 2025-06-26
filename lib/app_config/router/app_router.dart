// File: lib/app_config/router/app_router.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/widgets/main_app_shell.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_state.dart';
import 'package:flutter_task/features/1_home/presentation/pages/home_screen.dart';
import 'package:flutter_task/features/2_chat/presentation/pages/adaptive_chats_screen.dart';
import 'package:flutter_task/features/2_chat/presentation/pages/chat_detail_screen.dart';
import 'package:flutter_task/features/3_map/presentation/pages/map_screen.dart';
import 'package:flutter_task/features/4_settings/presentation/pages/settings_screen.dart';
import 'package:flutter_task/features/5_qr_scanner/presentation/pages/qr_scanner_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_task/features/0_auth/presentation/pages/login_page.dart';
import 'package:flutter_task/features/0_auth/presentation/pages/registration_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final AuthBloc authBloc;
  GoRouter? _router;

  AppRouter({required this.authBloc});

  GoRouter get router {
    _router ??= GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      refreshListenable: _GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
        final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!loggedIn && !isLoggingIn) return '/login';
        if (loggedIn && isLoggingIn) return '/home';

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationPage(),
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/scanner',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const QrScannerScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainAppShell(child: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/chats',
                  builder: (context, state) => const AdaptiveChatsScreen(),
                  routes: [
                    GoRoute(
                      path: ':chatId',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final chatId = state.pathParameters['chatId']!;
                        final partnerName = state.extra as String?;
                        return ChatDetailScreen(chatId: chatId, partnerName: partnerName);
                      },
                    ),
                  ],
                ),
              ],
            ),
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