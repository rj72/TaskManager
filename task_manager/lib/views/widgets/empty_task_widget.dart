import 'package:flutter/material.dart';
import 'package:task_manager/views/widgets/show_dialog_task_widget.dart';

Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Try changing filters or create a new task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: showAddTaskDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create New Task'),
          ),
        ],
      ),
    );
  }