import 'package:flutter/material.dart';

class YoudioSnackbar {
  static SnackBar snackBar(String text) {
    return SnackBar(
      backgroundColor: Colors.grey[850],
      duration: const Duration(seconds: 3),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
