import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState({required this.locale});

  factory LocaleState.initial() => const LocaleState(locale: Locale('en'));

  @override
  List<Object?> get props => [locale];
}
