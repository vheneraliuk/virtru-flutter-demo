import 'package:intl/intl.dart';

final policyIdRegExp = RegExp(
  r'[a-hA-H0-9]{8}-[a-hA-H0-9]{4}-[a-hA-H0-9]{4}-[a-hA-H0-9]{4}-[a-hA-H0-9]{12}',
);

final appIdRegExp = RegExp(
  r'[a-hA-H0-9]{8}-[a-hA-H0-9]{4}-[a-hA-H0-9]{4}-[a-hA-H0-9]{4}-[a-hA-H0-9]{12}',
);

final emailRegExp = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

final urlRegExp = RegExp(
  r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
);

const tdfHtmlExt = ".tdf.html";
const tdfExt = ".tdf";

const oneHundredMb = 1024*1024*100;

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

String getRecipientsText(List<String> to) {
  if (to.isEmpty) return '(No Recipients)';
  return '${to.first}${to.length > 1 ? ' (+${to.length - 1})' : ''}';
}
