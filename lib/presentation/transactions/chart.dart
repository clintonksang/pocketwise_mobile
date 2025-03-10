import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/provider/income_provider.dart';
import 'package:pocketwise/repository/expense.repo.dart';
import 'package:pocketwise/repository/budget.repo.dart';
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
  String selectedCategory = 'all';

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

      // Get all incomes first (these will be constant)
      final incomes =
          await Provider.of<IncomeProvider>(context, listen: false).incomes;
      Map<int, double> monthlyIncomes = {};

      // Calculate income for each month
      for (var income in incomes) {
        try {
          final incomeDate = DateTime.parse(income.date);
          final monthKey = (incomeDate.year - now.year) * 12 +
              (incomeDate.month - now.month);
          monthlyIncomes[monthKey] =
              (monthlyIncomes[monthKey] ?? 0) + income.amount;
        } catch (e) {
          continue;
        }
      }

      // Get last 6 months of data
      for (int i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        double monthExpense = 0;

        if (selectedCategory == 'all') {
          monthExpense = await _expenseRepository.getTotalExpenseByMonth(month);
        } else {
          // Get expenses for specific category
          final expenses = await _expenseRepository.getAllTransactions();
          monthExpense = expenses.where((expense) {
            final expenseDate = DateTime.parse(expense.dateCreated);
            return expenseDate.year == month.year &&
                expenseDate.month == month.month &&
                expense.category.toLowerCase() ==
                    selectedCategory.toLowerCase();
          }).fold(0, (sum, expense) => sum + double.parse(expense.amount));
        }

        // Get income for this month (or 0 if no income)
        final monthKey = -i; // Negative because we're counting backwards
        final monthIncome = monthlyIncomes[monthKey] ?? 0;

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

  Widget _buildCategoryFilter() {
    return Consumer<BudgetRepository>(
      builder: (context, budgetRepository, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('All', 'all'),
              ...budgetRepository.categories.map((category) =>
                  _buildCategoryChip(category.title, category.type)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = selectedCategory == value;
    final color = value == 'all'
        ? primaryColor
        : value == 'needs'
            ? needsColor
            : value == 'wants'
                ? wantsColor
                : value == 'savings'
                    ? sandicolor
                    : debtColor;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: color,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              selectedCategory = value;
            });
            _loadData();
          }
        },
        showCheckmark: false,
      ),
    );
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
                const SizedBox(width: 38),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Overview',
                        style: TextStyle(color: primaryColor, fontSize: 22),
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
            const SizedBox(height: 16),
            _buildCategoryFilter(),
            const SizedBox(height: 22),
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
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (barGroup) =>
                                        Colors.grey.withOpacity(0.8),
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
                                        showingBarGroups[touchedGroupIndex] =
                                            showingBarGroups[touchedGroupIndex]
                                                .copyWith(
                                          barRods: showingBarGroups[
                                                  touchedGroupIndex]
                                              .barRods
                                              .map((rod) {
                                            return rod.copyWith(
                                              width: width * 1.5,
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
    return maxY * 1.2;
  }

  double _calculateInterval() {
    final maxY = _calculateMaxY();
    return maxY / 5;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max || value == meta.min) return Container();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        'KES ${NumberFormat.compact().format(value)}',
        style: const TextStyle(
          color: Color(0xff7589a2),
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
          color: Color(0xff7589a2),
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
}
