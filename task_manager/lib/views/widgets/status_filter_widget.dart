import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/base.controller.dart';

Widget buildStatusFilter() {
  final controller = Get.find<BaseController>();
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
