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

  void init() {}

  @override
  void dispose() {
    costController.dispose();
    amountController.dispose();
    fillPercentageController.dispose();
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
      appBar: AppBar(title: Text("Add a Refill")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(hint: Text("Cost")),
                keyboardType: TextInputType.numberWithOptions(),
                controller: costController,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (value) {
                  if (double.tryParse(value ?? "") == null) {
                    isValid = false;
                    return "Invalid";
                  }
                  isValid = true;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hint: Text("Amount")),
                keyboardType: TextInputType.numberWithOptions(),
                autovalidateMode: AutovalidateMode.onUnfocus,
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
              TextFormField(
                decoration: InputDecoration(
                  hint: Text("Tank Fill % (After refill)"),
                ),
                keyboardType: TextInputType.numberWithOptions(),
                autovalidateMode: AutovalidateMode.onUnfocus,
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
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  if (isValid) {
                    refill = Refill(
                      id: Uuid().v4(),
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Text("Add Refill"),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
