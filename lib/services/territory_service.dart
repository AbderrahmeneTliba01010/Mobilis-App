import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilis/models/territory_stats_model.dart';
import '../models/zone_model.dart';
import '../models/point_of_sale_model.dart';

class TerritoryService {
  // In a real application, these methods would call APIs
  Future<List<Zone>> getZones() async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Zone(
        id: 'zone1',
        name: 'Hydra',
        boundaries: [
          LatLng(36.748, 3.050),
          LatLng(36.748, 3.060),
          LatLng(36.738, 3.060),
          LatLng(36.738, 3.050),
          LatLng(36.748, 3.050),
        ],
        color: Colors.purple,
        isAssigned: true,
        totalPointsOfSale: 45,
        visitedPointsOfSale: 34,
      ),
      Zone(
        id: 'zone2',
        name: 'El Biar',
        boundaries: [
          LatLng(36.765, 3.040),
          LatLng(36.765, 3.050),
          LatLng(36.755, 3.050),
          LatLng(36.755, 3.040),
          LatLng(36.765, 3.040),
        ],
        color: Colors.orange,
        isAssigned: true,
        totalPointsOfSale: 42,
        visitedPointsOfSale: 32,
      ),
    ];
  }

  Future<List<PointOfSale>> getPointsOfSale() async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PointOfSale(
        id: 'pos1',
        name: 'Store A',
        address: '123 Main St',
        location: LatLng(36.745, 3.055),
        zone: 'Zone 1',
        contact: '+1234567890',
        openingHours: '08:00-20:00',
        category: 'Retail',
        lastVisit: '2 days ago',
        isActive: true,
        type: 'Supermarket',
        scheduledVisit: 'Tomorrow 10:00',
        visited: true,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PointOfSale(
        id: 'pos2',
        name: 'Store B',
        address: '456 Oak St',
        location: LatLng(36.758, 3.045),
        zone: 'Zone 2',
        contact: '+0987654321',
        openingHours: '09:00-19:00',
        category: 'Retail',
        lastVisit: 'Never',
        isActive: true,
        type: 'Convenience',
        scheduledVisit: 'Next week',
        visited: false,
        lastVisitDate: null,
      ),
      PointOfSale(
        id: 'pos3',
        name: 'Store C',
        address: '789 Pine St',
        location: LatLng(36.742, 3.058),
        zone: 'Zone 1',
        contact: '+1122334455',
        openingHours: '07:00-22:00',
        category: 'Healthcare',
        lastVisit: '5 days ago',
        isActive: true,
        type: 'Pharmacy',
        scheduledVisit: 'Today 14:00',
        visited: true,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PointOfSale(
        id: 'pos4',
        name: 'Store D',
        address: '101 Elm St',
        location: LatLng(36.762, 3.042),
        zone: 'Zone 3',
        contact: '+5566778899',
        openingHours: '10:00-18:00',
        category: 'Retail',
        lastVisit: 'Never',
        isActive: true,
        type: 'Supermarket',
        scheduledVisit: null,
        visited: false,
        lastVisitDate: null,
      ),
      PointOfSale(
        id: 'pos5',
        name: 'Store E',
        address: '202 Maple St',
        location: LatLng(36.750, 3.048),
        zone: 'Zone 2',
        contact: '+4433221100',
        openingHours: '24/7',
        category: 'Retail',
        lastVisit: 'Yesterday',
        isActive: true,
        type: 'Convenience',
        scheduledVisit: 'Tomorrow 09:00',
        visited: true,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<TerritoryStats> getTerritoryStats() async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 500));

    return TerritoryStats(
      assignedZones: 4,
      totalPointsOfSale: 87,
      coverageRate: 76,
      dailyAvgVisits: 15,
    );
  }

  // This method suggests the format for the zone data from the server
  // It's not used in the actual implementation but provides guidance
  Map<String, dynamic> suggestedZoneFormat() {
    return {
      "zones": [
        {
          "id": "zone1",
          "name": "Zone A",
          "isAssigned": true,
          "color": "8E44AD", // Hex color without #
          "boundaries": [
            // GeoJSON format: [longitude, latitude]
            [3.050, 36.748],
            [3.060, 36.748],
            [3.060, 36.738],
            [3.050, 36.738],
            [3.050, 36.748]
          ],
          "totalPointsOfSale": 45,
          "visitedPointsOfSale": 34
        }
      ]
    };
  }
}
