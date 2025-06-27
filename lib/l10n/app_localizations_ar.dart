// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مهمة فلاتر';

  @override
  String get welcome => 'أهلاً بك';

  @override
  String get home => 'الرئيسية';

  @override
  String get chats => 'المحادثات';

  @override
  String get map => 'الخريطة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get scanThisCodeToConnect => 'امسح هذا الرمز للتواصل';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get welcomeBack => 'مرحبا بعودتك!';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ سجل';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get displayName => 'الاسم المعروض';

  @override
  String get selectCountry => 'اختر دولة';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال بريد إلكتروني';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة مرور';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get pleaseEnterDisplayName => 'الرجاء إدخال اسم عرض';

  @override
  String get pleaseSelectCountry => 'الرجاء اختيار دولة';

  @override
  String get pleaseEnterMobile => 'الرجاء إدخال رقم جوال';

  @override
  String get noChats => 'لا توجد محادثات حتى الآن. امسح رمز QR للبدء!';

  @override
  String get failedToLoadChats => 'فشل تحميل المحادثات.';

  @override
  String get scanQrCode => 'مسح رمز الاستجابة السريعة';

  @override
  String get selectAChat => 'اختر محادثة لعرض الرسائل';

  @override
  String get sendMessage => 'أرسل رسالة...';
}
