import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeUtil {
  static String calculateLastTimeToString(Timestamp lastTime) {
    int distance =
        DateTime.now().millisecondsSinceEpoch - lastTime.millisecondsSinceEpoch;
    if (distance <= const Duration(minutes: 1).inMilliseconds) {
      return "Last seen few seconds ago";
    } else if (distance <= const Duration(hours: 1).inMilliseconds) {
      int minutes = distance ~/ const Duration(minutes: 1).inMilliseconds;
      return "Last seen $minutes minutes ago";
    } else if (distance <= const Duration(days: 1).inMilliseconds) {
      int hours = distance ~/ const Duration(hours: 1).inMilliseconds;
      return "Last seen $hours hours ago";
    } else if (distance <= const Duration(days: 7).inMilliseconds) {
      int days = distance ~/ const Duration(days: 1).inMilliseconds;
      if (days == 1) {
        return "Last seen yesterday";
      }
      return "Last seen $days days ago";
    }else{
      return "Last seen long time ago";
    }
  }
}
