import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base.controller.dart';
import '../../model/task.model.dart';
import '../add_task_bottom_sheet.view.dart';

void _showAddTaskBottomSheet() async {
  final controller = Get.find<BaseController>();
  final newTask = await showModalBottomSheet<Task>(
    context: Get.context!,
    isScrollControlled: true,
    builder: (context) => AddTaskBottomSheet(controller: controller),
  );

  if (newTask != null) {
    controller.addTask(newTask);
  }
}
