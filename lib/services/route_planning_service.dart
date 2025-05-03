// route_planning_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/visit_model.dart';

class RouteData {
  final List<LatLng> coordinates;
  final List<dynamic> directions;
  final double totalDistance;
  final int totalDuration;

  RouteData({
    required this.coordinates,
    required this.directions,
    required this.totalDistance,
    required this.totalDuration,
  });
}

class RoutePlanningService {
  final String _baseUrl = 'https://api.example.com/routing'; // Replace with your actual API URL

  // Method to generate an optimized route
  Future<RouteData> getOptimizedRoute(List<Visit> visits) async {
    try {
      // In a real implementation, you would format the request according to your API
      final requestBody = {
        'visits': visits.map((visit) => {
              'id': visit.id,
              'name': visit.name,
              'latitude': visit.latitude,
              'longitude': visit.longitude,
              'duration': visit.duration,
              'isStartingPoint': visit.isStartingPoint,
            }).toList(),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/optimize'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // For demonstration purposes, we'll create mock data
        // In a real app, you would parse the actual response
        return _createMockRouteData();
      } else {
        throw Exception('Failed to load route: ${response.reasonPhrase}');
      }
    } catch (e) {
      // For demonstration purposes, we'll create mock data even on error
      // In a real app, you would properly handle the error
      return _createMockRouteData();
    }
  }

  // Mock data creation for demonstration purposes
  RouteData _createMockRouteData() {
    // These coordinates roughly correspond to London area shown in screenshots
    return RouteData(
      coordinates: [
        LatLng(51.5074, -0.1278), // London
        LatLng(51.5095, -0.1245),
        LatLng(51.5121, -0.1219),
        LatLng(51.5132, -0.1185),
        LatLng(51.5152, -0.1155),
        LatLng(51.5167, -0.1120),
        LatLng(51.5183, -0.1090),
        LatLng(51.5203, -0.1075),
        LatLng(51.5225, -0.1055),
      ],
      directions: [
        // This would contain the detailed directions
        // Format depends on your API response structure
      ],
      totalDistance: 10.3, // km
      totalDuration: 29, // minutes
    );
  }

  // Additional methods as needed for your routing functionality
}