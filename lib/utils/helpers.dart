DateTime dateTimeFromUnixWithOffset(int unixUtc, int timezoneOffsetSeconds) {
  // unixUtc and timezone offset are in seconds
  final int total = unixUtc + timezoneOffsetSeconds;
  return DateTime.fromMillisecondsSinceEpoch(total * 1000, isUtc: true);
}

String formatTimeHM(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
