# Dravida - Learn Kannada App

Dravida is a mobile application designed to teach Kannada language through an interactive learning experience. Built with Flutter for the frontend and Strapi for content management, this app offers a structured approach to learning Kannada alphabets and more.

## 🌟 Features

- **Modular Learning Path**: Organized into modules, levels, and content items for progressive learning
- **Interactive Content Types**: Various learning activities including letter cards, multiple-choice questions, and more
- **Progress Tracking**: Keep track of your learning journey
- **User Authentication**: Secure login and registration system
- **Responsive Design**: Works on various Android devices

## 📱 App Structure

The app follows a hierarchical structure:
- **Modules**: Main categories (e.g., Kannada Alphabets)
- **Levels**: Sub-categories within modules (e.g., groups of 4-5 letters)
- **Content Items**: Learning materials within levels (e.g., letter cards, MCQs)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Node.js (for Strapi CMS)
- Git

### Installation

#### Frontend (Flutter)

1. Clone the repository:
```bash
git clone https://github.com/yathish1618/dravida.git
cd dravida
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

#### Backend (Strapi CMS)

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Start the Strapi server:
```bash
npm run develop
```

## 🧩 Project Structure

lib/
├── main.dart                         # Entry point of the Flutter app
├── models/                           # Data models for your app
│   ├── content_item.dart
│   ├── item_model.dart
│   ├── letter_card_item.dart
│   ├── level_model.dart
│   ├── mcq_question_item.dart
│   ├── module_model.dart
│   └── unknown_item.dart
├── screens/                          # Screens for different pages
│   ├── home_screen.dart
│   ├── level_screen.dart
│   ├── main_layout.dart
│   └── module_screen.dart
├── services/                         # Services for API calls
│   └── api_service.dart
├── theme/                            # Theming and styles
│   └── app_theme.dart
├── widgets/                          # Reusable UI components
│   ├── app_bottom_navigation_bar.dart
│   ├── app_header.dart
│   ├── letter_card.dart
│   ├── level_list.dart
│   ├── mcq_question_widget.dart
│   └── module_list.dart
