import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Zone {
  final String id;
  final String name;
  final List<LatLng> boundaries;
  final Color color;
  final bool isAssigned;
  final int totalPointsOfSale;
  final int visitedPointsOfSale;

  Zone({
    required this.id,
    required this.name,
    required this.boundaries,
    required this.color,
    required this.isAssigned,
    this.totalPointsOfSale = 0,
    this.visitedPointsOfSale = 0,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      name: json['name'],
      // Parse boundaries from GeoJSON format
      boundaries: _parseBoundaries(json['boundaries']),
      color: Color(int.parse(json['color'], radix: 16) | 0xFF000000),
      isAssigned: json['isAssigned'] ?? false,
      totalPointsOfSale: json['totalPointsOfSale'] ?? 0,
      visitedPointsOfSale: json['visitedPointsOfSale'] ?? 0,
    );
  }

  // Parse GeoJSON coordinates to List<LatLng>
  static List<LatLng> _parseBoundaries(dynamic boundaries) {
    if (boundaries is! List) return [];
    
    try {
      return (boundaries as List).map((coord) {
        if (coord is List && coord.length >= 2) {
          // GeoJSON format is [longitude, latitude]
          return LatLng(coord[1].toDouble(), coord[0].toDouble());
        }
        return const LatLng(0, 0);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  int get coverageRate {
    if (totalPointsOfSale == 0) return 0;
    return (visitedPointsOfSale / totalPointsOfSale * 100).round();
  }
}
