import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

const oneHundredMb = 1024 * 1024 * 100;

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

bool isDesktop() => Platform.isLinux || Platform.isMacOS || Platform.isWindows;

Future<String> getTempFilePath(String fileName) async {
  if (kIsWeb) {
    return fileName;
  } else {
    return "${(await getTemporaryDirectory()).path}/$fileName";
  }
}

extension GlobalPaintBounds on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

extension Delete on XFile {
  delete() async {
    if (!kIsWeb) {
      await File(path).delete();
    }
  }
}

extension ConverterPlatforFile on PlatformFile {
  XFile toXFile() {
    if (kIsWeb) {
      return XFile.fromData(
        bytes!,
        name: name,
        length: size,
      );
    }
    return XFile(path!);
  }
}
