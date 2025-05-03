import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/zone_model.dart';
import '../../../models/point_of_sale_model.dart';

class TerritoryState extends Equatable {
  final bool isLoading;
  final List<Zone> zones;
  final List<PointOfSale> pointsOfSale;
  final LatLng? currentLocation;
  final int assignedZones;
  final int totalPointsOfSale;
  final int coverageRate;
  final int dailyAvgVisits;
  final bool showMyLocation;
  final bool showZoneBoundaries;
  final bool showPointsOfSale;

  const TerritoryState({
    this.isLoading = true,
    this.zones = const [],
    this.pointsOfSale = const [],
    this.currentLocation,
    this.assignedZones = 0,
    this.totalPointsOfSale = 0,
    this.coverageRate = 0,
    this.dailyAvgVisits = 0,
    this.showMyLocation = true,
    this.showZoneBoundaries = true,
    this.showPointsOfSale = true,
  });

  TerritoryState copyWith({
    bool? isLoading,
    List<Zone>? zones,
    List<PointOfSale>? pointsOfSale,
    LatLng? currentLocation,
    int? assignedZones,
    int? totalPointsOfSale,
    int? coverageRate,
    int? dailyAvgVisits,
    bool? showMyLocation,
    bool? showZoneBoundaries,
    bool? showPointsOfSale,
  }) {
    return TerritoryState(
      isLoading: isLoading ?? this.isLoading,
      zones: zones ?? this.zones,
      pointsOfSale: pointsOfSale ?? this.pointsOfSale,
      currentLocation: currentLocation ?? this.currentLocation,
      assignedZones: assignedZones ?? this.assignedZones,
      totalPointsOfSale: totalPointsOfSale ?? this.totalPointsOfSale,
      coverageRate: coverageRate ?? this.coverageRate,
      dailyAvgVisits: dailyAvgVisits ?? this.dailyAvgVisits,
      showMyLocation: showMyLocation ?? this.showMyLocation,
      showZoneBoundaries: showZoneBoundaries ?? this.showZoneBoundaries,
      showPointsOfSale: showPointsOfSale ?? this.showPointsOfSale,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        zones,
        pointsOfSale,
        currentLocation,
        assignedZones,
        totalPointsOfSale,
        coverageRate,
        dailyAvgVisits,
        showMyLocation,
        showZoneBoundaries,
        showPointsOfSale,
      ];
}
