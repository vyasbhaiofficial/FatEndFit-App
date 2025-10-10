import 'package:flutter/material.dart';

class AppLogs {
  /// Toggle this to enable/disable logs globally
  static bool enableLogs = true;

  /// Custom log function
  static void log(
      String message, {
        String tag = 'LOG',
        Color color = Colors.blue,
      }) {
    if (!enableLogs) return;

    // Map Flutter Color to ANSI color code (for terminal colored logs)
    final ansiColor = _ansiColorCode(color);
    final reset = '\x1B[0m';

    // Print with color and tag
    // Example: [HomeScreen] Your message here
    debugPrint('$ansiColor[$tag] $message$reset');
  }

  /// Helper function to convert Flutter Color to ANSI color codes
  static String _ansiColorCode(Color color) {
    if (color == Colors.red) return '\x1B[31m';
    if (color == Colors.green) return '\x1B[32m';
    if (color == Colors.yellow) return '\x1B[33m';
    if (color == Colors.blue) return '\x1B[34m';
    if (color == Colors.purpleAccent) return '\x1B[35m';
    if (color == Colors.cyan) return '\x1B[36m';
    if (color == Colors.white) return '\x1B[37m';
    return '\x1B[0m'; // Default
  }
}
