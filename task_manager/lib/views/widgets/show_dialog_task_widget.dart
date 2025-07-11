import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base.controller.dart';
import '../../model/task.model.dart';
import '../add_task.dialog.dart';

void showAddTaskDialog() async {
  final controller = Get.find<BaseController>();
  final newTask = await showDialog<Task>(
    context: Get.context!,
    builder: (context) => AddTaskDialog(controller: controller),
  );

  if (newTask != null) {
    //controller.tasks.add(newTask);
    //controller.updateTaskCounts();
    controller.addTask(newTask);
  }
}