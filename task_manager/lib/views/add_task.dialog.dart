import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controllers/base.controller.dart';
import '../model/task.model.dart';
import 'base_stateless.view.dart';

class AddTaskDialog extends BaseStatelessView<BaseController> {
  final Task? task;

  const AddTaskDialog({super.key, required super.controller, this.task});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    late String title = task?.title ?? '';
    String description = task?.description ?? '';
    String priority = task?.priority ?? 'Medium';
    String category = task?.category ?? 'Personal';
    var dueDate = Rxn<DateTime>(task?.dueDate);

    return AlertDialog(
      title: Text(task == null ? 'Create New Task' : 'Edit Task'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'What needs to be done?',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Title is required' : null,
                onSaved: (value) => title = value ?? '',
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add details about the task',
                ),
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 6),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: priority,
                      items: ['Low', 'Medium', 'High']
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              ))
                          .toList(),
                      onChanged: (value) => priority = value ?? 'Medium',
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: category,
                      items: controller.categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (value) => category = value ?? 'Personal',
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDate.value = picked;
                  }
                },
                child: Obx(
                  () => InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due date (optional)',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dueDate.value == null
                              ? 'Select a date'
                              : '${dueDate.value!.day}/${dueDate.value!.month}/${dueDate.value!.year}',
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              Navigator.pop(
                context,
                Task(
                    title: title,
                    description: description,
                    category: category,
                    priority: priority,
                    dueDate: dueDate.value,
                    isCompleted: false.obs),
              );
            }
          },
          child: Text(task == null ? 'Create Task' : 'Edit Task'),
        ),
      ],
    );
  }
}
