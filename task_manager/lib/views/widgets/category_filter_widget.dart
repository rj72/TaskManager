import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/base.controller.dart';

Widget buildCategoryFilter() {
  const mainCategories = [
    'All Categories',
    'Personal',
    'Work',
    'Home',
    'Health',
    'Other'
  ];

  final controller = Get.find<BaseController>();

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