import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../controllers/base.controller.dart';
import 'base_stateless.view.dart';
import 'task_view.dart';

class MainScaffold extends BaseStatelessView<BaseController> {
  MainScaffold({Key? key})
      : super(key: key, controller: Get.put(BaseController()));

  List<Widget> _pages(AppLocalizations l10n) {
    return [
      TaskView(),
      Center(
          child: Text('${l10n.page} 2', style: const TextStyle(fontSize: 24))),
      Center(
          child: Text('${l10n.page} 3', style: const TextStyle(fontSize: 24))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pages(l10n);
    return Obx(() => Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.blue,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.list),
                label: l10n.task,
                selectedIcon: const Icon(Icons.list, color: Colors.white),
              ),
              NavigationDestination(
                icon: const Icon(Icons.check_circle),
                label: '${l10n.page} 2',
                selectedIcon:
                    const Icon(Icons.check_circle, color: Colors.white),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings),
                label: '${l10n.page} 3',
                selectedIcon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
