# Dravida - Learn Kannada App

Dravida is a mobile application designed to teach Kannada language through an interactive learning experience. Built with Flutter for the frontend and Strapi for content management, this app offers a structured approach to learning Kannada alphabets and more.

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


color codes - 
/* CSS HEX */
--berkeley-blue: #003366ff;
--bone: #e0ddcfff;
--isabelline: #f1f0eaff;
--feldgrau: #627264ff;
--pumpkin: #fe7f2dff;

test@test.com
test123

supabase postgres

firebase deployment of webapp - 
https://dravida-99dda.web.app/
flutter build web
firebase deploy --only "hosting"

https://soundoftext.com/