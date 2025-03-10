import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customsnackbar.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

class MonthSelector extends StatefulWidget {
  final DateTime selectedMonth;
  final Function(DateTime, DateTime) onDateRangeSelected;

  const MonthSelector({
    Key? key,
    required this.selectedMonth,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late ScrollController _scrollController;
  final int monthsToShow = 12;
  late DateTime currentMonth;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
 
    currentMonth = DateTime.now();
    _scrollController = ScrollController();
    // Initialize with current month as both start and end date
    startDate =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    endDate =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showDateRangePicker() async {
    // Show snackbar to inform about scrolling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scroll up to see earlier dates, then select from and to  date range',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
      helpText: "Select Date Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              titleMedium: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     "",
              //     style: TextStyle(
              //       color: primaryColor,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              Expanded(child: child!),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = DateTime(picked.start.year, picked.start.month, 1);
        endDate = DateTime(picked.end.year, picked.end.month, 1);
      });
      widget.onDateRangeSelected(startDate!, endDate!);
    }
  }

  String _formatDateRange() {
    if (startDate == null || endDate == null) {
      return DateFormat('MMM yyyy').format(widget.selectedMonth);
    }

    if (startDate!.year == endDate!.year &&
        startDate!.month == endDate!.month) {
      return DateFormat('MMM yyyy').format(startDate!);
    }

    return '${DateFormat('MMM yyyy').format(startDate!)} - ${DateFormat('MMM yyyy').format(endDate!)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: monthsToShow,
              itemBuilder: (context, index) {
                final month = DateTime(
                  currentMonth.year,
                  currentMonth.month - index,
                  1,
                );

                final isInRange = startDate != null &&
                    endDate != null &&
                    month.isAfter(startDate!.subtract(Duration(days: 1))) &&
                    month.isBefore(endDate!.add(Duration(days: 1)));

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      startDate = month;
                      endDate = month;
                    });
                    widget.onDateRangeSelected(month, month);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isInRange ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isInRange ? primaryColor : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('MMM yyyy').format(month),
                        style: AppTextStyles.normal.copyWith(
                          fontSize: 12,
                          color: isInRange ? Colors.white : Colors.black,
                          fontWeight:
                              isInRange ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: _showDateRangePicker,
            child: Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.date_range,
                    size: 16,
                    color: primaryColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Range',
                    style: AppTextStyles.normal.copyWith(
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
