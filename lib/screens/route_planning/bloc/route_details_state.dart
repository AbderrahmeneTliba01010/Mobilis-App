import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

enum RouteDetailsStatus { initial, loading, success, failure }
enum DirectionType { start, straight, turnRight, turnLeft, slightRight, slightLeft, destination }

class RouteDirection {
  final String instruction;
  final int? distance;
  final DirectionType type;

  RouteDirection({
    required this.instruction,
    this.distance,
    required this.type,
  });
}

class RouteDetailsState extends Equatable {
  final RouteDetailsStatus status;
  final List<LatLng> route;
  final List<LatLng> visitPoints;
  final List<RouteDirection> routeDirections;
  final String routeSummary;
  final double totalDistance;
  final int totalDuration;
  final double zoom;
  final String? errorMessage;

  const RouteDetailsState({
    this.status = RouteDetailsStatus.initial,
    this.route = const [],
    this.visitPoints = const [],
    this.routeDirections = const [],
    this.routeSummary = '',
    this.totalDistance = 0.0,
    this.totalDuration = 0,
    this.zoom = 13.0,
    this.errorMessage,
  });

  RouteDetailsState copyWith({
    RouteDetailsStatus? status,
    List<LatLng>? route,
    List<LatLng>? visitPoints,
    List<RouteDirection>? routeDirections,
    String? routeSummary,
    double? totalDistance,
    int? totalDuration,
    double? zoom,
    String? errorMessage,
  }) {
    return RouteDetailsState(
      status: status ?? this.status,
      route: route ?? this.route,
      visitPoints: visitPoints ?? this.visitPoints,
      routeDirections: routeDirections ?? this.routeDirections,
      routeSummary: routeSummary ?? this.routeSummary,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
      zoom: zoom ?? this.zoom,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        route,
        visitPoints,
        routeDirections,
        routeSummary,
        totalDistance,
        totalDuration,
        zoom,
        errorMessage,
      ];
}