import 'package:flutter/material.dart';

Widget buildRoundIconButton({
  required IconData icon,
  required bool isSelected,
  required VoidCallback onPressed,
  required String selectedText,
  required String unselectedText,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.red : Colors.grey,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            iconSize: 32.0,
            splashColor: isSelected ? Colors.red : Colors.grey,
            tooltip: isSelected ? selectedText : unselectedText,
          ),
        ),
        Text(
          isSelected ? selectedText : unselectedText,
        ),
      ],
    ),
  );
}
