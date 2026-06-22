import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.light);

  bool get isDark => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) =>
      ThemeState(themeMode: themeMode ?? this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
