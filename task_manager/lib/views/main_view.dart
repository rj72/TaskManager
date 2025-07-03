import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../controllers/base.controller.dart';
import '../model/task.model.dart';
import '../utils.dart';
import 'add_task.dialog.dart';
import 'base_stateless.view.dart';

class MainView extends BaseStatelessView<BaseController> {
  final TextEditingController searchController = TextEditingController();

  MainView({Key? key}) : super(key: key, controller: Get.put(BaseController()));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task Manager',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
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
                const Text('Organize your tasks with ease and elegance',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                _buildProgressSection(),
                const SizedBox(height: 16),
                _buildSearchTask(),
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

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = ['All', 'Active', 'Completed'][index];
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
    const mainCategories = [
      'All Categories',
      'Personal',
      'Work',
      'Home',
      'Health',
      'Other'
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

  Widget _buildNewTaskButton() {
    return GestureDetector(
      onTap: _showAddTaskDialog,
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

  Widget _buildClearCompletedButton() {
    return TextButton(
      onPressed: controller.clearCompletedTasks,
      child: const Text('Clear Completed'),
    );
  }

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
                              _buildPriorityChip(
                                  task.priority, task.isCompleted.value),
                              const SizedBox(width: 12),
                              _buildPriorityChip(
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            onPressed: _showAddTaskDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create New Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority, bool isCompleted) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Chip(
      label: Text(priority),
      padding: EdgeInsets.zero,
      backgroundColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(color: color),
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
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
