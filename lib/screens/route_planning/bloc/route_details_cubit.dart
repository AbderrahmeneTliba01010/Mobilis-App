// route_details_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/visit_model.dart';
import '../../../services/route_planning_service.dart';
import 'route_details_state.dart';

class RouteDetailsCubit extends Cubit<RouteDetailsState> {
  final RoutePlanningService _routeService = RoutePlanningService();
  
  RouteDetailsCubit() : super(const RouteDetailsState());
  final MapController _mapController = MapController();
  MapController get mapController => _mapController;

  Future<void> loadRouteDetails(List<Visit> visits) async {
    if (visits.isEmpty) {
      emit(state.copyWith(
        status: RouteDetailsStatus.failure,
        errorMessage: 'No visits provided for route planning',
      ));
      return;
    }

    emit(state.copyWith(status: RouteDetailsStatus.loading));

    try {
      // Convert visits to visit points for map markers
      final visitPoints = _extractVisitPoints(visits);
      
      // Fetch route data from service
      final routeData = await _routeService.getOptimizedRoute(visits);
      
      // Extract route coordinates
      final List<LatLng> routeCoordinates = routeData.coordinates;
      
      // Create direction instructions
      final directions = _createDirections(routeData.directions);
      
      // Create route summary
      final summary = _createRouteSummary(visits);
      
      emit(state.copyWith(
        status: RouteDetailsStatus.success,
        route: routeCoordinates,
        visitPoints: visitPoints,
        routeDirections: directions,
        routeSummary: summary,
        totalDistance: routeData.totalDistance,
        totalDuration: routeData.totalDuration,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RouteDetailsStatus.failure,
        errorMessage: 'Failed to load route details: ${e.toString()}',
      ));
    }
  }

  void zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    if (currentZoom > 1) {
      _mapController.move(_mapController.camera.center, currentZoom - 1);
    }
  }

  List<LatLng> _extractVisitPoints(List<Visit> visits) {
    return visits.map((visit) {
      // In a real app, you would get actual coordinates from the Visit model
      // This is just a placeholder implementation
      return LatLng(visit.latitude ?? 0, visit.longitude ?? 0);
    }).toList();
  }

  List<RouteDirection> _createDirections(List<dynamic> apiDirections) {
    // In a real app, this would parse the actual API response
    // This is a sample implementation to match the screenshot
    return [
      RouteDirection(
        instruction: 'Head southeast',
        distance: 15,
        type: DirectionType.start,
      ),
      RouteDirection(
        instruction: 'Turn left onto Borough High Street (A3)',
        distance: 200,
        type: DirectionType.turnLeft,
      ),
      RouteDirection(
        instruction: 'Continue onto London Bridge (A3)',
        distance: 300,
        type: DirectionType.straight,
      ),
      RouteDirection(
        instruction: 'Continue onto King William Street (A3)',
        distance: 200,
        type: DirectionType.straight,
      ),
      RouteDirection(
        instruction: 'Turn left onto Cannon Street',
        distance: 400,
        type: DirectionType.turnLeft,
      ),
      RouteDirection(
        instruction: 'Make a slight left onto White Lion Hill',
        distance: 150,
        type: DirectionType.slightLeft,
      ),
      RouteDirection(
        instruction: 'You have arrived at your 1st destination, on the left',
        distance: 0,
        type: DirectionType.destination,
      ),
    ];
  }

  String _createRouteSummary(List<Visit> visits) {
    // Create a summary of streets the route passes through
    // This is a sample implementation to match the screenshot
    return 'Cannon Street, Queen Victoria Street, Victoria Embankment, Queen Victoria Street, Moorgate, Scrutton Street, Old Street, Clerkenwell Road';
  }

}