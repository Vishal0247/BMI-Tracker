# 🏋️ BMI Tracker Pro
 
A beautifully crafted, feature-rich BMI calculator and personal health tracking app built with Flutter. Designed to look great, feel smooth, and actually help you stay on top of your fitness journey. 💪
 
---
 
## 🤔 Why BMI Tracker Pro?
 
Most BMI apps do one thing — calculate a number and leave you with nothing. BMI Tracker Pro goes further. It tracks your history, visualizes your progress, sends you reminders, and even lets you export your data as a PDF or CSV. It's everything you'd want in a health companion, wrapped in a sleek dark UI with smooth animations.
 
---
 
## ✨ Features
 
**🎯 Accurate BMI Calculation**
Supports both Metric and Imperial units, so you can enter your height and weight however you're comfortable.
 
**📊 Progress History & Analytics Dashboard**
Every entry you log is saved and plotted on an interactive chart. You can actually see how your BMI has changed over days or weeks — not just a static number.
 
**💡 Personalized Health Insights**
Based on your current BMI category, the app shows you relevant health tips that change dynamically. It's contextual, not generic.
 
**🏆 Goal Setting**
Set a target weight and the app will show you a visual progress bar telling you exactly how far you are from your goal. Simple, motivating, and clear.
 
**🔔 Daily Reminders**
An optional daily notification at 10:00 AM reminds you to log your weight. Consistency is key, and this helps you build the habit.
 
**📄 PDF & CSV Export**
Generate a clean tabular report of your full BMI history and export it as a PDF or CSV file — useful if you want to share it with a doctor or keep records offline.
 
**📲 Native Sharing**
Share your BMI result and category directly to WhatsApp, Instagram, SMS, or anywhere else via the native share sheet.
 
**🌙 Premium Dark UI**
The entire app follows a dark theme with glassmorphism cards, glowing gradients, and micro-animations. It feels polished — because it is.
 
---
 
## 📱 Screenshots
 
| Home Screen | Analytics Dashboard | Settings & Export |
|:-----------:|:-------------------:|:-----------------:|
| <img src="WhatsApp Image 2026-06-21 at 3.06.22 PM.jpeg" width="250"/> | <img src="WhatsApp Image 2026-06-21 at 3.06.23 PM (2).jpeg" width="250"/> | <img src="WhatsApp Image 2026-06-21 at 3.06.24 PM.jpeg" width="250"/> |
 
 
---
 
## 🛠️ Tech Stack
 
Built with **Flutter** — the same codebase runs on Android and iOS.
 
| Category | Package |
|---|---|
| State Management | `provider` |
| Local Storage | `hive`, `hive_flutter` |
| Notifications | `flutter_local_notifications`, `timezone` |
| PDF & CSV Export | `pdf`, `printing`, `path_provider`, `csv` |
| Sharing | `share_plus` |
| Analytics | `firebase_analytics`, `firebase_core` |
| Charts | `fl_chart` |
| Gauges | `syncfusion_flutter_gauges` |
| Animations | `confetti` |
 
---
 
## 🗂️ Project Structure
 
```
lib/
├── main.dart               # App entry point
├── models/                 # Data models (BMI entry, user settings)
├── screens/                # Home, Analytics, Settings screens
├── widgets/                # Reusable UI components
├── services/               # Notifications, export, storage logic
└── providers/              # State management via Provider
```
 
---
 
## 🤝 Contributing
 
Got a feature idea or found a bug? Feel free to open an issue or submit a pull request. All contributions are welcome! 🙌
 
1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Commit your changes (`git commit -m 'Add: your feature'`)
4. Push to the branch (`git push origin feature/your-feature-name`)
5. Open a Pull Request
---
 
## 📜 License
 
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) — free to use, modify, and distribute.
 
---
 
<p align="center">Built with ❤️ by <a href="https://github.com/Vishal0247">Vishal</a> · Crafted for health, designed for humans. 🌟</p>
