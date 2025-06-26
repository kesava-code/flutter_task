// File: lib/features/0_auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/cubit/login/login_cubit.dart';
import 'package:flutter_task/features/0_auth/cubit/login/login_state.dart';
import 'package:flutter_task/features/0_auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(context.read<AuthRepository>()),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed')),
            );
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 44,
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return state.status == LoginStatus.loading
                            ? ElevatedButton(
                                onPressed: null,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<LoginCubit>()
                                        .logInWithCredentials(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                  }
                                },
                                child: const Text('Login'),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
