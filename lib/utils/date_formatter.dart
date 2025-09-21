import 'package:intl/intl.dart';

class DateFormatter {
  // Private constructor to prevent instantiation
  DateFormatter._();

  // Formatters for different date display needs
  static final DateFormat _timeAgoFormatter = DateFormat('MMM dd, yyyy');
  static final DateFormat _fullDateFormatter = DateFormat('EEEE, MMMM dd, yyyy');
  static final DateFormat _shortDateFormatter = DateFormat('MMM dd');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('MMM dd, yyyy HH:mm');

  /// Formats a DateTime to show relative time (e.g., "2 hours ago", "1 day ago")
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else {
      return 'Just now';
    }
  }

  /// Formats a DateTime to show as "Today", "Yesterday", or date
  static String formatSmartDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat('EEEE').format(dateTime); // Day name
    } else {
      return _shortDateFormatter.format(dateTime);
    }
  }

  /// Formats a DateTime to show date and time in a readable format
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Formats a DateTime to show only the date in full format
  static String formatFullDate(DateTime dateTime) {
    return _fullDateFormatter.format(dateTime);
  }

  /// Formats a DateTime to show only the date in short format
  static String formatShortDate(DateTime dateTime) {
    return _shortDateFormatter.format(dateTime);
  }

  /// Formats a DateTime to show only the time
  static String formatTime(DateTime dateTime) {
    return _timeFormatter.format(dateTime);
  }

  /// Formats a DateTime to show date with time ago context
  static String formatNewsDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Same day - show time ago
      if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return _timeAgoFormatter.format(dateTime);
    }
  }

  /// Formats a DateTime specifically for news article display
  static String formatArticleDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return formatShortDate(dateTime);
    }
  }

  /// Parses an ISO 8601 date string to DateTime
  static DateTime? parseISODate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Formats a DateTime to ISO 8601 string
  static String toISOString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Checks if a date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return targetDate == today;
  }

  /// Checks if a date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return targetDate == yesterday;
  }

  /// Gets the start of the day for a given DateTime
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Gets the end of the day for a given DateTime
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }
}