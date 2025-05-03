import 'package:latlong2/latlong.dart';

class PointOfSale {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final String zone;
  final String contact;
  final String openingHours;
  final String category;
  final String lastVisit;
  final bool isActive;
  final String type;
  final String? scheduledVisit;
  final bool visited;
  final DateTime? lastVisitDate;

  PointOfSale({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.zone,
    required this.contact,
    required this.openingHours,
    required this.category,
    required this.lastVisit,
    required this.isActive,
    this.scheduledVisit,
    required this.type,
    this.visited = false,
    this.lastVisitDate,
  });

  factory PointOfSale.fromJson(Map<String, dynamic> json) {
    return PointOfSale(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      location: LatLng(
        (json['location']?['latitude'] as num?)?.toDouble() ?? 0.0,
        (json['location']?['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      zone: json['zone'] as String,
      contact: json['contact'] as String,
      openingHours: json['openingHours'] as String,
      category: json['category'] as String,
      lastVisit: json['lastVisit'] as String,
      isActive: json['isActive'] as bool,
      type: json['type'] as String? ?? 'Unknown',
      scheduledVisit: json['scheduledVisit'] as String?,
      visited: json['visited'] as bool? ?? false,
      lastVisitDate: json['lastVisitDate'] != null
          ? DateTime.tryParse(json['lastVisitDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'zone': zone,
      'contact': contact,
      'openingHours': openingHours,
      'category': category,
      'lastVisit': lastVisit,
      'isActive': isActive,
      'type': type,
      'scheduledVisit': scheduledVisit,
      'visited': visited,
      'lastVisitDate': lastVisitDate?.toIso8601String(),
    };
  }
}
