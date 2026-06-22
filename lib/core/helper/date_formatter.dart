import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _dayFormat = DateFormat('dd MMM yyyy');

  static String toDisplay(DateTime date) => _displayFormat.format(date);

  static String toDay(DateTime date) => _dayFormat.format(date);

  static String toDbString(DateTime date) => date.toIso8601String();

  static DateTime fromDbString(String value) => DateTime.parse(value);
}
