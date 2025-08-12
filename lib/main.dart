import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'app_router.dart';
import 'core/settings.dart';
import 'services/analytics/consent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    child: const WoodwrightApp(),
  ));
}

class WoodwrightApp extends ConsumerStatefulWidget {
  const WoodwrightApp({super.key});

  @override
  ConsumerState<WoodwrightApp> createState() => _WoodwrightAppState();
}

class _WoodwrightAppState extends ConsumerState<WoodwrightApp> {
  bool _prompted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_prompted) return;
      final settings = ref.read(settingsProvider);
      if (!settings.hasSeenConsent) {
        _prompted = true;
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AnalyticsConsentDialog(
            onAccept: () async {
              Navigator.of(context).pop();
              await ref.read(settingsProvider.notifier).setAnalyticsEnabled(true);
              await ref.read(settingsProvider.notifier).setHasSeenConsent(true);
            },
            onDecline: () async {
              Navigator.of(context).pop();
              await ref.read(settingsProvider.notifier).setHasSeenConsent(true);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Woodwright',
      theme: buildTheme(),
      routerConfig: AppRouter.build(),
    );
  }
}
