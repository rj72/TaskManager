import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base.controller.dart';

Widget _buildClearCompletedButton() {
  final controller = Get.find<BaseController>();
  return FilledButton(
    onPressed: controller.clearCompletedTasks,
    child: const Text('Clear Completed'),
  );
}