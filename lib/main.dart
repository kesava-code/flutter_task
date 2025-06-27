// File: lib/main.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task/app_config/theme/app_theme.dart';
import 'package:flutter_task/core/services/notification_service.dart';
import 'package:flutter_task/features/0_auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/app_config/router/app_router.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:flutter_task/features/2_chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_task/features/2_chat/domain/repositories/chat_repository.dart';
import 'package:flutter_task/features/4_settings/cubit/settings_cubit.dart';
import 'package:flutter_task/features/4_settings/data/language_service.dart';
import 'package:flutter_task/l10n/app_localizations.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // We must initialize firebase in the background isolate.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Register the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize the notification service
  await NotificationService().initialize();
  final authRepository = AuthRepositoryImpl();
  final languageService = LanguageService();
  final chatRepository = ChatRepositoryImpl();

  runApp(
    MyApp(
      authRepository: authRepository,
      languageService: languageService,
      chatRepository: chatRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final LanguageService _languageService;
  final ChatRepository _chatRepository;
  const MyApp({
    super.key,
    required AuthRepository authRepository,
    required LanguageService languageService,
    required ChatRepository chatRepository,
  }) : _authRepository = authRepository,
       _chatRepository = chatRepository,
       _languageService = languageService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _chatRepository),
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _languageService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository: _authRepository),
          ),
          BlocProvider(
            create: (_) =>
                SettingsCubit(_languageService)..loadInitialLanguage(),
          ),
          BlocProvider(create: (_) => ChatListCubit(_chatRepository)),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
    final appRouter = AppRouter(authBloc: authBloc);
    final locale = context.watch<SettingsCubit>().state;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter.router,
    );
  }
}
