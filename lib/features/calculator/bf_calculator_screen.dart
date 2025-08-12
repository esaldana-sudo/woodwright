import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/settings.dart';
import '../../utils/units.dart';

class BoardFootCalculatorScreen extends ConsumerStatefulWidget {
  const BoardFootCalculatorScreen({super.key});

  @override
  ConsumerState<BoardFootCalculatorScreen> createState() => _BoardFootCalculatorScreenState();
}

class _BoardFootCalculatorScreenState extends ConsumerState<BoardFootCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _thickness = TextEditingController();
  final _width = TextEditingController();
  final _length = TextEditingController();
  double? _bf;

  @override
  void dispose() {
    _thickness.dispose();
    _width.dispose();
    _length.dispose();
    super.dispose();
  }

  String _unit(SettingsState s, String inchesLabel, String mmLabel) {
    return s.unitSystem == UnitSystem.imperial ? inchesLabel : mmLabel;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    return Scaffold(
      appBar: AppBar(title: const Text('Board-Foot Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _thickness,
                decoration: InputDecoration(labelText: _unit(settings, 'Thickness (in)', 'Thickness (mm)')),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null) return 'Enter a number';
                  if (x <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _width,
                decoration: InputDecoration(labelText: _unit(settings, 'Width (in)', 'Width (mm)')),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null) return 'Enter a number';
                  if (x <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _length,
                decoration: InputDecoration(labelText: _unit(settings, 'Length (in)', 'Length (mm)')),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null) return 'Enter a number';
                  if (x <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final t = double.parse(_thickness.text);
                  final w = double.parse(_width.text);
                  final l = double.parse(_length.text);
                  double tIn = t, wIn = w, lIn = l;
                  if (!isImperial) {
                    tIn = Units.mmToInches(t);
                    wIn = Units.mmToInches(w);
                    lIn = Units.mmToInches(l);
                  }
                  final bf = (tIn * wIn * lIn) / 144.0;
                  setState(() => _bf = bf);
                },
                child: const Text('Compute'),
              ),
              const SizedBox(height: 16),
              if (_bf != null) ...[
                Text('Board feet ≈ ${_bf!.toStringAsFixed(2)}'),
                if (!isImperial) const Text('(Inputs converted from mm → inches for calculation)'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
