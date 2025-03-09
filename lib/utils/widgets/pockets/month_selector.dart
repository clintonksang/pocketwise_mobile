import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

class MonthSelector extends StatefulWidget {
  final DateTime selectedMonth;
  final Function(DateTime) onMonthSelected;

  const MonthSelector({
    Key? key,
    required this.selectedMonth,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late ScrollController _scrollController;
  final int monthsToShow = 12; // Show 1 year worth of months
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: monthsToShow,
        itemBuilder: (context, index) {
          // Calculate month by subtracting from current month (0 = current, 1 = last month, etc.)
          final month = DateTime(
            currentMonth.year,
            currentMonth.month - index,
            1,
          );

          final isSelected = month.year == widget.selectedMonth.year &&
              month.month == widget.selectedMonth.month;

          // Make current month selected by default if nothing is selected
          final isCurrentMonth = index == 0;
          final shouldBeSelected = isSelected ||
              (isCurrentMonth && widget.selectedMonth == currentMonth);

          return GestureDetector(
            onTap: () => widget.onMonthSelected(month),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: shouldBeSelected ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: shouldBeSelected ? primaryColor : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  DateFormat('MMM yyyy').format(month),
                  style: AppTextStyles.normal.copyWith(
                    fontSize: 12,
                    color: shouldBeSelected ? Colors.white : Colors.black,
                    fontWeight:
                        shouldBeSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
