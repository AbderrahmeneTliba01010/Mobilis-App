// route_planning_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../models/route_settings_model.dart';
import '../../../models/visit_model.dart';
import '../../../services/route_planning_service.dart';
import 'route_planning_state.dart';

class RoutePlanningCubit extends Cubit<RoutePlanningState> {
  final RoutePlanningService _routeService = RoutePlanningService();

  RoutePlanningCubit()
      : super(RoutePlanningState(
          settings: RoutesSettings(
            date: DateTime.now(),
            startingPoint: 'Current Location',
            optimizationPreference: 'Minimize Distance',
            avoidTraffic: true,
            considerOpeningHours: true,
            includeBreaks: false,
          ),
        ));

  void updateSettings(RoutesSettings settings) {
    emit(state.copyWith(settings: settings));
  }

  void toggleAvoidTraffic(bool value) {
    final newSettings = state.settings.copyWith(avoidTraffic: value);
    emit(state.copyWith(settings: newSettings));
  }

  void toggleConsiderOpeningHours(bool value) {
    final newSettings = state.settings.copyWith(considerOpeningHours: value);
    emit(state.copyWith(settings: newSettings));
  }

  void toggleIncludeBreaks(bool value) {
    final newSettings = state.settings.copyWith(includeBreaks: value);
    emit(state.copyWith(settings: newSettings));
  }

  void setDate(DateTime date) {
    final newSettings = state.settings.copyWith(date: date);
    emit(state.copyWith(settings: newSettings));
  }

  void setStartingPoint(String startingPoint) {
    final newSettings = state.settings.copyWith(startingPoint: startingPoint);
    emit(state.copyWith(settings: newSettings));
  }

  void setOptimizationPreference(String preference) {
    final newSettings =
        state.settings.copyWith(optimizationPreference: preference);
    emit(state.copyWith(settings: newSettings));
  }

  Future<void> generateRoute() async {
    emit(state.copyWith(status: RouteStatus.loading));

    try {
      // Example visits - in a real app, these would come from your data source
      final visits = [
        const Visit(
          id: 1,
          name: 'Tech Store Algiers',
          startTime: '09:00',
          endTime: '09:30',
          distance: 0,
          isStartingPoint: true,
          latitude: 51.5074,
          longitude: -0.1278,
        ),
        const Visit(
          id: 2,
          name: 'Mobile Shop Central',
          startTime: '10:15',
          endTime: '10:45',
          distance: 1.5,
          latitude: 51.5100,
          longitude: -0.1200,
        ),
        const Visit(
          id: 3,
          name: 'Telecom Plus',
          startTime: '13:30',
          endTime: '14:00',
          distance: 3.2,
          latitude: 51.5150,
          longitude: -0.1150,
        ),
        const Visit(
          id: 4,
          name: 'Smart Device Center',
          startTime: '15:00',
          endTime: '15:30',
          distance: 2.8,
          latitude: 51.5180,
          longitude: -0.1100,
        ),
        const Visit(
          id: 5,
          name: 'Connect Market',
          startTime: '16:15',
          endTime: '16:45',
          distance: 4.5,
          latitude: 51.5210,
          longitude: -0.1050,
        ),
      ];

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        plannedVisits: visits,
        status: RouteStatus.success,
        isRouteGenerated: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RouteStatus.failure,
        errorMessage: 'Failed to generate route: ${e.toString()}',
      ));
    }
  }

  Future<void> saveRoute() async {
    emit(state.copyWith(status: RouteStatus.loading));

    try {
      // Simulate API call to save route
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        status: RouteStatus.success,
        isRouteSaved: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RouteStatus.failure,
        errorMessage: 'Failed to save route: ${e.toString()}',
      ));
    }
  }

  // Navigate to route details screen
  void viewRouteDetails(BuildContext context) {
    if (state.plannedVisits.isEmpty || !state.isRouteGenerated) {
      // Show error if no route is generated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please generate a route first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to route details screen
    Navigator.of(context).pushNamed(
      '/route-details',
      arguments: state.plannedVisits,
    );
  }
}