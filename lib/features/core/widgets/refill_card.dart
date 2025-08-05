import 'package:flutter/material.dart';
import 'package:refills/features/core/models/refill.dart';

class RefillCard extends StatelessWidget {
  const RefillCard({super.key, required this.refill, this.previousRefill});

  final Refill refill;
  final Refill? previousRefill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(width: 0.15, color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "R${refill.cost.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "${refill.amount.toStringAsFixed(2)} L",
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${refill.fillPercentage.toStringAsFixed(0)}% full",
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Text(
                "${refill.odometer} km",
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${refill.date.day.toString().padLeft(2, '0')}/${refill.date.month.toString().padLeft(2, '0')}/${refill.date.year}",
                style: const TextStyle(color: Colors.black38, fontSize: 13),
              ),
              Text(
                "R${getPricePerLiter(refill).toStringAsFixed(2)}/L",
                style: const TextStyle(color: Colors.black38, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "L/100km: ${previousRefill != null ? getLiterPerKilometer(refill, previousRefill).toStringAsFixed(2) : 'N/A'}",
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              Text(
                "km/L: ${previousRefill != null ? getKilometerPerLiter(refill, previousRefill).toStringAsFixed(2) : 'N/A'}",
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

double getLiterPerKilometer(Refill current, Refill? previous) {
  if (previous == null) return 0.0;
  double kmPerLiter = (current.amount > 0)
      ? (current.odometer - previous.odometer) / current.amount
      : 0;
  return (kmPerLiter > 0) ? 100 / kmPerLiter : 0;
}

double getKilometerPerLiter(Refill current, Refill? previous) {
  if (previous == null) return 0.0;
  return (current.odometer - previous.odometer) / current.amount;
}

double getPricePerLiter(Refill refill) {
  return refill.cost / refill.amount;
}
