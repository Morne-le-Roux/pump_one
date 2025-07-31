import 'package:flutter/material.dart';
import 'package:pump_one/features/core/models/refill.dart';
import 'package:pump_one/features/core/data/refill_database.dart';
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
  void initState() {
    super.initState();
    _loadRefills();
  }

  Future<void> _loadRefills() async {
    final loadedRefills = await RefillDatabase.instance.getAllRefills();
    setState(() {
      refills = loadedRefills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          'Refills',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        elevation: 2,
        onPressed: () {
          Nav.push(
            context,
            AddRefill(
              onAdd: (refill) async {
                await RefillDatabase.instance.insertRefill(refill);
                setState(() => refills.add(refill));
              },
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: refills.length,
            itemBuilder: (context, index) {
              final refill = refills[index];
              return Dismissible(
                key: Key(refill.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.transparent,
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.black38,
                    size: 28,
                  ),
                ),
                confirmDismiss: (direction) async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Refill'),
                      content: const Text(
                        'Are you sure you want to delete this refill?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await RefillDatabase.instance.deleteRefill(refill.id);
                    setState(() {
                      refills.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refill deleted')),
                    );
                    return true;
                  }
                  return false;
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SizedBox(
                    width: double.infinity,
                    child: RefillCard(
                      refill: refill,
                      previousRefill: index > 0 ? refills[index - 1] : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
