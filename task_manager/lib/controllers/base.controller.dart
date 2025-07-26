import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  var searchValue = ''.obs;

  final List<String> categories = [];

  @override
  onInit() {
    super.onInit();
    loadTasks();
  }

  List<String> getTranslatedCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.personal,
      l10n.work,
      l10n.home,
      l10n.health,
      l10n.other,
    ];
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
    final l10n = AppLocalizations.of(Get.context!);

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
        case 'Other':
          return l10n!.other;
        default:
          return l10n!.allCategories;
      }
    }

    var filteredTasks = tasks;

    // Filter by status
    switch (selectedStatus.value) {
      case var v when v == l10n?.active:
        filteredTasks =
            filteredTasks.where((task) => !task.isCompleted.value).toList().obs;
        break;
      case var v when v == l10n?.completed:
        filteredTasks =
            filteredTasks.where((task) => task.isCompleted.value).toList().obs;
        break;
      default:
        break;
    }

    // Filter by category
    switch (getCategoryLabel(selectedCategory.value)) {
      case var v when v == l10n?.allCategories:
        return filteredTasks;
      case var v when v == l10n?.personal:
        return filteredTasks
            .where((task) => task.category == l10n?.personal)
            .toList()
            .obs;
      case var v when v == l10n?.work:
        return filteredTasks
            .where((task) => task.category == l10n?.work)
            .toList()
            .obs;
      case var v when v == l10n?.home:
        return filteredTasks
            .where((task) => task.category == l10n?.home)
            .toList()
            .obs;
      case var v when v == l10n?.health:
        return filteredTasks
            .where((task) => task.category == l10n?.health)
            .toList()
            .obs;
      case var v when v == l10n?.other:
        return filteredTasks
            .where((task) => task.category == l10n?.other)
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

  void resultSearch() {
    if (searchValue.value.isEmpty) {
      loadTasks(); // Recharge toutes les tâches si la recherche est vide
    } else {
      tasks.value = tasks
          .where((task) =>
              task.title
                  .toLowerCase()
                  .contains(searchValue.value.toLowerCase()) ||
              task.description
                  .toLowerCase()
                  .contains(searchValue.value.toLowerCase()))
          .toList();
    }
  }
}
