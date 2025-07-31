import 'package:flutter/material.dart';
import 'package:pump_one/features/core/models/refill.dart';

class RefillCard extends StatelessWidget {
  const RefillCard({super.key, required this.refill, this.previousRefill});

  final Refill refill;
  final Refill? previousRefill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.5, color: Colors.grey),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cost: ${refill.cost}"),
          Text('Amount: ${refill.amount}'),
          Text("Tank Percentage: ${refill.fillPercentage}"),
          Text("Date: ${refill.date.toLocal()}"),
          Text("Odometer: ${refill.odometer}"),
          Text(
            "L/100km: ${previousRefill != null ? getLiterPerKilometer(refill, previousRefill).toStringAsFixed(2) : 'N/A'}",
          ),
          Text(
            "km/L: ${previousRefill != null ? getKilometerPerLiter(refill, previousRefill).toStringAsFixed(2) : 'N/A'}",
          ),
          Text("Price per L: ${getPricePerLiter(refill)}"),
        ],
      ),
    );
  }
}

double getLiterPerKilometer(Refill current, Refill? previous) {
  if (previous == null) return 0.0;
  return ((current.odometer - previous.odometer) / current.amount) * 100;
}

double getKilometerPerLiter(Refill current, Refill? previous) {
  if (previous == null) return 0.0;
  return (current.odometer - previous.odometer) / current.amount;
}

double getPricePerLiter(Refill refill) {
  return refill.cost / refill.amount;
}
