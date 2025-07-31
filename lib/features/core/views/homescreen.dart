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
                onAdd: (refill) async {
                  await RefillDatabase.instance.insertRefill(refill);
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
            itemBuilder: (context, index) {
              final refill = refills[index];
              return Dismissible(
                key: Key(refill.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Refill'),
                      content: Text(
                        'Are you sure you want to delete this refill?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Refill deleted')));
                    return true;
                  }
                  return false;
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
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
