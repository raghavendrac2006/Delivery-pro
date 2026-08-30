class DailyUsage {
  final String usageId;
  final String bagId;
  final String flourType;
  final String date;
  final double usedKg;

  DailyUsage({
    required this.usageId,
    required this.bagId,
    this.flourType = "₹1 Rice Flour",
    required this.date,
    required this.usedKg,
  });

  DailyUsage copyWith({
    String? usageId,
    String? bagId,
    String? flourType,
    String? date,
    double? usedKg,
  }) {
    return DailyUsage(
      usageId: usageId ?? this.usageId,
      bagId: bagId ?? this.bagId,
      flourType: flourType ?? this.flourType,
      date: date ?? this.date,
      usedKg: usedKg ?? this.usedKg,
    );
  }

  factory DailyUsage.fromJson(Map<String, dynamic> json, {String? id}) {
    return DailyUsage(
      usageId: id ?? json['usageId'] ?? '',
      bagId: json['bagId'] ?? '',
      flourType: json['flourType'] ?? '₹1 Rice Flour',
      date: json['date'] ?? '',
      usedKg: (json['usedKg'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usageId": usageId,
      "bagId": bagId,
      "flourType": flourType,
      "date": date,
      "usedKg": usedKg,
    };
  }
}

