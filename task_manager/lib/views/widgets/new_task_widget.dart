import 'package:flutter/material.dart';
import 'package:task_manager/views/widgets/show_dialog_task_widget.dart';

Widget buildNewTaskButton() {
  return GestureDetector(
    onTap: showAddTaskDialog,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.add, size: 16, color: Colors.blue),
          SizedBox(width: 4),
          Text(
            'New Task',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    ),
  );
}