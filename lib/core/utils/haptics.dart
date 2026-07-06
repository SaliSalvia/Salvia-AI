import 'package:flutter/services.dart';

class HapticUtils {
  HapticUtils._();

  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> success() => HapticFeedback.lightImpact();
  static Future<void> error() => HapticFeedback.vibrate();
}
