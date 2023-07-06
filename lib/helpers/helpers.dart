import 'package:intl/intl.dart';

String getDateString(DateTime dateSent) {
  final now = DateTime.now().toUtc();
  final today = DateTime(now.year, now.month, now.day);
  final daySent = DateTime(dateSent.year, dateSent.month, dateSent.day);
  if (daySent == today) {
    return DateFormat.jm().format(dateSent.toLocal());
  } else if (daySent.year == today.year) {
    return DateFormat.MMMd().format(dateSent.toLocal());
  }
  return DateFormat.yMMMd().format(dateSent.toLocal());
}

String getDateTimeString(DateTime dateSent) {
  final now = DateTime.now().toUtc();
  final today = DateTime(now.year, now.month, now.day);
  final daySent = DateTime(dateSent.year, dateSent.month, dateSent.day);
  if (daySent == today) {
    return DateFormat.jm().format(dateSent.toLocal());
  } else if (daySent.year == today.year) {
    return DateFormat.MMMd().add_jm().format(dateSent.toLocal());
  }
  return DateFormat.yMMMd().add_jm().format(dateSent.toLocal());
}
