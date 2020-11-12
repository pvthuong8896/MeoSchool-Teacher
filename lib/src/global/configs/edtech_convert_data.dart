import 'dart:convert';

import 'package:intl/intl.dart';

class EdTechConvertData {
  static String convertTimeString(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat('dd/MM/yyyy').format(DateTime.parse('$time'));
  }

  static DateTime convertDateTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return time;
  }

  static String convertServerDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 năm trước' : 'Năm trước';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 tháng trước' : 'Tháng trước';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 tuần trước' : 'Tuần trước';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ngày trước' : 'Hôm qua';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 giờ trước' : '1 giờ trước';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 phút trước' : '1 phút trước';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'Vừa mới';
    }
  }

  static String convertTime(String dateString) {
    var format = DateFormat('HH:mm');
    var date = DateTime.parse(dateString).toLocal();
    var time = format.format(date);
    return time;
  }

  static String convertDate(String dateString) {
    dynamic dayData =
        '{ "1" : "Thứ 2", "2" : "Thứ 3", "3" : "Thứ 4", "4" : "Thứ 5", "5" : "Thứ 6", "6" : "Thứ 7", "7" : "CN" }';
    var format = DateFormat('dd/MM/yyyy');
    var date = DateTime.parse(dateString);
    var time = json.decode(dayData)['${date.weekday}'] + " ngày " +  format.format(date);

    return time;
  }

  static String messageTime(String dateString) {
    var format = DateFormat('HH:mm');
    var date = DateTime.parse(dateString);
    var time = '';
    time = format.format(date);
    return time;
  }

  static String conversationTime(DateTime date) {
    var dayFormat = DateFormat("dd/MM/yyyy");
    var dateString = dayFormat.format(date);
    var nowString = dayFormat.format(DateTime.now());
    var diff = dayFormat.parse(nowString).difference(dayFormat.parse(dateString));
    var time = '';
    if (diff.inDays == 0) {
      var format = DateFormat('HH:mm');
      time = format.format(date);
    } else if (diff.inDays == 1) {
      time = 'Hôm qua';
    } else {
      var format = DateFormat('dd/MM');
      time = format.format(date);
    }
    return time;
  }

  static bool compareDate(String dateString) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy');
    var date = DateTime.parse(dateString);

    if (format.format(date) == format.format(now)) {
      return true;
    }
    return false;
  }

  static String messageDate(String dateString, String lastDateString) {
    dynamic dayData =
        '{ "1" : "T.2", "2" : "T.3", "3" : "T.4", "4" : "T.5", "5" : "T.6", "6" : "T.7", "7" : "CN" }';

    dynamic monthData =
        '{ "1" : "Th 1", "2" : "Th 2", "3" : "Th 3", "4" : "Th 4", "5" : "Th 5", "6" : "Th 6", "7" : "Th 7", "8" : "Th 8", "9" : "Th 9", "10" : "Th 10", "11" : "Th 11", "12" : "Th 12" }';
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy');
    var formatTime = DateFormat('HH:mm');
    var formatDate = DateFormat('dd');
    var date = DateTime.parse(dateString);
    var lastDate = DateTime.parse(lastDateString);
    var time = '';

    if(format.format(date) != format.format(lastDate)) {
      if (format.format(date) == format.format(now)) {
        time = "Hôm nay" + ", " +  formatTime.format(date);
      } else {
        var diff = now.difference(date);
        if (diff.inDays >= 0 && diff.inDays < 7) {
          time = json.decode(dayData)['${date.weekday}'] + ", " +  formatTime.format(date);
        } else {
          time = formatDate.format(date) + " " + json.decode(monthData)['${date.month}'] + ", " +  formatTime.format(date);
        }
      }
    } else {
      time = '';
    }

    return time;
  }

  static String firstMessageDate(String dateString) {
    dynamic dayData =
        '{ "1" : "T.2", "2" : "T.3", "3" : "T.4", "4" : "T.5", "5" : "T.6", "6" : "T.7", "7" : "CN" }';

    dynamic monthData =
        '{ "1" : "Th 1", "2" : "Th 2", "3" : "Th 3", "4" : "Th 4", "5" : "Th 5", "6" : "Th 6", "7" : "Th 7", "8" : "Th 8", "9" : "Th 9", "10" : "Th 10", "11" : "Th 11", "12" : "Th 12" }';
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy');
    var formatTime = DateFormat('HH:mm');
    var formatDate = DateFormat('dd');
    var date = DateTime.parse(dateString);
    var time = '';

    if (format.format(date) == format.format(now)) {
      time = "Hôm nay" + ", " +  formatTime.format(date);
    } else {
      var diff = now.difference(date);
      if (diff.inDays >= 0 && diff.inDays < 7) {
        time = json.decode(dayData)['${date.weekday}'] + ", " +  formatTime.format(date);
      } else {
        time = formatDate.format(date) + " " + json.decode(monthData)['${date.month}'] + ", " +  formatTime.format(date);
      }
    }

    return time;
  }

  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static String startOfWeek(DateTime date) {
    var start = getDate(date.subtract(Duration(days: date.weekday - 1)));
    var format = DateFormat('dd/MM/yyyy');
    return format.format(start);
  }

  static String startOfWeekServer(DateTime date) {
    var start = getDate(date.subtract(Duration(days: date.weekday - 1)));
    return convertServerDate(start);
  }

  static String endOfWeek(DateTime date) {
    var end = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
    var format = DateFormat('dd/MM/yyyy');
    return format.format(end);
  }

  static String endOfWeekServer(DateTime date) {
    var end = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
    return convertServerDate(end);
  }

  static String getMonth(DateTime date) {
    return "Tháng ${date.month}";
  }

  static String getStartOfMonthServer(DateTime now) {
    var startDate = new DateTime(now.year, now.month, 1);
    return convertServerDate(startDate);
  }

  static String getEndOfMonthServer(DateTime now) {
    var lastDate = (now.month < 12) ? new DateTime(now.year, now.month + 1, 0) : new DateTime(now.year + 1, 1, 0);
    return convertServerDate(lastDate);
  }

  static String getYear(DateTime date) {
    return "Năm ${date.year}";
  }

  static String getStartOfYear(DateTime now) {
    var startDate = new DateTime(now.year, 1, 1);
    return convertServerDate(startDate);
  }

  static String getEndOfYear(DateTime now) {
    var startDate = new DateTime(now.year + 1, 1, 0);
    return convertServerDate(startDate);
  }
}