import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSwitcher extends StatelessWidget {
  final Map<Locale, String> flags = {
    const Locale('fr'): '🇫🇷',
    const Locale('en'): '🇬🇧',
    const Locale('de'): '🇩🇪',
    const Locale('es'): '🇪🇸',
  };

  LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Get.locale,
      items: flags.entries.map((entry) {
        return DropdownMenuItem<Locale>(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
      onChanged: (Locale? locale) {
        if (locale != null) {
          Get.updateLocale(locale);
        }
      },
      underline: Container(),
      //icon: const Icon(Icons.language),
    );
  }
}