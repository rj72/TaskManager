import 'package:get/get.dart';
import 'package:task_manager/data/database_helper.dart';

import '../model/task.model.dart';

class BaseController extends GetxController {
  var tasks = <Task>[].obs;
  var selectedStatus = 'All'.obs;
  var selectedCategory = 'All Categories'.obs;
  var completedCount = 0.obs;
  var totalTasks = 0.obs;
  var isExpanded = false.obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final List<String> categories = [
    'All categories',
    'Personal',
    'Work',
    'Home',
    'Health',
    'Other',
  ];

  @override
  onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks.value = await _dbHelper.getTasks();
    updateTaskCounts();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    loadTasks();
  }

  RxList<Task> get combinedFilteredTasks {
    var filteredTasks = tasks;

    // Filter by status
    switch (selectedStatus.value) {
      case 'Active':
        filteredTasks =
            filteredTasks.where((task) => !task.isCompleted.value).toList().obs;
        break;
      case 'Completed':
        filteredTasks =
            filteredTasks.where((task) => task.isCompleted.value).toList().obs;
        break;
      default:
        break;
    }

    // Filter by category
    switch (selectedCategory.value) {
      case 'All Categories':
        return filteredTasks;
      case 'Personal':
        return filteredTasks
            .where((task) => task.category == 'Personal')
            .toList()
            .obs;
      case 'Work':
        return filteredTasks
            .where((task) => task.category == 'Work')
            .toList()
            .obs;
      case 'Home':
        return filteredTasks
            .where((task) => task.category == 'Home')
            .toList()
            .obs;
      case 'Health':
        return filteredTasks
            .where((task) => task.category == 'Health')
            .toList()
            .obs;
      case 'Other':
        return filteredTasks
            .where((task) => task.category == 'Other')
            .toList()
            .obs;
      default:
        return filteredTasks;
    }
  }

  void clearCompletedTasks() async {
    await _dbHelper.deleteCompletedTasks();
    loadTasks();
  }

  void updateTaskCounts() {
    completedCount.value = tasks.where((t) => t.isCompleted.value).length;
    totalTasks.value = tasks.length;
  }
}
