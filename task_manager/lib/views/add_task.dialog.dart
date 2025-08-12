import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../controllers/base.controller.dart';
import '../model/task.model.dart';
import 'base_stateless.view.dart';

class AddTaskDialog extends BaseStatelessView<BaseController> {
  final Task? task;

  const AddTaskDialog({super.key, required super.controller, this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    late String title = task?.title ?? '';
    String description = task?.description ?? '';
    String priority = task?.priority ?? l10n.medium;
    String category = task?.category ?? l10n.personal;
    var dueDate = Rxn<DateTime>(task?.dueDate);

    final categories = controller.getTranslatedCategories(context);

    String getPriorityLabel(String key) {
      switch (key) {
        case 'High':
          return l10n.high;
        case 'Medium':
          return l10n.medium;
        case 'Low':
          return l10n.low;
        default:
          return l10n.low; // Default to low if not recognized
      }
    }

    String setPriorityLabel(String label) {
      if (label == l10n.high) return 'High';
      if (label == l10n.medium) return 'Medium';
      if (label == l10n.low) return 'Low';
      return 'Low';
    } // Par défaut si non reconnu

    String getCategoryLabel(String key) {
      switch (key) {
        case 'Personal':
          return l10n.personal;
        case 'Work':
          return l10n.work;
        case 'Home':
          return l10n.home;
        case 'Health':
          return l10n.health;
        default:
          return l10n.other;
      }
    }

    String setCategoryLabel(String key) {
      if (key == l10n.personal) return 'Personal';
      if (key == l10n.work) return 'Work';
      if (key == l10n.home) return 'Home';
      if (key == l10n.health) return 'Health';
      if (key == l10n.other) return 'Other';
      return 'Other';
    }

    return AlertDialog(
      title: Text(task == null ? l10n.createTask : l10n.editTask),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: l10n.taskTitle,
                  hintText: l10n.needToBeDone,
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? l10n.titleRequired : null,
                onSaved: (value) => title = value ?? '',
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: l10n.descriptionOptional,
                  hintText: l10n.detailTask,
                ),
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 6),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: getPriorityLabel(priority),
                      items: [l10n.low, l10n.medium, l10n.high]
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              ))
                          .toList(),
                      onChanged: (value) => priority = value!,
                      decoration: InputDecoration(labelText: l10n.priority),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: getCategoryLabel(category),
                      items: categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (value) => category = value!,
                      decoration: InputDecoration(labelText: l10n.category),
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
                    decoration: InputDecoration(
                      labelText: l10n.dueDate,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dueDate.value == null
                              ? l10n.selectDate
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
          child: Text(l10n.cancel,
              style: const TextStyle(
                color: Colors.blue,
              )),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              Navigator.pop(
                context,
                Task(
                    id: task?.id,
                    title: title,
                    description: description,
                    category: setCategoryLabel(category),
                    priority: setPriorityLabel(priority),
                    dueDate: dueDate.value,
                    isCompleted: task?.isCompleted ?? false.obs),
              );
            }
          },
          child: Text(
            task == null ? l10n.createTask : l10n.editTask,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
