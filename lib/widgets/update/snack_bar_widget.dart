import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Center(child: Text(message)));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }