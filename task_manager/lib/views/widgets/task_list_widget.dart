import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/views/widgets/priority_chips_widget.dart';

import '../../controllers/base.controller.dart';
import '../../model/task.model.dart';
import '../add_task.dialog.dart';
import 'empty_task_widget.dart';

Widget buildTaskList() {
  final controller = Get.find<BaseController>();
  final tasks = controller.combinedFilteredTasks;

  if (tasks.isEmpty) {
    return buildEmptyState();
  }
  return ListView.separated(
    itemCount: tasks.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final task = tasks[index];
      return Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                final updatedTask = await showDialog<Task>(
                  context: Get.context!,
                  builder: (context) => AddTaskDialog(
                    controller: controller,
                    task: task,
                  ),
                );
                if (updatedTask != null) {
                  controller.updateTask(updatedTask);
                }
              },
              icon: Icons.edit,
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withOpacity(0.1),
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) async {
                controller.deleteTask(task.id!);
              },
              icon: Icons.delete,
              foregroundColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            task.isCompleted.toggle();
            controller.updateTaskCounts();
            controller.updateTask(task);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: InkWell(
              onTap: () {
                task.isCompleted.toggle();
                controller.updateTaskCounts();
                controller.updateTask(task);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    task.isCompleted.value
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.circle_outlined),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  task.title,
                                  style: task.isCompleted.value
                                      ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration:
                                    TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                  )
                                      : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            buildPriorityChip(
                                task.priority, task.isCompleted.value),
                            const SizedBox(width: 12),
                            buildPriorityChip(
                                task.category, task.isCompleted.value),
                            const SizedBox(width: 12),
                            task.dueDate != null
                                ? Text(
                              task.dueDate!.toFormattedString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        if (task.description.isNotEmpty)
                          Text(
                            task.description,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}