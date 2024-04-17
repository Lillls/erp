import 'package:flutter/foundation.dart';

class Log {
  static void d(String message, {String tag =""}) {
    debugPrint("$tag $message");
  }
}