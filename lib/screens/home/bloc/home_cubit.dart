// home_cubit.dart (add this to screens/home/bloc/ directory)
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/visit_model.dart';
import 'home_state.dart';
import 'package:flutter/material.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadDashboardData() async {
    try {
      emit(HomeLoading());
      
      // Simulating API calls
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create mock data for stats
      const visitsCompleted = 12;
      const totalVisits = 15;
      const newProspects = 3;
      const distanceTraveled = 42;
      const fieldTime = "4:35"; // hours:minutes format
      
      // Coverage stats
      final coverageStats = CoverageStats(
        visited: 60,
        pending: 30,
        missed: 10,
      );
      
      // Performance data
      final List<int> weeklyPerformance = [15, 14, 17, 13, 11];
      
      // Create mock visits using your existing Visit model
      final visits = [
        Visit(
          id: 1,
          name: 'Tech Store Algiers',
          startTime: '09:30',
          endTime: '10:30',
          distance: 2.5,
          isStartingPoint: false,
        ),
        Visit(
          id: 2,
          name: 'Mobile Shop Central',
          startTime: '10:45',
          endTime: '11:45',
          distance: 1.8,
          isStartingPoint: false,
        ),
        Visit(
          id: 3,
          name: 'Telecom Plus',
          startTime: '13:30',
          endTime: '14:30',
          distance: 3.2,
          isStartingPoint: false,
        ),
        Visit(
          id: 4,
          name: 'Smart Device Center',
          startTime: '15:00',
          endTime: '16:00',
          distance: 4.1,
          isStartingPoint: false,
        ),
        Visit(
          id: 5,
          name: 'Connect Market',
          startTime: '16:15',
          endTime: '17:15',
          distance: 2.7,
          isStartingPoint: false,
        ),
      ];
      
      emit(HomeLoaded(
        visitsCompleted: visitsCompleted,
        totalVisits: totalVisits,
        newProspects: newProspects,
        distanceTraveled: distanceTraveled,
        fieldTime: fieldTime,
        coverageStats: coverageStats,
        weeklyPerformance: weeklyPerformance,
        visits: visits,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}