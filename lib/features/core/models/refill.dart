// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Refill {
  final String id;
  final double amount;
  final double cost;
  final DateTime date;
  final double fillPercentage;

  Refill({
    required this.id,
    required this.amount,
    required this.cost,
    required this.date,
    required this.fillPercentage,
  });

  Refill copyWith({
    String? id,
    double? amount,
    double? cost,
    DateTime? date,
    double? fillPercentage,
  }) {
    return Refill(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
      date: date ?? this.date,
      fillPercentage: fillPercentage ?? this.fillPercentage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'cost': cost,
      'date': date.millisecondsSinceEpoch,
      'fillPercentage': fillPercentage,
    };
  }

  factory Refill.fromMap(Map<String, dynamic> map) {
    return Refill(
      id: map['id'] as String,
      amount: map['amount'] as double,
      cost: map['cost'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      fillPercentage: map['fillPercentage'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Refill.fromJson(String source) =>
      Refill.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Refill(id: $id, amount: $amount, cost: $cost, date: $date, fillPercentage: $fillPercentage)';
  }

  @override
  bool operator ==(covariant Refill other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.amount == amount &&
        other.cost == cost &&
        other.date == date &&
        other.fillPercentage == fillPercentage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        cost.hashCode ^
        date.hashCode ^
        fillPercentage.hashCode;
  }
}
