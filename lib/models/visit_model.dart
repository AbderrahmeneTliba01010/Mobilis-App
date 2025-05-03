// visit_model.dart
import 'package:equatable/equatable.dart';

class Visit extends Equatable {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final double distance;
  final bool isStartingPoint;
  final double? latitude;
  final double? longitude;
  final int duration; // Duration in minutes

  const Visit({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.distance,
    this.isStartingPoint = false,
    this.latitude,
    this.longitude,
    this.duration = 30,
  });

  Visit copyWith({
    int? id,
    String? name,
    String? startTime,
    String? endTime,
    double? distance,
    bool? isStartingPoint,
    double? latitude,
    double? longitude,
    int? duration,
  }) {
    return Visit(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      isStartingPoint: isStartingPoint ?? this.isStartingPoint,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        startTime,
        endTime,
        distance,
        isStartingPoint,
        latitude,
        longitude,
        duration,
      ];
}