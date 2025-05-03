import 'package:equatable/equatable.dart';
import 'package:mobilis/models/point_of_sale_model.dart';

abstract class PointsOfSaleState extends Equatable {
  const PointsOfSaleState();
  
  @override
  List<Object> get props => [];
}

class PointsOfSaleInitial extends PointsOfSaleState {}

class PointsOfSaleLoading extends PointsOfSaleState {}

class PointsOfSaleLoaded extends PointsOfSaleState {
  final List<PointOfSale> allPoints;
  
  const PointsOfSaleLoaded(this.allPoints);
  
  @override
  List<Object> get props => [allPoints];
}

class PointsOfSaleFiltered extends PointsOfSaleLoaded {
  final List<PointOfSale> filteredPoints;
  final String activeFilter;
  final String searchQuery;
  
  const PointsOfSaleFiltered({
    required List<PointOfSale> allPoints,
    required this.filteredPoints,
    required this.activeFilter,
    this.searchQuery = '',
  }) : super(allPoints);
  
  @override
  List<Object> get props => [allPoints, filteredPoints, activeFilter, searchQuery];
}

class PointsOfSaleSearched extends PointsOfSaleFiltered {
  const PointsOfSaleSearched({
    required super.allPoints,
    required super.filteredPoints,
    required super.activeFilter,
    required super.searchQuery,
  });
}

class PointsOfSaleError extends PointsOfSaleState {
  final String message;
  
  const PointsOfSaleError(this.message);
  
  @override
  List<Object> get props => [message];
}