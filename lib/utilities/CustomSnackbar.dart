import 'package:flutter/material.dart';

SnackBar customSnackbar(content, Color bgColor) {
  return SnackBar(
    content: Text(content),
    backgroundColor: bgColor,
  );
}
