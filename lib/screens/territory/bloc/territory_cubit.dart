import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/zone_model.dart';
import '../../../models/point_of_sale_model.dart';
import '../../../services/territory_service.dart';
import 'territory_state.dart';

class TerritoryCubit extends Cubit<TerritoryState> {
  final TerritoryService _territoryService = TerritoryService();
  
  TerritoryCubit() : super(const TerritoryState());

  Future<void> loadTerritoryData() async {
    try {
      // Get current location
      LatLng? currentLocation = await _getCurrentLocation();
      
      // Mock data for now, would be replaced with API calls
      final zones = await _territoryService.getZones();
      final pointsOfSale = await _territoryService.getPointsOfSale();
      
      // Calculate statistics
      final stats = await _territoryService.getTerritoryStats();
      
      emit(state.copyWith(
        isLoading: false,
        zones: zones,
        pointsOfSale: pointsOfSale,
        currentLocation: currentLocation,
        assignedZones: stats.assignedZones,
        totalPointsOfSale: stats.totalPointsOfSale,
        coverageRate: stats.coverageRate,
        dailyAvgVisits: stats.dailyAvgVisits,
      ));
    } catch (e) {
      // Handle errors
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<LatLng?> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  void toggleMyLocation(bool value) {
    emit(state.copyWith(showMyLocation: value));
  }

  void toggleZoneBoundaries(bool value) {
    emit(state.copyWith(showZoneBoundaries: value));
  }

  void togglePointsOfSale(bool value) {
    emit(state.copyWith(showPointsOfSale: value));
  }
}