// File: lib/main.dart
import 'package:flutter_task/app_config/theme/app_theme.dart';
import 'package:flutter_task/features/0_auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/app_config/router/app_router.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authRepository = AuthRepositoryImpl();
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  const MyApp({super.key, required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>.value(
      value: _authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: _authRepository),
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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
       theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter.router,
    );
  }
}
