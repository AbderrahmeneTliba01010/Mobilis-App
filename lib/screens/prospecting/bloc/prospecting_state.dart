import 'package:equatable/equatable.dart';
import 'package:mobilis/models/prospect_model.dart';

enum ProspectingStatus { initial, loading, success, failure }

class ProspectingState extends Equatable {
  final List<Prospect> prospects;
  final int prospectsThisMonth;
  final int targetProspects;
  final int acceptedProspects;
  final double successRate;
  final ProspectingStatus status;
  final String? errorMessage;
  final String selectedFilter;

  const ProspectingState({
    this.prospects = const [],
    this.prospectsThisMonth = 0,
    this.targetProspects = 15,
    this.acceptedProspects = 0,
    this.successRate = 0.0,
    this.status = ProspectingStatus.initial,
    this.errorMessage,
    this.selectedFilter = 'All',
  });

  ProspectingState copyWith({
    List<Prospect>? prospects,
    int? prospectsThisMonth,
    int? targetProspects,
    int? acceptedProspects,
    double? successRate,
    ProspectingStatus? status,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return ProspectingState(
      prospects: prospects ?? this.prospects,
      prospectsThisMonth: prospectsThisMonth ?? this.prospectsThisMonth,
      targetProspects: targetProspects ?? this.targetProspects,
      acceptedProspects: acceptedProspects ?? this.acceptedProspects,
      successRate: successRate ?? this.successRate,
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
        prospects,
        prospectsThisMonth,
        targetProspects,
        acceptedProspects,
        successRate,
        status,
        errorMessage,
        selectedFilter,
      ];
}