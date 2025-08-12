import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'analytics.dart';
import 'events.dart';

class LocalAnalytics implements Analytics {
  static const _kEnabled = 'analytics_enabled';
  static const _kInstallId = 'install_id';
  static const _kKeepDays = 7;

  final SharedPreferences prefs;
  bool _enabled = false;
  final _uuid = const Uuid();

  LocalAnalytics(this.prefs);

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> init() async {
    _enabled = prefs.getBool(_kEnabled) ?? false;
    prefs.getString(_kInstallId) ?? await _resetInstallId();
  }

  Future<String> _resetInstallId() async {
    final id = _uuid.v4();
    await prefs.setString(_kInstallId, id);
    return id;
  }

  String get installId => prefs.getString(_kInstallId) ?? '';

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await prefs.setBool(_kEnabled, enabled);
  }

  Future<Directory> _logDir() async {
    final dir = await getApplicationSupportDirectory();
    final logDir = Directory('${dir.path}/woodwright_logs');
    if (!await logDir.exists()) await logDir.create(recursive: true);
    return logDir;
  }

  Future<File> _todayFile() async {
    final d = await _logDir();
    final now = DateTime.now();
    final name = 'events_${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
    return File('${d.path}/$name');
  }

  Future<void> _rotate() async {
    final d = await _logDir();
    final entries = await d
        .list()
        .where((e) => e is File && e.path.endsWith('.log'))
        .cast<File>()
        .toList();
    entries.sort((a, b) => a.path.compareTo(b.path));
    if (entries.length > _kKeepDays) {
      for (final f in entries.take(entries.length - _kKeepDays)) {
        try { await f.delete(); } catch (_) {}
      }
    }
  }

  @override
  Future<void> track(Event event) async {
    if (!_enabled) return;
    if (kIsWeb) return; // no-op on Web; use download in UI
    final f = await _todayFile();
    final line = '${jsonEncode(event.toJson())}\n';
    await f.writeAsString(line, mode: FileMode.append);
    await _rotate();
  }

  @override
  Future<String> exportLog() async {
    if (kIsWeb) {
      return 'web-export-ready';
    }
    final f = await _todayFile();
    if (!await f.exists()) {
      await f.writeAsString('');
    }
    return f.path;
  }
}
