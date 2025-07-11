import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base.controller.dart';

class SearchTaskWidget extends StatefulWidget {
  const SearchTaskWidget({Key? key}) : super(key: key);

  @override
  State<SearchTaskWidget> createState() => _SearchTaskWidgetState();
}

class _SearchTaskWidgetState extends State<SearchTaskWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaseController>();
    final searchController = TextEditingController();
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