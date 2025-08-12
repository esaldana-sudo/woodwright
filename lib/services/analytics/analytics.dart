import 'events.dart';

abstract class Analytics {
  Future<void> init();
  Future<void> setEnabled(bool enabled);
  bool get isEnabled;
  Future<void> track(Event event);
  Future<String> exportLog(); // returns path or message
}
