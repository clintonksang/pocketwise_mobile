import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/provider/income_provider.dart';
import 'package:pocketwise/repository/expense.repo.dart';
import 'package:pocketwise/repository/budget.repo.dart';
import 'package:pocketwise/utils/widgets/pockets/month_selector.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:math';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<StatefulWidget> createState() => TransactionsState();
}

class TransactionsState extends State {
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  String? selectedCategory;
  bool isLoading = true;
  Map<String, double> categoryExpenses = {};
  Map<String, Color> categoryColors = {};
  DateTime selectedMonth = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  double totalAmount = 0.0;
  List<DateTime> daysWithoutExpenses = [];

  @override
  void initState() {
    super.initState();
    startDate = DateTime(selectedMonth.year, selectedMonth.month, 1);
    endDate = startDate;
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final expenses = startDate == endDate
          ? await _expenseRepository.getTransactionsByMonth(startDate!)
          : await _expenseRepository.getTransactionsByDateRange(
              startDate!, endDate!);

      Map<String, double> expensesByCategory = {};
      double total = 0.0;

      // Get all dates in the range
      List<DateTime> allDates = [];
      DateTime current = startDate!;
      while (current.isBefore(endDate!.add(Duration(days: 1)))) {
        allDates.add(current);
        current = current.add(Duration(days: 1));
      }

      // Get dates with expenses
      Set<DateTime> datesWithExpenses = {};
      for (var expense in expenses) {
        final category = expense.category.toLowerCase();
        final amount = double.parse(expense.amount);
        expensesByCategory[category] =
            (expensesByCategory[category] ?? 0) + amount;
        total += amount;

        // Parse the expense date
        DateTime? expenseDate;
        try {
          expenseDate = DateTime.parse(expense.dateCreated);
        } catch (e) {
          try {
            final DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
            expenseDate = format.parse(expense.dateCreated);
          } catch (e) {
            Logger().e('Error parsing date: ${expense.dateCreated}');
            continue;
          }
        }

        if (expenseDate != null) {
          datesWithExpenses.add(
              DateTime(expenseDate.year, expenseDate.month, expenseDate.day));
        }
      }

      // Find days without expenses
      daysWithoutExpenses =
          allDates.where((date) => !datesWithExpenses.contains(date)).toList();

      await _loadOrGenerateColors(expensesByCategory.keys.toList());

      if (mounted) {
        setState(() {
          categoryExpenses = expensesByCategory;
          totalAmount = total;
          isLoading = false;
        });
      }
    } catch (e) {
      Logger().e('Error loading data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadOrGenerateColors(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final colorsJson = prefs.getString('category_colors');
    Map<String, Color> loadedColors = {};

    if (colorsJson != null) {
      final Map<String, dynamic> colorsMap = json.decode(colorsJson);
      colorsMap.forEach((key, value) {
        loadedColors[key] = Color(value);
      });
    }

    // Generate new colors for categories that don't have one
    for (var category in categories) {
      if (!loadedColors.containsKey(category)) {
        loadedColors[category] = _generateRandomColor();
      }
    }

    // Save updated colors
    final Map<String, dynamic> colorsToSave = {};
    loadedColors.forEach((key, value) {
      colorsToSave[key] = value.value;
    });
    await prefs.setString('category_colors', json.encode(colorsToSave));

    if (mounted) {
      setState(() {
        categoryColors = loadedColors;
      });
    }
  }

  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  void _handleCategorySelect(String category) {
    setState(() {
      if (selectedCategory == category.toLowerCase()) {
        selectedCategory = null;
      } else {
        selectedCategory = category.toLowerCase();
      }
    });
  }

  List<PieChartSectionData> showingSections() {
    final total =
        categoryExpenses.values.fold(0.0, (sum, value) => sum + value);
    if (total == 0) return [];

    return categoryExpenses.entries.map((entry) {
      final isSelected = selectedCategory == entry.key.toLowerCase();
      final fontSize = isSelected ? 25.0 : 16.0;
      final radius = isSelected ? 110.0 : 100.0;
      final percentage = (entry.value / total * 100).toStringAsFixed(1);
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final baseColor = categoryColors[entry.key.toLowerCase()] ?? primaryColor;
      final color = selectedCategory == null || isSelected
          ? baseColor
          : baseColor.withOpacity(0.2);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  Future<void> _handleDateRangeSelected(DateTime start, DateTime end) async {
    setState(() {
      startDate = start;
      endDate = end;
      selectedMonth = start; // Keep for compatibility
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await _expenseRepository.refreshTransactions();
              await _loadData();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Transactions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                MonthSelector(
                  selectedMonth: selectedMonth,
                  onDateRangeSelected: _handleDateRangeSelected,
                  isCustomRangeSelected: startDate != endDate,
                ),
                const SizedBox(height: 16),
                // Text(
                //   startDate == endDate
                //       ? 'Expenses by Category'
                //       : 'Expenses by Category (${DateFormat('dd MMM yyyy').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)})',
                //   style: TextStyle(
                //     color: primaryColor,
                //     fontSize: 24,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const SizedBox(height: 8),
                if (selectedCategory != null) ...[
                  Text(
                    startDate == endDate
                        ? 'You spent ${NumberFormat.currency(symbol: 'KES ', decimalDigits: 2).format(categoryExpenses[selectedCategory] ?? 0)} in ${DateFormat('MMMM yyyy').format(startDate!)} on ${selectedCategory!.toUpperCase()}'
                        : 'You spent ${NumberFormat.currency(symbol: 'KES ', decimalDigits: 2).format(categoryExpenses[selectedCategory] ?? 0)} between ${DateFormat('dd MMM yyyy').format(startDate!)} and ${DateFormat('dd MMM yyyy').format(endDate!)} on ${selectedCategory!.toUpperCase()}',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total spent: ${NumberFormat.currency(symbol: 'KES ', decimalDigits: 2).format(totalAmount)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  Text(
                    startDate == endDate
                        ? 'You spent ${NumberFormat.currency(symbol: 'KES ', decimalDigits: 2).format(totalAmount)} in ${DateFormat('MMMM yyyy').format(startDate!)}'
                        : 'You spent ${NumberFormat.currency(symbol: 'KES ', decimalDigits: 2).format(totalAmount)} between ${DateFormat('dd MMM yyyy').format(startDate!)} and ${DateFormat('dd MMM yyyy').format(endDate!)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (daysWithoutExpenses.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'No expenses on ${daysWithoutExpenses.length} days',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : categoryExpenses.isEmpty
                          ? const Center(
                              child: Text(
                                'No expenses available',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 24),
                                Expanded(
                                  flex: 5,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            return;
                                          }
                                          final category = categoryExpenses.keys
                                              .elementAt(pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex);
                                          _handleCategorySelect(category);
                                        },
                                      ),
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: showingSections(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        categoryExpenses.entries.map((entry) {
                                      final total = categoryExpenses.values
                                          .fold(
                                              0.0, (sum, value) => sum + value);
                                      final percentage =
                                          (entry.value / total * 100)
                                              .toStringAsFixed(1);
                                      final amount = NumberFormat.currency(
                                        symbol: 'KES ',
                                        decimalDigits: 2,
                                      ).format(entry.value);
                                      final isSelected = selectedCategory ==
                                          entry.key.toLowerCase();
                                      final baseColor = categoryColors[
                                              entry.key.toLowerCase()] ??
                                          primaryColor;

                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              _handleCategorySelect(entry.key),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? baseColor.withOpacity(0.15)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: baseColor,
                                                      width: 1.5,
                                                    )
                                                  : null,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: baseColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        entry.key.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isSelected
                                                              ? baseColor
                                                              : Colors.black54,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  amount,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isSelected
                                                        ? baseColor
                                                        : Colors.black54,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '($percentage%)',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isSelected
                                                        ? baseColor
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
