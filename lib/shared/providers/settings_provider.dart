import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available font sizes
enum AppFontSize { small, medium, large }

/// Holds user settings state
class SettingsState {
  final ThemeMode themeMode;
  final AppFontSize fontSize;
  final String currency;
  final Locale locale;
  final String dateFormat;
  final bool pushNotifications;
  final bool weeklySummary;

  SettingsState({
    required this.themeMode,
    required this.fontSize,
    required this.currency,
    required this.locale,
    required this.dateFormat,
    required this.pushNotifications,
    required this.weeklySummary,
  });

  factory SettingsState.initial() => SettingsState(
        themeMode: ThemeMode.system,
        fontSize: AppFontSize.medium,
        currency: 'TL',
        locale: const Locale('tr'),
        dateFormat: 'DD/MM/YYYY',
        pushNotifications: true,
        weeklySummary: false,
      );

  SettingsState copyWith({
    ThemeMode? themeMode,
    AppFontSize? fontSize,
    String? currency,
    Locale? locale,
    String? dateFormat,
    bool? pushNotifications,
    bool? weeklySummary,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
      dateFormat: dateFormat ?? this.dateFormat,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      weeklySummary: weeklySummary ?? this.weeklySummary,
    );
  }
}

/// Manages user settings and persists them
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      themeMode: ThemeMode.values[prefs.getInt('themeMode') ?? state.themeMode.index],
      fontSize: AppFontSize.values[prefs.getInt('fontSize') ?? state.fontSize.index],
      currency: prefs.getString('currency') ?? state.currency,
      locale: Locale(prefs.getString('language') ?? state.locale.languageCode),
      dateFormat: prefs.getString('dateFormat') ?? state.dateFormat,
      pushNotifications: prefs.getBool('pushNotifications') ?? state.pushNotifications,
      weeklySummary: prefs.getBool('weeklySummary') ?? state.weeklySummary,
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> updateFontSize(AppFontSize size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', size.index);
    state = state.copyWith(fontSize: size);
  }

  Future<void> updateCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', value);
    state = state.copyWith(currency: value);
  }

  Future<void> updateLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    state = state.copyWith(locale: Locale(code));
  }

  Future<void> updateDateFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dateFormat', format);
    state = state.copyWith(dateFormat: format);
  }

  Future<void> updatePushNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', enabled);
    state = state.copyWith(pushNotifications: enabled);
  }

  Future<void> updateWeeklySummary(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weeklySummary', enabled);
    state = state.copyWith(weeklySummary: enabled);
  }
}

/// Riverpod provider for settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
