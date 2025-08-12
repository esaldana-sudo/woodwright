import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { imperial, metric }

@immutable
class SettingsState {
  final UnitSystem unitSystem;
  final bool analyticsEnabled;
  final bool crashReportsEnabled;
  final bool hasSeenConsent;
  const SettingsState({
    this.unitSystem = UnitSystem.imperial,
    this.analyticsEnabled = false,
    this.crashReportsEnabled = false,
    this.hasSeenConsent = false,
  });

  SettingsState copyWith({
    UnitSystem? unitSystem,
    bool? analyticsEnabled,
    bool? crashReportsEnabled,
    bool? hasSeenConsent,
  }) => SettingsState(
    unitSystem: unitSystem ?? this.unitSystem,
    analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    crashReportsEnabled: crashReportsEnabled ?? this.crashReportsEnabled,
    hasSeenConsent: hasSeenConsent ?? this.hasSeenConsent,
  );
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences prefs;
  SettingsNotifier(this.prefs): super(const SettingsState()) {
    _load();
  }

  static const _kUnit = 'unit_system';
  static const _kAnalytics = 'analytics_enabled';
  static const _kCrash = 'crash_enabled';
  static const _kConsent = 'has_seen_consent';

  void _load() {
    final unitStr = prefs.getString(_kUnit);
    final unit = unitStr == 'metric' ? UnitSystem.metric : UnitSystem.imperial;
    state = state.copyWith(
      unitSystem: unit,
      analyticsEnabled: prefs.getBool(_kAnalytics) ?? false,
      crashReportsEnabled: prefs.getBool(_kCrash) ?? false,
      hasSeenConsent: prefs.getBool(_kConsent) ?? false,
    );
  }

  Future<void> setUnitSystem(UnitSystem u) async {
    state = state.copyWith(unitSystem: u);
    await prefs.setString(_kUnit, u == UnitSystem.metric ? 'metric' : 'imperial');
  }

  Future<void> setAnalyticsEnabled(bool v) async {
    state = state.copyWith(analyticsEnabled: v);
    await prefs.setBool(_kAnalytics, v);
  }

  Future<void> setCrashReportsEnabled(bool v) async {
    state = state.copyWith(crashReportsEnabled: v);
    await prefs.setBool(_kCrash, v);
  }

  Future<void> setHasSeenConsent(bool v) async {
    state = state.copyWith(hasSeenConsent: v);
    await prefs.setBool(_kConsent, v);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SettingsNotifier(prefs);
});
