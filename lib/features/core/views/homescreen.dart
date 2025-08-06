import 'package:flutter/material.dart';
import 'package:refills/features/core/models/refill.dart';
import 'package:refills/features/core/data/refill_database.dart';
import 'package:refills/features/core/views/add_refill.dart';
import 'package:refills/features/core/widgets/refill_card.dart';
import 'package:refills/nav.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Refill> refills = [];
  bool showKmPerLiter = true;
  final int _pageSize = 30;
  int _currentOffset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadInitialRefills() async {
    _currentOffset = 0;
    _hasMore = true;
    final page = await RefillDatabase.instance.getRefillsPage(
      limit: _pageSize,
      offset: _currentOffset,
    );
    setState(() {
      refills = List<Refill>.from(page);
      // ..sort((a, b) => a.odometer.compareTo(b.odometer));
      _currentOffset = page.length;
      _hasMore = page.length == _pageSize;
    });
  }

  Future<void> _loadMoreRefills() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    final page = await RefillDatabase.instance.getRefillsPage(
      limit: _pageSize,
      offset: _currentOffset,
    );
    setState(() {
      refills.addAll(page);
      // refills.sort((a, b) => a.odometer.compareTo(b.odometer));
      _currentOffset += page.length;
      _hasMore = page.length == _pageSize;
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRefills();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<FlSpot> getChartSpots() {
    final latestRefills = refills.length > 30
        ? refills.sublist(0, 30)
        : refills;
    List<FlSpot> spots = [];
    // Reverse the order so the latest is on the right
    for (int i = latestRefills.length - 2; i >= 0; i--) {
      final curr = latestRefills[i];
      final next = latestRefills[i + 1];
      final distance = curr.odometer - next.odometer;
      final liters = curr.amount;
      double kmPerLiter = (liters > 0) ? distance / liters : 0;
      double value = 0;
      if (showKmPerLiter) {
        value = kmPerLiter;
      } else {
        value = (kmPerLiter > 0) ? 100 / kmPerLiter : 0;
      }
      spots.add(FlSpot((latestRefills.length - 2 - i).toDouble(), value));
    }
    return spots;
  }

  @override
  void initState() {
    super.initState();
    _loadSwitchSetting();
    _seedDebugData();

    _loadInitialRefills();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadSwitchSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showKmPerLiter = prefs.getBool('showKmPerLiter') ?? true;
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
                setState(() {
                  refills.add(refill);
                  refills.sort(
                    (a, b) => b.odometer.compareTo(a.odometer),
                  ); // Newest to oldest
                });
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
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: refills.isNotEmpty
                ? refills.length + 2
                : 0, // +1 for graph, +1 for loading
            itemBuilder: (context, index) {
              if (index == 0) {
                // Graph at the top with switch below, inside a card-like container
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 18,
                        ),
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
                          border: Border.all(
                            width: 0.15,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 220,
                              child: Builder(
                                builder: (context) {
                                  final spots = getChartSpots();
                                  // final ticks = getYAxisTicks(spots);
                                  return BarChart(
                                    BarChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        drawHorizontalLine: true,
                                      ),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 38,
                                            // getTitlesWidget: (value, meta) {
                                            //   if (ticks.contains(value)) {
                                            //     return Padding(
                                            //       padding:
                                            //           const EdgeInsets.only(
                                            //             right: 8,
                                            //           ),
                                            //       child: Text(
                                            //         value.toStringAsFixed(1),
                                            //         style: const TextStyle(
                                            //           color: Colors.black54,
                                            //           fontSize: 11,
                                            //         ),
                                            //         textAlign: TextAlign.right,
                                            //       ),
                                            //     );
                                            //   }
                                            //   return const SizedBox.shrink();
                                            // },
                                            // interval: ticks.length > 1
                                            //     ? (ticks[1])
                                            //     : 1,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      barGroups: spots.map((spot) {
                                        return BarChartGroupData(
                                          x: spot.x.toInt(),
                                          barRods: [
                                            BarChartRodData(
                                              toY: spot.y,
                                              color: Colors.black,
                                              width: 8,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              backDrawRodData:
                                                  BackgroundBarChartRodData(
                                                    show: true,
                                                    toY: 0,
                                                    color: Colors.black
                                                        .withOpacity(0.08),
                                                  ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Colors.black54,
                                          tooltipMargin: 8,
                                          fitInsideHorizontally: true,
                                          fitInsideVertically: true,
                                          getTooltipItem:
                                              (
                                                group,
                                                groupIndex,
                                                rod,
                                                rodIndex,
                                              ) {
                                                return BarTooltipItem(
                                                  rod.toY.toStringAsFixed(1),
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'L/100km',
                                  style: TextStyle(
                                    color: !showKmPerLiter
                                        ? Colors.black
                                        : Colors.black38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        showKmPerLiter = !showKmPerLiter;
                                      });
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool(
                                        'showKmPerLiter',
                                        showKmPerLiter,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 260,
                                      ),
                                      curve: Curves.bounceOut,
                                      width: 38,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.black12,
                                          width: 1,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedPositioned(
                                            duration: const Duration(
                                              milliseconds: 260,
                                            ),
                                            curve: Curves.bounceOut,
                                            left: showKmPerLiter ? 18 : 2,
                                            top: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'km/L',
                                  style: TextStyle(
                                    color: showKmPerLiter
                                        ? Colors.black
                                        : Colors.black38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ...existing code...
                    ],
                  ),
                );
              }
              if (index == refills.length + 1 && _hasMore) {
                // Loading indicator at the end
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (index > 0 && index <= refills.length) {
                // Always use sorted refills for calculations
                refills.sort(
                  (a, b) => b.odometer.compareTo(a.odometer),
                ); // Newest to oldest
                final refill = refills[index - 1];
                final nextRefill = (index < refills.length)
                    ? refills[index]
                    : null;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  child: Dismissible(
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
                          refills.remove(refill);
                          refills.sort(
                            (a, b) => b.odometer.compareTo(a.odometer),
                          ); // Newest to oldest
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
                          previousRefill:
                              nextRefill, // Use next refill instead of previous
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _seedDebugData() async {
    // Only run in debug mode
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    if (!isDebug) return;

    // Delete all current data
    final allRefills = await RefillDatabase.instance.getRefillsPage(
      limit: 10000,
      offset: 0,
    );
    for (final refill in allRefills) {
      await RefillDatabase.instance.deleteRefill(refill.id);
    }

    final now = DateTime.now();
    final random = DateTime.now().microsecond;
    // Keep debug data so that L/100km and km/L values stay below 30
    List<Refill> debugRefills = List.generate(20, (i) {
      final randOffset = (i * random) % 1000;
      // Keep odometer increments and amount reasonable for values below 30
      final odometerIncrement =
          120 + (randOffset % 30); // 120-150 km between refills
      final amount = 6.0 + (randOffset % 4); // 6-9 liters per refill
      return Refill(
        id: 'debug_${i}_$randOffset',
        odometer: 10000 + i * odometerIncrement,
        amount: amount,
        cost: 18.0 + (randOffset % 7) + (i % 5),
        fillPercentage: 0.3 + ((randOffset % 7) * 0.09) + ((i % 5) * 0.05),
        date: now.subtract(Duration(days: 30 - i + (randOffset % 5))),
      );
    });
    for (final refill in debugRefills) {
      await RefillDatabase.instance.insertRefill(refill);
    }
    await _loadInitialRefills();
  }
}
