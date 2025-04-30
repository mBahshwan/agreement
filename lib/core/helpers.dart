import 'package:flutter/material.dart';

class Helpers {
  static void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> navigateToPushAndRemoveUntil(
      BuildContext context, Widget page) async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (context) => false,
    );
  }

  static Future<void> navigateToPush(BuildContext context, Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
