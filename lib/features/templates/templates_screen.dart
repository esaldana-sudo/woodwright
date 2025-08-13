import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bookshelf_controller.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  bool framed = true;

  @override
  Widget build(BuildContext context) {
    final asyncParts = ref.watch(bookshelfProvider(framed));

    return Scaffold(
      appBar: AppBar(title: const Text('Project Templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CheckboxListTile(
            title: const Text('Include Face Frame'),
            subtitle: const Text('Uncheck for frameless cabinet design'),
            value: framed,
            onChanged: (val) {
              if (val != null) setState(() => framed = val);
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Bookshelf (frameless optional off by default)'),
            subtitle: const Text('Start from recommended dimensions and materials.'),
            onTap: () {
              ref.refresh(bookshelfProvider(framed));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating bookshelf... check console')),
              );
            },
          ),
          const SizedBox(height: 24),
          asyncParts.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (result) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Generated Parts: ${result.parts.length}'),
                  Text('Joinery Connections: ${result.connections.length}'),
                  const SizedBox(height: 16),
                  for (final conn in result.connections) ...[
                    Text(
                      '${conn.partA.category} ↔ ${conn.partB.category}:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final opt in conn.joinery.options)
                            Text(
                              "• ${opt.type.name}${opt.isDisabled ? ' (disabled)' : ''}: ${opt.reason}",
                              style: TextStyle(
                                color: opt.isDisabled ? Colors.grey : Colors.black,
                                fontStyle: opt.isDisabled ? FontStyle.italic : FontStyle.normal,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
