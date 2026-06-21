<h1 align="center">
  <br>
  BMI Tracker (Pro)
  <br>
</h1>

<h4 align="center">A premium, beautifully designed cross-platform BMI calculator and health tracking app built with Flutter.</h4>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#technologies">Technologies</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#license">License</a>
</p>

---

## ✨ Features

- **🎯 Advanced BMI Calculation:** Calculate your Body Mass Index precisely using either Metric or Imperial units.
- **📊 Interactive History & Analytics:** View your past entries plotted beautifully on an analytics dashboard. Watch your progress over time!
- **💡 Dynamic Health Insights:** Receive personalized health tips that automatically adjust based on your current BMI category.
- **🏆 Goal Setting:** Set a target weight. The analytics screen will show a visual progress bar indicating exactly how much weight you need to lose or gain to hit your goal.
- **🔔 Daily Reminders:** Never forget to log your weight! Enable local push notifications to remind you at 10:00 AM every day.
- **📄 Data Export (PDF & CSV):** Generate a clean, tabular PDF report or a CSV file of your entire BMI history and export it instantly.
- **📲 Seamless Sharing:** Share your calculated BMI and category directly to social media, WhatsApp, or SMS via the native share sheet.
- **🌙 Premium Dark Theme:** A sleek, modern dark mode interface with smooth micro-animations, glowing gradients, and glassmorphism elements.

---

## 📱 Screenshots

*(Add your awesome screenshots here!)*

| Home Screen | Analytics Dashboard | Settings & Export |
| :---: | :---: | :---: |
| <img src="assets/screenshots/home.png" width="250"/> | <img src="assets/screenshots/analytics.png" width="250"/> | <img src="assets/screenshots/settings.png" width="250"/> |

---

## 🛠 Technologies & Packages

This app is built with [Flutter](https://flutter.dev/) and relies on some fantastic open-source packages:

- **State Management:** `provider`
- **Local Storage:** `hive` & `hive_flutter`
- **Notifications:** `flutter_local_notifications` & `timezone`
- **Data Export:** `pdf`, `printing`, `path_provider`, `csv`
- **Sharing:** `share_plus`
- **Analytics:** `firebase_analytics` & `firebase_core`
- **UI Elements:** `fl_chart` (charts), `syncfusion_flutter_gauges` (visual gauges), `confetti` (celebration animations)

---

## 🚀 Getting Started

To run this project locally, follow these steps:

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- Android Studio or VS Code with Flutter extensions installed.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Vishal0247/BMI-Tracker.git
   cd BMI-Tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration (Important!):**
   Since the original Firebase configuration files (`google-services.json` and `firebase_options.dart`) are hidden for security reasons, you will need to set up your own Firebase project to use Firebase Analytics.
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new project and register your Android/iOS apps.
   - Run the FlutterFire CLI to generate your own `firebase_options.dart`:
     ```bash
     flutterfire configure
     ```

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📜 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---
<p align="center">
  <i>Crafted with ❤️ for health and fitness.</i>
</p>
