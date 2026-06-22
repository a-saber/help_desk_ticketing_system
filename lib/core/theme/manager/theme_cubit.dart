import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

/// Bonus feature: Dark Mode, persisted across app restarts.
class ThemeCubit extends Cubit<ThemeState> {
  static const _prefsKey = 'is_dark_mode';

  ThemeCubit() : super(ThemeState.initial()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_prefsKey) ?? false;
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    emit(state.copyWith(themeMode: newIsDark ? ThemeMode.dark : ThemeMode.light));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, newIsDark);
  }
}
