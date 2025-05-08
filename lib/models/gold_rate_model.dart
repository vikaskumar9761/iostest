// gold_history_model.dart
class GoldRateEntry {
  final double rate;
  final DateTime slotTime;

  GoldRateEntry({required this.rate, required this.slotTime});

  factory GoldRateEntry.fromJson(Map<String, dynamic> json) {
    return GoldRateEntry(
      rate: json['rate']?.toDouble() ?? 0.0,
      slotTime: DateTime.parse(json['slot_time']),
    );
  }
}
