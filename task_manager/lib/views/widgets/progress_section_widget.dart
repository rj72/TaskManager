import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base.controller.dart';

Widget buildProgressSection() {
  final controller = Get.find<BaseController>();
  int completed = controller.completedCount.value;
  int total = controller.totalTasks.value;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Progress',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : completed / total,
            backgroundColor: Colors.grey[200],
            minHeight: 8,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          )),
      const SizedBox(height: 8),
      Text(
        '$completed/$total completed',
        style: const TextStyle(color: Colors.grey),
      ),
    ],
  );
}