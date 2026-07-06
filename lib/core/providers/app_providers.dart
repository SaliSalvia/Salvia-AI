import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (_) async => SharedPreferences.getInstance(),
);

final localProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(ref),
);

class LocaleNotifier extends StateNotifier<Locale> {
  static const _key = 'app_locale';
  final Ref _ref;

  LocaleNotifier(this._ref) : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) state = Locale(saved);
  }

  Future<void> _save(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  void setEnglish() {
    state = const Locale('en');
    _save('en');
  }

  void setPersian() {
    state = const Locale('fa');
    _save('fa');
  }

  void toggle() => state.languageCode == 'en' ? setPersian() : setEnglish();
}
