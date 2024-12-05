import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
toLocaleString(double number) {
   return NumberFormat('#,##0', 'en_US').format(number);
}


String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}