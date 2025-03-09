import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/provider/income_provider.dart';
import 'package:pocketwise/repository/expense.repo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BarChartSample2 extends StatefulWidget {
  BarChartSample2({super.key});
  final Color incomeColor = greencolor;
  final Color expenseColor = red;
  final Color avgColor = Colors.orange;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];
  bool isLoading = true;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final now = DateTime.now();
      List<BarChartGroupData> items = [];

      // Get last 6 months of data
      for (int i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final monthExpense =
            await _expenseRepository.getTotalExpenseByMonth(month);

        // Get all incomes and filter for this month
        final incomes =
            await Provider.of<IncomeProvider>(context, listen: false).incomes;
        double monthIncome = 0;
        for (var income in incomes) {
          try {
            final incomeDate = DateTime.parse(income.date);
            if (incomeDate.year == month.year &&
                incomeDate.month == month.month) {
              monthIncome += income.amount;
            }
          } catch (e) {
            // Skip invalid dates
            continue;
          }
        }

        items.add(makeGroupData(5 - i, monthIncome, monthExpense));
      }

      if (mounted) {
        setState(() {
          rawBarGroups = items;
          showingBarGroups = items;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(width: 38),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Monthly Overview',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Income vs Expenses',
                        style:
                            TextStyle(color: Color(0xff77839a), fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : showingBarGroups.isEmpty
                      ? const Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: BarChart(
                              BarChartData(
                                maxY: _calculateMaxY(),
                                backgroundColor: Colors.black87,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (barGroup) =>
                                        Colors.grey.withOpacity(0.9),
                                    tooltipRoundedRadius: 8,
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: true,
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      final now = DateTime.now();
                                      final month = DateTime(now.year,
                                          now.month - (5 - groupIndex), 1);
                                      final monthName =
                                          DateFormat('MMM yyyy').format(month);
                                      final amount = NumberFormat.currency(
                                        symbol: 'KES ',
                                        decimalDigits: 2,
                                      ).format(rod.toY);

                                      return BarTooltipItem(
                                        '${rodIndex == 0 ? 'Income' : 'Expense'}\n$monthName\n$amount',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                  touchCallback:
                                      (FlTouchEvent event, response) {
                                    if (response == null ||
                                        response.spot == null) {
                                      setState(() {
                                        touchedGroupIndex = -1;
                                        showingBarGroups =
                                            List.of(rawBarGroups);
                                      });
                                      return;
                                    }

                                    touchedGroupIndex =
                                        response.spot!.touchedBarGroupIndex;

                                    setState(() {
                                      if (!event.isInterestedForInteractions) {
                                        touchedGroupIndex = -1;
                                        showingBarGroups =
                                            List.of(rawBarGroups);
                                        return;
                                      }

                                      showingBarGroups = List.of(rawBarGroups);
                                      if (touchedGroupIndex != -1) {
                                        // Highlight the selected bars by slightly increasing their width
                                        showingBarGroups[touchedGroupIndex] =
                                            showingBarGroups[touchedGroupIndex]
                                                .copyWith(
                                          barRods: showingBarGroups[
                                                  touchedGroupIndex]
                                              .barRods
                                              .map((rod) {
                                            return rod.copyWith(
                                              width: width *
                                                  1.5, // Make selected bars wider
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(2)),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    });
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitles,
                                      reservedSize: 42,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      interval: _calculateInterval(),
                                      getTitlesWidget: leftTitles,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups,
                                gridData: const FlGridData(show: false),
                              ),
                            ),
                          ),
                        ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY() {
    if (showingBarGroups.isEmpty) return 20;
    double maxY = 0;
    for (var group in showingBarGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) maxY = rod.toY;
      }
    }
    return maxY * 1.2; // Add 20% padding
  }

  double _calculateInterval() {
    final maxY = _calculateMaxY();
    return maxY / 5; // Show 5 intervals
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max || value == meta.min) return Container();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        'KES ${NumberFormat.compact().format(value)}',
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final now = DateTime.now();
    final month = DateTime(now.year, now.month - (5 - value.toInt()), 1);
    final monthName = DateFormat('MMM').format(month);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        monthName,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.incomeColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.expenseColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 42,
          color: Colors.white,
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
