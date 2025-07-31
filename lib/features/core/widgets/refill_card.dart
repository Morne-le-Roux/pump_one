import 'package:flutter/material.dart';
import 'package:pump_one/features/core/models/refill.dart';

class RefillCard extends StatelessWidget {
  const RefillCard({super.key, required this.refill});

  final Refill refill;

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
        ],
      ),
    );
  }
}
