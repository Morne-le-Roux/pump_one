import 'package:flutter/material.dart';
import 'package:pump_one/features/core/models/refill.dart';
import 'package:pump_one/features/core/views/add_refill.dart';
import 'package:pump_one/features/core/widgets/refill_card.dart';
import 'package:pump_one/nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Refill> refills = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,

          onPressed: () {
            Nav.push(
              context,
              AddRefill(
                onAdd: (refill) {
                  setState(() => refills.add(refill));
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: refills.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: RefillCard(refill: refills[index]),
            ),
          ),
        ),
      ),
    );
  }
}
