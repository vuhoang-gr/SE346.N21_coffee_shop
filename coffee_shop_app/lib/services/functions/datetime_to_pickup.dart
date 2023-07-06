import 'package:intl/intl.dart';

String datetimeToPickup(DateTime dateTime) {
  var now = DateTime.now();
  var day = DateFormat('dd/MM/yyyy').format(dateTime).toString();
  if (now.month == dateTime.month && dateTime.year == now.year) {
    if (now.day == dateTime.day) {
      day = 'Hôm nay';
    } else if (now.day == dateTime.day - 1) {
      day = 'Ngày mai';
    }
  }

  return '$day, ${datetimeToHour(dateTime)}';
}

String datetimeToHour(DateTime dateTime) {
  return '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
}

String indexToTime(int index) {
  int hour = (index / 2).floor();
  return '${hour < 10 ? '0$hour' : hour}:${index % 2 * 30 == 0 ? '00' : index % 2 * 30}';
}

int dateTimeToHour(DateTime dateTime) {
  return dateTime.hour * 2 + (dateTime.minute > 30 ? 2 : 1);
}

int timeCloseToHour(DateTime dateTime) {
  return dateTime.hour * 2 + (dateTime.minute >= 30 ? 1 : 0);
}
