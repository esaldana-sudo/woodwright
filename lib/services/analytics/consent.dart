import 'package:flutter/material.dart';

class AnalyticsConsentDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const AnalyticsConsentDialog({super.key, required this.onAccept, required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Anonymous Diagnostics?'),
      content: const Text(
        'Help improve Woodwright by sharing anonymous usage metrics and non-sensitive crash reports. '
        'No personal data or project details are collected. You can change this anytime in Settings.',
      ),
      actions: [
        TextButton(onPressed: onDecline, child: const Text('No thanks')),
        FilledButton(onPressed: onAccept, child: const Text('Enable')),
      ],
    );
  }
}
