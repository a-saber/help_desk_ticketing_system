import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

/// Drives the `translations` (ar/en) folder of `core`. Kept separate from
/// [ThemeCubit] (each cubit has one reason to change - SRP).
class LocaleCubit extends Cubit<LocaleState> {
  static const _prefsKey = 'language_code';

  LocaleCubit() : super(LocaleState.initial()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey) ?? 'en';
    emit(LocaleState(locale: Locale(code)));
  }

  Future<void> toggleLocale() async {
    final newCode = state.locale.languageCode == 'en' ? 'ar' : 'en';
    emit(LocaleState(locale: Locale(newCode)));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, newCode);
  }
}
