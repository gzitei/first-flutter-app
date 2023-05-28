import 'package:flutter/material.dart';

Widget toastbar(String msg, int seconds) {
  return SnackBar(
    content: Text(msg),
    duration: Duration(seconds: seconds),
  );
}
