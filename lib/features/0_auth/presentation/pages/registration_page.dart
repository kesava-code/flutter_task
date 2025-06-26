// File: lib/features/0_auth/presentation/pages/registration_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/cubit/signup/signup_cubit.dart';
import 'package:flutter_task/features/0_auth/cubit/signup/signup_state.dart';
import 'package:flutter_task/features/0_auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter_task/features/0_auth/domain/entities/country_entity.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            SignUpCubit(context.read<AuthRepository>())..fetchCountries(),
        child: const SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileController = TextEditingController();

  CountryEntity? _selectedCountry;
  String _dialCode = '';

  @override
  void dispose() {
    _emailController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failed')),
            );
        }
        if (state.status == SignUpStatus.success) {
          // On success, GoRouter will handle redirection via the AuthBloc listener
          // But we can pop this page to go back to the login page
          if (context.canPop()) context.pop();
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
                    'Create Your Account!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _displayNameController,
                    labelText: 'Display Name',
                    icon: Icons.person_outline,
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Please enter a display name'
                        : null,
                  ),
                  const SizedBox(height: 16),
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
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<CountryEntity>(
                        value: _selectedCountry,
                        hint: const Text('Select Country'),
                        isExpanded: true,
                        items: state.countries.map((CountryEntity country) {
                          return DropdownMenuItem<CountryEntity>(
                            value: country,
                            child: Text(country.name),
                          );
                        }).toList(),
                        onChanged: (CountryEntity? newValue) {
                          setState(() {
                            _selectedCountry = newValue;
                            _dialCode = newValue?.dialCode ?? '';
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a country' : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.flag_outlined),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _mobileController,
                    labelText: 'Mobile Number',
                    icon: Icons.phone_outlined,
                    prefixText: _dialCode.isNotEmpty ? '$_dialCode ' : null,
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Please enter a mobile number'
                        : null,
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
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 44,
                    child: BlocBuilder<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        final isButtonEnabled = _selectedCountry != null;
                        return state.status == SignUpStatus.loading
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
                                onPressed: isButtonEnabled
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<SignUpCubit>().signUp(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            displayName:
                                                _displayNameController.text,
                                            country: _selectedCountry!.name,
                                            mobile:
                                                '$_dialCode${_mobileController.text}',
                                          );
                                        }
                                      }
                                    : null,
                                child: const Text('Sign Up'),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Already have an account? Login'),
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
