import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isLastWeek {
    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
    final endOfLastWeek = startOfThisWeek.subtract(const Duration(seconds: 1));

    return isAfter(startOfLastWeek) && isBefore(endOfLastWeek);
  }

  bool get isLastMonth {
    final now = DateTime.now();
    final firstDayThisMonth = DateTime(now.year, now.month, 1);
    final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayLastMonth = firstDayThisMonth.subtract(
      const Duration(seconds: 1),
    );

    return isAfter(firstDayLastMonth) && isBefore(lastDayLastMonth);
  }

  bool get isLastYear {
    final now = DateTime.now();
    return year == now.year - 1;
  }
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
}
