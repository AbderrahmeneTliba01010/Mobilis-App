class TerritoryStats {
  final int assignedZones;
  final int totalPointsOfSale;
  final int coverageRate;
  final int dailyAvgVisits;

  TerritoryStats({
    required this.assignedZones,
    required this.totalPointsOfSale,
    required this.coverageRate,
    required this.dailyAvgVisits,
  });

  factory TerritoryStats.fromJson(Map<String, dynamic> json) {
    return TerritoryStats(
      assignedZones: json['assignedZones'] ?? 0,
      totalPointsOfSale: json['totalPointsOfSale'] ?? 0,
      coverageRate: json['coverageRate'] ?? 0,
      dailyAvgVisits: json['dailyAvgVisits'] ?? 0,
    );
  }
}


