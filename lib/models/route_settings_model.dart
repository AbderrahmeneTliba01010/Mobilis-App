// route_settings_model.dart
import 'package:equatable/equatable.dart';

class RoutesSettings extends Equatable {
  final DateTime date;
  final String startingPoint;
  final String optimizationPreference;
  final bool avoidTraffic;
  final bool considerOpeningHours;
  final bool includeBreaks;

  const RoutesSettings({
    required this.date,
    required this.startingPoint,
    required this.optimizationPreference,
    this.avoidTraffic = false,
    this.considerOpeningHours = false,
    this.includeBreaks = false,
  });

  RoutesSettings copyWith({
    DateTime? date,
    String? startingPoint,
    String? optimizationPreference,
    bool? avoidTraffic,
    bool? considerOpeningHours,
    bool? includeBreaks,
  }) {
    return RoutesSettings(
      date: date ?? this.date,
      startingPoint: startingPoint ?? this.startingPoint,
      optimizationPreference: optimizationPreference ?? this.optimizationPreference,
      avoidTraffic: avoidTraffic ?? this.avoidTraffic,
      considerOpeningHours: considerOpeningHours ?? this.considerOpeningHours,
      includeBreaks: includeBreaks ?? this.includeBreaks,
    );
  }

  @override
  List<Object?> get props => [
        date,
        startingPoint,
        optimizationPreference,
        avoidTraffic,
        considerOpeningHours,
        includeBreaks,
      ];
}