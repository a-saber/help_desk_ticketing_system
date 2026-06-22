import 'package:flutter/material.dart';
import 'ar.dart';
import 'en.dart';

class AppTranslations {
  final Locale locale;

  AppTranslations(this.locale);

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static const LocalizationsDelegate<AppTranslations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> get _strings =>
      locale.languageCode == 'ar' ? arStrings : enStrings;

  bool get isArabic => locale.languageCode == 'ar';

  String tr(String key) => _strings[key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppTranslations> load(Locale locale) async {
    return AppTranslations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key) => AppTranslations.of(this).tr(key);
  bool get isArabic => AppTranslations.of(this).isArabic;
}
