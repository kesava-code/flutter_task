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
}
