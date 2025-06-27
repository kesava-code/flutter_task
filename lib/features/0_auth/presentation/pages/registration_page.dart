// File: lib/features/0_auth/presentation/pages/registration_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/cubit/signup/signup_cubit.dart';
import 'package:flutter_task/features/0_auth/cubit/signup/signup_state.dart';
import 'package:flutter_task/features/0_auth/domain/entities/country_entity.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'package:flutter_task/features/0_auth/presentation/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_task/l10n/app_localizations.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createAccount), centerTitle: true),
      body: BlocProvider(
        create: (context) => SignUpCubit(context.read<AuthRepository>())..fetchCountries(),
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
    final l10n = AppLocalizations.of(context)!;
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
                  CustomTextField(
                    controller: _displayNameController,
                    labelText: l10n.displayName,
                    icon: Icons.person_outline,
                    validator: (value) => (value?.isEmpty ?? true) ? l10n.pleaseEnterDisplayName : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: l10n.email,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterEmail;
                      }
                      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return l10n.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<CountryEntity>(
                        value: _selectedCountry,
                        hint: Text(l10n.selectCountry),
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
                        validator: (value) => value == null ? l10n.pleaseSelectCountry : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.flag_outlined),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _mobileController,
                    labelText: l10n.mobileNumber,
                    icon: Icons.phone_outlined,
                    prefixText: _dialCode.isNotEmpty ? '$_dialCode ' : null,
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value?.isEmpty ?? true) ? l10n.pleaseEnterMobile : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: l10n.password,
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                       if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterPassword;
                      }
                      if (value.length < 6) {
                        return l10n.passwordMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: l10n.confirmPassword,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return state.status == SignUpStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignUpCubit>().signUp(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        displayName: _displayNameController.text,
                                        country: _selectedCountry!.name,
                                        mobile: '$_dialCode${_mobileController.text}',
                                      );
                                }
                              },
                              child: Text(l10n.register),
                            );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.alreadyHaveAccount),
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