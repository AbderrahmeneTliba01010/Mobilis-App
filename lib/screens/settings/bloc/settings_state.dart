import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool autoSyncEnabled;
  final String selectedLanguage;
  final String defaultMapView;
  final String routeCalculation;
  final String syncFrequency;

  const SettingsState({
    required this.notificationsEnabled,
    required this.locationEnabled,
    required this.autoSyncEnabled,
    required this.selectedLanguage,
    required this.defaultMapView,
    required this.routeCalculation,
    required this.syncFrequency,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? autoSyncEnabled,
    String? selectedLanguage,
    String? defaultMapView,
    String? routeCalculation,
    String? syncFrequency,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      defaultMapView: defaultMapView ?? this.defaultMapView,
      routeCalculation: routeCalculation ?? this.routeCalculation,
      syncFrequency: syncFrequency ?? this.syncFrequency,
    );
  }

  @override
  List<Object> get props => [
        notificationsEnabled,
        locationEnabled,
        autoSyncEnabled,
        selectedLanguage,
        defaultMapView,
        routeCalculation,
        syncFrequency,
      ];
}
