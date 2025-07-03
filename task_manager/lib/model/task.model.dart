import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Task {
  static int _idCounter = 0;

  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime? dueDate;
  final RxBool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.category,
    this.priority = 'Medium',
    this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted.value ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: (map['isCompleted'] == 1).obs,
    );
  }
}
