class Event {
  final String name;
  final Map<String, Object?> props;
  final DateTime ts;
  Event(this.name, [this.props = const {}]) : ts = DateTime.now();

  Map<String, Object?> toJson() => {
        'name': name,
        'props': props,
        'ts': ts.toIso8601String(),
      };
}

class CommonProps {
  final String appVersion;
  final String platform;
  final String locale;
  final String unitSystem;
  final String installId;
  CommonProps({
    required this.appVersion,
    required this.platform,
    required this.locale,
    required this.unitSystem,
    required this.installId,
  });

  Map<String, Object?> toJson() => {
        'app_version': appVersion,
        'platform': platform,
        'locale': locale,
        'unit_system': unitSystem,
        'install_id': installId,
      };
}
