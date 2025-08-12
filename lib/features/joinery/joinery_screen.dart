import 'package:flutter/material.dart';

class JoineryScreen extends StatelessWidget {
  const JoineryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joinery Recommendations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('We recommend stronger joinery (e.g., mortise & tenon, pocket screws, dowels) '
              'when strength or twisting is a concern. Butt joints are only recommended in safe, low-load cases.'),
        ],
      ),
    );
  }
}
