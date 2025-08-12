import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_manager/views/widgets/language_switcher.dart';

import '../controllers/base.controller.dart';
import '../model/task.model.dart';
import '../utils.dart';
import 'add_task.dialog.dart';
import 'base_stateless.view.dart';

class TaskView extends BaseStatelessView<BaseController> {
  final TextEditingController searchController = TextEditingController();

  TaskView({Key? key}) : super(key: key, controller: Get.put(BaseController()));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: _showAddTaskDialog,
                ),
              ),
            ),
            LanguageSwitcher()
          ],
        ),
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                _buildProgressSection(),
                const SizedBox(height: 16),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(flex: 2, child: _buildSearchTask()),
                    Flexible(
                        flex: 1,
                        child: controller.completedCount.value == 0
                            ? const SizedBox.shrink()
                            : _buildClearCompletedButton())
                  ],
                ),
                const SizedBox(height: 8),
                _buildStatusFilter(),
                const SizedBox(height: 8),
                _buildCategoryFilter(),
                const Divider(),
                Flexible(fit: FlexFit.loose, child: _buildTaskList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final l10n = AppLocalizations.of(Get.context!)!;
    int completed = controller.completedCount.value;
    int total = controller.totalTasks.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progress,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          '$completed/$total ${AppLocalizations.of(Get.context!)!.completed}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    final l10n = AppLocalizations.of(Get.context!)!;
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = [(l10n.all), (l10n.active), (l10n.completed)][index];
          return ChoiceChip(
            label: Text(status),
            selectedColor: Colors.black12,
            selected: controller.selectedStatus.value == status,
            onSelected: (selected) => {
              if (selected)
                {
                  controller.selectedStatus.value = status,
                }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final l10n = AppLocalizations.of(Get.context!)!;
    var mainCategories = [
      l10n.allCategories,
      l10n.personal,
      l10n.work,
      l10n.home,
      l10n.health,
      l10n.other
    ];

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mainCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = mainCategories[index];
                return ChoiceChip(
                  label: Text(category),
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: controller.selectedCategory.value == category
                        ? Colors.white
                        : Colors.black,
                  ),
                  selected: controller.selectedCategory.value == category,
                  onSelected: (selected) =>
                      controller.selectedCategory.value = category,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          //_buildNewTaskButton(),
          //const SizedBox(width: 8),
          //_buildClearCompletedButton(),
        ],
      ),
    );
  }

  Widget _buildClearCompletedButton() {
    return TextButton(
      onPressed: () async {
        Get.defaultDialog(
          title: AppLocalizations.of(Get.context!)!.deleteTask,
          middleText: AppLocalizations.of(Get.context!)!.deleteCompletedTasks,
          confirm: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(Get.context!).primaryColor),
            ),
            onPressed: () {
              controller.clearCompletedTasks;
              Get.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
          cancel: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(AppLocalizations.of(Get.context!)!.cancel,
                style: const TextStyle(
                  color: Colors.blue,
                )),
          ),
        );
      },
      child: Text(
        AppLocalizations.of(Get.context!)!.clearCompleted,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  /*Widget _buildTaskList() {
    final tasks = controller.combinedFilteredTasks;

    if (tasks.isEmpty) {
      return _buildEmptyState();
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
                label: AppLocalizations.of(Get.context!)!.edit,
              ),
              SlidableAction(
                onPressed: (_) async {
                  Get.defaultDialog(
                    title: AppLocalizations.of(Get.context!)!.deleteTask,
                    middleText:
                        AppLocalizations.of(Get.context!)!.confirmDelete,
                    confirm: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        controller.deleteTask(task.id!);
                        Get.back();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    cancel: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(AppLocalizations.of(Get.context!)!.cancel,
                          style: const TextStyle(
                            color: Colors.blue,
                          )),
                    ),
                  );
                  //controller.deleteTask(task.id!);
                },
                icon: Icons.delete,
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.withOpacity(0.1),
                label: AppLocalizations.of(Get.context!)!.delete,
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
                color: task.isCompleted.value
                    ? Colors.grey[100]
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: task.isCompleted.value ? Colors.grey : Colors.blue,
                    width: 0.5),
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
                          Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
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
                              const SizedBox(width: 10),
                              _buildPriorityChip(
                                  task.priority, task.isCompleted.value),
                              const SizedBox(width: 10),
                              _buildCategoryChip(
                                  task.category, task.isCompleted.value),
                              const SizedBox(width: 4),
                              task.dueDate != null
                                  ? Text(
                                      task.dueDate!.toFormattedString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          decoration: task.isCompleted.value
                                              ? TextDecoration.lineThrough
                                              : null),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          if (task.description.isNotEmpty)
                            Text(
                              task.description,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: task.isCompleted.value
                                      ? TextDecoration.lineThrough
                                      : null),
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
  }*/

  Widget _buildTaskList() {
    final tasks = controller.combinedFilteredTasks;

    if (tasks.isEmpty) {
      return _buildEmptyState();
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
                label: AppLocalizations.of(Get.context!)!.edit,
              ),
              SlidableAction(
                onPressed: (_) async {
                  Get.defaultDialog(
                    title: AppLocalizations.of(Get.context!)!.deleteTask,
                    middleText:
                        AppLocalizations.of(Get.context!)!.confirmDelete,
                    confirm: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        controller.deleteTask(task.id!);
                        Get.back();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    cancel: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(AppLocalizations.of(Get.context!)!.cancel,
                          style: const TextStyle(
                            color: Colors.blue,
                          )),
                    ),
                  );
                },
                icon: Icons.delete,
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.withOpacity(0.1),
                label: AppLocalizations.of(Get.context!)!.delete,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
                  task.isCompleted.value ? Colors.grey[100] : Colors.blue[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: task.isCompleted.value ? Colors.grey : Colors.blue,
                  width: 0.5),
            ),
            child: ExpansionTile(
              shape: const Border(),
              clipBehavior: Clip.none,
              leading: GestureDetector(
                onTap: () {
                  task.isCompleted.toggle();
                  controller.updateTaskCounts();
                  controller.updateTask(task);
                },
                child: task.isCompleted.value
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : const Icon(Icons.circle_outlined),
              ),
              title: Text(
                task.title,
                style: task.isCompleted.value
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                      )
                    : const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
              ),
              children: [
                if (task.description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      task.description,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          decoration: task.isCompleted.value
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildPriorityChip(task.priority, task.isCompleted.value),
                      const SizedBox(width: 8),
                      _buildCategoryChip(task.category, task.isCompleted.value),
                      const SizedBox(width: 8),
                      if (task.dueDate != null)
                        Text(
                          task.dueDate!.toFormattedString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: task.isCompleted.value
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(Get.context!)!.noTaskFound,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(Get.context!)!.changeFilter,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddTaskDialog,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(Get.context!)!.createTask),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority, bool isCompleted) {
    final l10n = AppLocalizations.of(Get.context!);

    String getPriorityLabel(String key) {
      switch (key) {
        case 'High':
          return l10n!.high;
        case 'Medium':
          return l10n!.medium;
        case 'Low':
          return l10n!.low;
        default:
          return l10n!.low; // Default to low if not recognized
      }
    }

    Color getPriorityColor(String key) {
      switch (key) {
        case 'High':
          return Colors.red;
        case 'Medium':
          return Colors.orange;
        default:
          return Colors.green;
      }
    }

    return Chip(
      label: Text(getPriorityLabel(priority)),
      padding: EdgeInsets.zero,
      backgroundColor: isCompleted
          ? Colors.grey[90]
          : getPriorityColor(priority).withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(
          color: isCompleted ? Colors.grey : getPriorityColor(priority),
          decoration: isCompleted ? TextDecoration.lineThrough : null),
    );
  }

  Widget _buildCategoryChip(String category, bool isCompleted) {
    final l10n = AppLocalizations.of(Get.context!);

    // Traduction de la clé en texte localisé
    String getCategoryLabel(String key) {
      switch (key) {
        case 'Personal':
          return l10n!.personal;
        case 'Work':
          return l10n!.work;
        case 'Home':
          return l10n!.home;
        case 'Health':
          return l10n!.health;
        default:
          return l10n!.other;
      }
    }

    // Couleur selon la clé
    Color getCategoryColor(String key) {
      switch (key) {
        case 'Personal':
          return Colors.purple;
        case 'Work':
          return Colors.blue;
        case 'Home':
          return Colors.green;
        case 'Health':
          return Colors.red;
        case 'Other':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Chip(
      label: Text(getCategoryLabel(category)),
      padding: EdgeInsets.zero,
      backgroundColor: isCompleted
          ? Colors.grey[90]
          : getCategoryColor(category).withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(
          color: isCompleted ? Colors.grey : getCategoryColor(category),
          decoration: isCompleted ? TextDecoration.lineThrough : null),
    );
  }

  void _showAddTaskDialog() async {
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

  Widget _buildSearchTask() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: controller.isExpanded.value ? 250 : 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
      ),
      child: Row(
        children: [
          if (!controller.isExpanded.value)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                controller.isExpanded.value = true;
              },
            ),
          if (controller.isExpanded.value)
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.searchValue.value = value;
                  controller.resultSearch();
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(Get.context!)!.search,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          if (controller.isExpanded.value)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller.isExpanded.value = false;
                searchController.clear();
                controller.loadTasks();
              },
            ),
        ],
      ),
    );
  }
}
