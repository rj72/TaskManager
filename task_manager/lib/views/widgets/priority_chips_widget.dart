import 'package:flutter/material.dart';

Widget buildPriorityChip(String priority, bool isCompleted) {
  Color color;
  switch (priority.toLowerCase()) {
    case 'high':
      color = Colors.red;
      break;
    case 'medium':
      color = Colors.orange;
      break;
    default:
      color = Colors.green;
  }

  return Chip(
    label: Text(priority),
    padding: EdgeInsets.zero,
    backgroundColor: color.withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    labelStyle: TextStyle(color: color),
  );
}