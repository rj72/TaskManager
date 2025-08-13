# Modern Task Manager

A modern and intuitive task manager built with Flutter. This app helps users organize their tasks efficiently with a beautiful UI and powerful features.

## Features

- 📝 Create tasks
- 📆 Organize tasks by categories
- 📱 Cross-platform support (Android, iOS)

## Screenshots

![Screenshot 1](assets/screenshots/screenshot1.png)
![Screenshot 2](assets/screenshots/screenshot2.png)

## Installation

1. **Clone the repository**
   ```sh
   git clone https://github.com/yourusername/modern-task-manager.git
   cd modern-task-manager
   ```

2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Run the app**
   ```sh
   flutter run
   ```

## Dependencies

This project uses the following Flutter packages:

- [provider](https://pub.dev/packages/provider) – State management
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) – Local notifications
- [sqflite](https://pub.dev/packages/sqflite) – Local database for task storage
- [intl](https://pub.dev/packages/intl) – Date formatting

## Folder Structure

```
modern-task-manager/
│── lib/
│   ├── main.dart           # Entry point of the application
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   ├── widgets/            # Reusable widgets
│   ├── services/           # Business logic and services
│   ├── providers/          # State management with Provider
│── assets/
│   ├── images/             # App images
│   ├── fonts/              # Custom fonts
│── pubspec.yaml            # Project dependencies
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

🚀 Built with Flutter ❤️
