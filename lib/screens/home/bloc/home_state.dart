// home_state.dart (add this to screens/home/bloc/ directory)
import 'package:equatable/equatable.dart';
import '../../../models/visit_model.dart';

// Simple class to hold coverage stats
class CoverageStats {
  final double visited;
  final double pending;
  final double missed;
  
  CoverageStats({
    required this.visited,
    required this.pending,
    required this.missed,
  });
}

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int visitsCompleted;
  final int totalVisits;
  final int newProspects;
  final int distanceTraveled;
  final String fieldTime;
  final CoverageStats coverageStats;
  final List<int> weeklyPerformance;
  final List<Visit> visits;
  
  const HomeLoaded({
    required this.visitsCompleted,
    required this.totalVisits,
    required this.newProspects,
    required this.distanceTraveled,
    required this.fieldTime,
    required this.coverageStats,
    required this.weeklyPerformance,
    required this.visits,
  });
  
  @override
  List<Object> get props => [
    visitsCompleted, 
    totalVisits, 
    newProspects, 
    distanceTraveled, 
    fieldTime, 
    coverageStats, 
    weeklyPerformance, 
    visits
  ];
}

class HomeError extends HomeState {
  final String message;
  
  const HomeError({required this.message});
  
  @override
  List<Object> get props => [message];
}