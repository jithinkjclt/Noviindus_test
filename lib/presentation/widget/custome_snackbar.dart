import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class showCustomSnackbar {
  static void _show(
    BuildContext context, {
    required String message,
    required Color color,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin = const EdgeInsets.all(16),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: AppText(
              message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: duration,
      margin: margin,
      behavior: SnackBarBehavior.floating,
      // Mimics FlushbarStyle.FLOATING
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Mimics borderRadius
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      elevation: 8, // Mimics boxShadows somewhat, SnackBar uses elevation
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    _show(context, message: message, color: Colors.green, icon: icon);
  }

  static void error(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    _show(context, message: message, color: Colors.red, icon: icon);
  }

  static void warning(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    _show(
      context,
      message: message,
      color: const Color(0xFFFF9800), // Direct color for warning
      icon: icon,
    );
  }
}
