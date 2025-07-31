import 'package:flutter/material.dart';
import 'package:pump_one/features/core/models/refill.dart';
import 'package:pump_one/nav.dart';
import 'package:uuid/uuid.dart';

class AddRefill extends StatefulWidget {
  const AddRefill({super.key, required this.onAdd});

  final void Function(Refill) onAdd;

  @override
  State<AddRefill> createState() => _AddRefillState();
}

class _AddRefillState extends State<AddRefill> {
  late Refill refill;
  bool isValid = false;

  final TextEditingController costController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController fillPercentageController =
      TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  void init() {}

  @override
  void dispose() {
    costController.dispose();
    amountController.dispose();
    fillPercentageController.dispose();
    odometerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          "Add a Refill",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Cost (R)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: costController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (double.tryParse(value ?? "") == null) {
                    isValid = false;
                    return "Invalid";
                  }
                  isValid = true;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Amount (L)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: amountController,
                validator: (value) {
                  if (double.tryParse(value ?? "") == null) {
                    isValid = false;
                    return "Invalid";
                  }
                  isValid = true;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Tank Fill % (After refill)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: fillPercentageController,
                validator: (value) {
                  if (double.tryParse(value ?? "") == null) {
                    isValid = false;
                    return "Invalid";
                  }
                  isValid = true;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Odometer Reading (km)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: odometerController,
                validator: (value) {
                  if (int.tryParse(value ?? "") == null) {
                    isValid = false;
                    return "Invalid";
                  }
                  isValid = true;
                  return null;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (isValid) {
                    refill = Refill(
                      id: Uuid().v4(),
                      odometer: int.tryParse(odometerController.text) ?? 0,
                      date: DateTime.now(),
                      cost: double.tryParse(costController.text) ?? 0,
                      amount: double.tryParse(amountController.text) ?? 0,
                      fillPercentage:
                          double.tryParse(fillPercentageController.text) ?? 0,
                    );
                    widget.onAdd(refill);
                    Nav.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Add Refill",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
