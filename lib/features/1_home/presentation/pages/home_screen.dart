// File: lib/features/1_home/presentation/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:flutter_task/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${l10n.welcome}, ${user?.displayName ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            if (user != null)
              Container(
                color: Colors.white,
                child: QrImageView(
                  data: user.uid,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            const SizedBox(height: 16),
            Text(l10n.scanThisCodeToConnect),
          ],
        ),
      ),
    );
  }
}
