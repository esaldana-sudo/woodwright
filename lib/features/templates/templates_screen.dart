import 'package:flutter/material.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.inventory_2),
            title: Text('Bookshelf (frameless optional off by default)'),
            subtitle: Text('Start from recommended dimensions and materials.'),
          ),
        ],
      ),
    );
  }
}
