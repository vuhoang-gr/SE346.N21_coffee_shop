import 'package:flutter/material.dart';

final ButtonStyle roundedButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    elevation: 0,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(45))));

final ButtonStyle outlinedButton = OutlinedButton.styleFrom(
  elevation: 0,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(45))),
  side: const BorderSide(width: 1, color: Colors.blue),
);
