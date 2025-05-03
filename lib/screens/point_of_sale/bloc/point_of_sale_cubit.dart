import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilis/models/point_of_sale_model.dart';
import 'package:mobilis/screens/point_of_sale/bloc/point_of_sale_state.dart';

class PointsOfSaleCubit extends Cubit<PointsOfSaleState> {
  PointsOfSaleCubit() : super(PointsOfSaleInitial()) {
    fetchPointsOfSale();
  }

  Future<void> fetchPointsOfSale() async {
    emit(PointsOfSaleLoading());
    
    try {
      // In a real app, this would come from an API or database
      final List<PointOfSale> pointsOfSale = [
  PointOfSale(
    id: '1',
    name: 'Tech Store Algiers',
    address: '123 Central Blvd, Algiers',
    location: const LatLng(36.7538, 3.0588), // Example coordinates for Algiers
    zone: 'Zone A - Central',
    contact: '+213 555 123 456',
    openingHours: '09:00 - 18:00',
    lastVisit: 'Today, 09:15',
    isActive: true,
    type: 'Electronics',
    category: 'electronics',
    visited: true,
    lastVisitDate: DateTime.now(),
  ),
  PointOfSale(
    id: '2',
    name: 'Mobile Shop Central',
    address: '45 Didouche Ave, Algiers',
    location: const LatLng(36.7660, 3.0500),
    zone: 'Zone A - Central',
    contact: '+213 555 789 123',
    openingHours: '08:30 - 19:00',
    lastVisit: 'Today, 10:30',
    isActive: true,
    type: 'Mobile',
    category: 'mobile',
    visited: true,
    lastVisitDate: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  PointOfSale(
    id: '3',
    name: 'Telecom Plus',
    address: '78 Liberty St, Algiers',
    location: const LatLng(36.7650, 3.0800),
    zone: 'Zone D - West',
    contact: '+213 555 456 789',
    openingHours: '09:00 - 17:30',
    lastVisit: '',
    isActive: true,
    type: 'Telecom',
    category: 'telecom',
    scheduledVisit: 'Today, 13:30',
    visited: false,
    lastVisitDate: null,
  ),
  PointOfSale(
    id: '4',
    name: 'Smart Device Center',
    address: '12 Boulevard St, Algiers',
    location: const LatLng(36.7600, 3.0650),
    zone: 'Zone D - West',
    contact: '+213 555 321 654',
    openingHours: '10:00 - 20:00',
    lastVisit: '2 days ago',
    isActive: false,
    type: 'Electronics',
    category: 'electronics',
    visited: true,
    lastVisitDate: DateTime.now().subtract(Duration(days: 2)),
  ),
];
      
      emit(PointsOfSaleLoaded(pointsOfSale));
    } catch (e) {
      emit(PointsOfSaleError(e.toString()));
    }
  }

  void filterByCategory(String category) {
    if (state is PointsOfSaleLoaded) {
      final currentState = state as PointsOfSaleLoaded;
      final searchQuery = currentState is PointsOfSaleSearched ? currentState.searchQuery : '';
      
      List<PointOfSale> filteredPoints;
      if (category == 'All') {
        filteredPoints = currentState.allPoints;
      } else {
        filteredPoints = currentState.allPoints
            .where((point) => point.category == category)
            .toList();
      }
      
      // Apply search filter if there's an active search
      if (searchQuery.isNotEmpty) {
        filteredPoints = _applySearchFilter(filteredPoints, searchQuery);
      }
      
      emit(PointsOfSaleFiltered(
        allPoints: currentState.allPoints,
        filteredPoints: filteredPoints,
        activeFilter: category,
        searchQuery: searchQuery,
      ));
    }
  }

  void searchPointsOfSale(String query) {
    if (state is PointsOfSaleLoaded) {
      final currentState = state as PointsOfSaleLoaded;
      String activeFilter = 'All';
      
      if (currentState is PointsOfSaleFiltered) {
        activeFilter = currentState.activeFilter;
      }
      
      List<PointOfSale> basePoints = currentState.allPoints;
      
      // Apply category filter first if not "All"
      if (activeFilter != 'All') {
        basePoints = basePoints.where((point) => point.category == activeFilter).toList();
      }
      
      // Then apply search filter
      final filteredPoints = _applySearchFilter(basePoints, query);
      
      emit(PointsOfSaleSearched(
        allPoints: currentState.allPoints,
        filteredPoints: filteredPoints,
        activeFilter: activeFilter,
        searchQuery: query,
      ));
    }
  }
  
  List<PointOfSale> _applySearchFilter(List<PointOfSale> points, String query) {
    if (query.isEmpty) return points;
    
    final lowerCaseQuery = query.toLowerCase();
    return points.where((point) {
      return point.name.toLowerCase().contains(lowerCaseQuery) ||
             point.address.toLowerCase().contains(lowerCaseQuery) ||
             point.zone.toLowerCase().contains(lowerCaseQuery) ||
             point.contact.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  void scheduleVisit(String name, String time) {
    if (state is PointsOfSaleLoaded) {
      final currentState = state as PointsOfSaleLoaded;
      final updatedPoints = currentState.allPoints.map((point) {
        if (point.name == name) {
          return PointOfSale(
            id: point.id,
            name: point.name,
            address: point.address,
            zone: point.zone,
            contact: point.contact,
            openingHours: point.openingHours,
            category: point.category,
            lastVisit: point.lastVisit,
            isActive: point.isActive,
            scheduledVisit: time,
            visited: point.visited,
            location: point.location,
            type: point.type
          );
        }
        return point;
      }).toList();
      
      // Preserve current filtering and search state
      String activeFilter = 'All';
      String searchQuery = '';
      
      if (currentState is PointsOfSaleFiltered) {
        activeFilter = (currentState).activeFilter;
      }
      
      if (currentState is PointsOfSaleSearched) {
        searchQuery = (currentState).searchQuery;
      }
      
      // Re-apply filters
      List<PointOfSale> filteredPoints = updatedPoints;
      
      if (activeFilter != 'All') {
        filteredPoints = filteredPoints
            .where((point) => point.category == activeFilter)
            .toList();
      }
      
      if (searchQuery.isNotEmpty) {
        filteredPoints = _applySearchFilter(filteredPoints, searchQuery);
      }
      
      if (searchQuery.isNotEmpty || activeFilter != 'All') {
        emit(PointsOfSaleFiltered(
          allPoints: updatedPoints,
          filteredPoints: filteredPoints,
          activeFilter: activeFilter,
          searchQuery: searchQuery,
        ));
      } else {
        emit(PointsOfSaleLoaded(updatedPoints));
      }
    }
  }
}