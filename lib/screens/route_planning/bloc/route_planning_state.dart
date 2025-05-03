import 'package:equatable/equatable.dart';
import '../../../models/route_settings_model.dart';
import '../../../models/visit_model.dart';

enum RouteStatus { initial, loading, success, failure }

class RoutePlanningState extends Equatable {
  final RoutesSettings settings;
  final List<Visit> plannedVisits;
  final RouteStatus status;
  final String? errorMessage;
  final bool isRouteGenerated;
  final bool isRouteSaved;

  const RoutePlanningState({
    required this.settings,
    this.plannedVisits = const [],
    this.status = RouteStatus.initial,
    this.errorMessage,
    this.isRouteGenerated = false,
    this.isRouteSaved = false,
  });

  RoutePlanningState copyWith({
    RoutesSettings? settings,
    List<Visit>? plannedVisits,
    RouteStatus? status,
    String? errorMessage,
    bool? isRouteGenerated,
    bool? isRouteSaved,
  }) {
    return RoutePlanningState(
      settings: settings ?? this.settings,
      plannedVisits: plannedVisits ?? this.plannedVisits,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isRouteGenerated: isRouteGenerated ?? this.isRouteGenerated,
      isRouteSaved: isRouteSaved ?? this.isRouteSaved,
    );
  }

  @override
  List<Object?> get props => [settings, plannedVisits, status, errorMessage, isRouteGenerated, isRouteSaved];
}