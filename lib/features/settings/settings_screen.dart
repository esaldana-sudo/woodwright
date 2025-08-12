import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/settings.dart';
import '../../services/analytics/analytics_local.dart';
import '../../services/analytics/consent.dart';
import '../../services/analytics/download_helper.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  LocalAnalytics? _analytics;

  @override
  void initState() {
    super.initState();
    _initAnalytics();
  }

  Future<void> _initAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final analytics = LocalAnalytics(prefs);
    await analytics.init();
    if (!mounted) return;
    setState(() => _analytics = analytics);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsCtrl = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Units'),
          const SizedBox(height: 8),
          SegmentedButton<UnitSystem>(
            segments: const [
              ButtonSegment(value: UnitSystem.imperial, label: Text('Imperial')),
              ButtonSegment(value: UnitSystem.metric, label: Text('Metric')),
            ],
            selected: {settings.unitSystem},
            onSelectionChanged: (s) => settingsCtrl.setUnitSystem(s.first),
          ),

          const Divider(height: 32),
          const Text('Diagnostics & Privacy'),
          const SizedBox(height: 8),

          SwitchListTile(
            title: const Text('Enable anonymous analytics'),
            subtitle: const Text('Local-only usage metrics; no personal data.'),
            value: _analytics?.isEnabled ?? false,
            onChanged: (v) async {
              // Turning ON and not already enabled → show consent dialog.
              if (v && !(_analytics?.isEnabled ?? false)) {
                await showDialog(
                  context: context,
                  builder: (_) => AnalyticsConsentDialog(
                    onAccept: () async {
                      Navigator.of(context).pop();
                      await _analytics?.setEnabled(true);
                      await settingsCtrl.setAnalyticsEnabled(true);
                      if (!mounted) return;
                      setState(() {}); // reflect new state
                    },
                    onDecline: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
                if (!mounted) return;
                setState(() {}); // optional refresh after dialog closes
                return;
              }

              // Turning OFF or toggling to same value
              await _analytics?.setEnabled(v);
              await settingsCtrl.setAnalyticsEnabled(v);
              if (!mounted) return;
              setState(() {});
            },
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () async {
              if (_analytics == null) return;
              final pathOrMsg = await _analytics!.exportLog();

              if (kIsWeb) {
                // On Web, create a downloadable text file (no direct file I/O).
                final content =
                    'Woodwright diagnostics (today) — exported at ${DateTime.now().toIso8601String()}\n';
                final ok = await downloadTextFile('woodwright_diagnostics.txt', content);
                if (!context.mounted) return; // ✅ guard the same BuildContext you use next
                final msg = ok ? 'Diagnostics downloaded.' : 'Download not supported.';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              } else {
                await Share.shareXFiles([XFile(pathOrMsg)], text: 'Woodwright diagnostics');
                // No BuildContext use after await here.
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Send Diagnostics'),
          ),

          const SizedBox(height: 24),
          const Text('About'),
          const SizedBox(height: 8),
          const Text('Woodwright v1.1 — Privacy-first woodworking toolkit.'),
        ],
      ),
    );
  }
}
