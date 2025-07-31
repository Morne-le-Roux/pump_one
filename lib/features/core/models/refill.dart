class Refill {
  final String id;
  final double amount;
  final double cost;
  final DateTime date;
  final double fillPercentage;
  final int odometer;

  Refill({
    required this.id,
    required this.amount,
    required this.cost,
    required this.date,
    required this.fillPercentage,
    required this.odometer,
  });
}
