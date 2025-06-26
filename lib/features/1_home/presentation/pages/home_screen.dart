// File: lib/features/1_home/presentation/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/bloc/auth_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the AuthBloc to get the current user's information
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.displayName ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            if (user != null)
              QrImageView(
                data: user.uid, // The QR code will contain the user's unique ID
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 16),
            const Text('Scan this code to connect'),
          ],
        ),
      ),
    );
  }
}
