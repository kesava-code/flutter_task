// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Task';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get chats => 'Chats';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get scanThisCodeToConnect => 'Scan this code to connect';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get displayName => 'Display Name';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get pleaseEnterEmail => 'Please enter an email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter a password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseEnterDisplayName => 'Please enter a display name';

  @override
  String get pleaseSelectCountry => 'Please select a country';

  @override
  String get pleaseEnterMobile => 'Please enter a mobile number';

  @override
  String get noChats => 'No chats yet. Scan a QR code to start!';

  @override
  String get failedToLoadChats => 'Failed to load chats.';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get selectAChat => 'Select a chat to view messages';

  @override
  String get sendMessage => 'Send a message...';
}
