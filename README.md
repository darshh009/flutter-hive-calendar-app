# Flutter Hive Calendar App 📅

A Flutter-based **Calendar Events App** using Hive for local storage.  
This app allows users to **add, view, search, and manage events** with support for event descriptions and file uploads — all stored offline using Hive.

## ✨ Features

- 📅 Calendar UI for browsing events  
- ➕ Add events with:
  - 🏷️ Event title
  - 📝 Description
  - 📁 File upload (e.g. PDF, image)
- 🔍 Search for events by keyword  
- 🏠 View all events on the home screen  
- 📱 Offline data storage using Hive  
- 🧹 Clean architecture and modular code structure  

## 🛠️ Tech Stack

| Tech               | Description                                      |
|--------------------|--------------------------------------------------|
| Flutter            | Cross-platform UI framework                      |
| Dart               | Language used for Flutter                        |
| Hive               | Lightweight, NoSQL database for local storage    |
| hive_flutter       | Flutter integration for Hive                     |
| Flutter Widgets    | For building responsive and intuitive UI         |
| Clean Architecture | Separation of concerns for scalability and maintenance |

## 📸 Screenshots

### Home Screen
![Home Screen](assets/home_screen.png)

### Add Event Screen
![Add Event Screen](assets/add_event.png)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio/VSCode with Flutter plugin

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/flutter-hive-calendar-app.git

'Install dependencies:

bash
flutter pub get
Run the app:

bash
flutter run

🏗️ Project Structure
lib/
├── core/              # Core functionalities
├── data/              # Data layer (Hive models, repositories)
├── domain/            # Business logic
├── presentation/      # UI layer (screens, widgets)
└── main.dart          # App entry point

📝 License
This project is licensed under the MIT License. See the LICENSE file for details.

📬 Contact
For questions or feedback, please contact:
Email: darshhwork@gmail.com
```
