import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/models/prospect_model.dart';
import 'prospecting_state.dart';

class ProspectingCubit extends Cubit<ProspectingState> {
  ProspectingCubit() : super(const ProspectingState());

  // Mock data for demo
  final List<Prospect> _mockProspects = [
    Prospect(
      id: '1',
      name: 'Digital World Shop',
      contactPerson: 'Bab Ezzouar - Electronics',
      phone: '+213 555 987 654',
      address: 'Algiers',
      commune: 'Bab Ezzouar',
      category: 'Electronics',
      status: 'New',
      createdAt: DateTime.now(),
      location: '36.7235°N, 3.0804°E',
    ),
    Prospect(
      id: '2',
      name: 'MegaPhone Store',
      contactPerson: 'Kouba - Mobile',
      phone: '+213 555 123 789',
      address: 'Kouba, Algiers',
      commune: 'Kouba',
      category: 'Mobile',
      status: 'Accepted',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: '36.7235°N, 3.0804°E',
    ),
    Prospect(
      id: '3',
      name: 'Tech Wave',
      contactPerson: 'Hydra - Mixed',
      phone: '+213 555 456 321',
      address: 'Hydra, Algiers',
      commune: 'Hydra',
      category: 'Mixed',
      status: 'Pending',
      createdAt: DateTime.parse('2025-03-03'),
      location: '36.7235°N, 3.0804°E',
    ),
    Prospect(
      id: '4',
      name: 'Connect Mobile',
      contactPerson: 'Algiers Center - Mobile',
      phone: '+213 555 789 456',
      address: 'Algiers Center',
      commune: 'Algiers',
      category: 'Mobile',
      status: 'Pending',
      createdAt: DateTime.parse('2025-03-02'),
      location: '36.7235°N, 3.0804°E',
    ),
    Prospect(
      id: '5',
      name: 'Telecom Express',
      contactPerson: 'Bab Ezzouar - Telecom',
      phone: '+213 555 654 321',
      address: 'Bab Ezzouar, Algiers',
      commune: 'Bab Ezzouar',
      category: 'Telecom',
      status: 'Accepted',
      createdAt: DateTime.parse('2025-03-01'),
      location: '36.7235°N, 3.0804°E',
    ),
  ];

  Future<void> loadProspects() async {
    emit(state.copyWith(status: ProspectingStatus.loading));
    try {
      // In a real app, you would fetch data from an API or database
      await Future.delayed(const Duration(seconds: 1)); // Simulate network call
      
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      
      final prospectsThisMonth = _mockProspects
          .where((p) => p.createdAt.isAfter(firstDayOfMonth))
          .length;
      
      final acceptedProspects = _mockProspects
          .where((p) => p.status == 'Accepted')
          .length;
          
      final double successRate = _mockProspects.isEmpty 
          ? 0 
          : (acceptedProspects / _mockProspects.length) * 100;
      
      emit(state.copyWith(
        prospects: _mockProspects,
        prospectsThisMonth: prospectsThisMonth,
        acceptedProspects: acceptedProspects,
        successRate: successRate,
        status: ProspectingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProspectingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void filterProspects(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  Future<void> addProspect(Prospect prospect) async {
    emit(state.copyWith(status: ProspectingStatus.loading));
    try {
      // In a real app, you would save to an API or database
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network call
      
      // Add to our local list for demo purposes
      final updatedProspects = [...state.prospects, prospect];
      
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      
      final prospectsThisMonth = updatedProspects
          .where((p) => p.createdAt.isAfter(firstDayOfMonth))
          .length;
      
      final acceptedProspects = updatedProspects
          .where((p) => p.status == 'Accepted')
          .length;
          
      final double successRate = updatedProspects.isEmpty 
          ? 0 
          : (acceptedProspects / updatedProspects.length) * 100;
      
      emit(state.copyWith(
        prospects: updatedProspects,
        prospectsThisMonth: prospectsThisMonth,
        acceptedProspects: acceptedProspects,
        successRate: successRate,
        status: ProspectingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProspectingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  List<Prospect> get filteredProspects {
    if (state.selectedFilter == 'All') {
      return state.prospects;
    }
    return state.prospects
        .where((prospect) => prospect.status == state.selectedFilter)
        .toList();
  }
}