import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bmi_record.dart';
import '../services/notification_service.dart';

class AppStateProvider extends ChangeNotifier {
  Box<BMIRecord>? _bmiBox;
  Box? _settingsBox;
  bool _isDarkMode = true;
  String _unitSystem = 'metric'; // 'metric' or 'imperial'
  double? _targetWeight;
  bool _isReminderEnabled = false;

  bool get isDarkMode => _isDarkMode;
  String get unitSystem => _unitSystem;
  double? get targetWeight => _targetWeight;
  bool get isReminderEnabled => _isReminderEnabled;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(BMIRecordAdapter());
      }
      _bmiBox = await Hive.openBox<BMIRecord>('bmi_records');
      _settingsBox = await Hive.openBox('settings');
      _isDarkMode = _settingsBox!.get('isDarkMode', defaultValue: true);
      _unitSystem = _settingsBox!.get('unitSystem', defaultValue: 'metric');
      _targetWeight = _settingsBox!.get('targetWeight');
      _isReminderEnabled = _settingsBox!.get('isReminderEnabled', defaultValue: false);
      
      if (_isReminderEnabled) {
        NotificationService().scheduleDailyReminder();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing app state: $e');
      _isDarkMode = true;
      _unitSystem = 'metric';
      _isReminderEnabled = false;
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _settingsBox?.put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setUnitSystem(String system) {
    _unitSystem = system;
    _settingsBox?.put('unitSystem', _unitSystem);
    notifyListeners();
  }

  void setTargetWeight(double? weight) {
    _targetWeight = weight;
    if (weight != null) {
      _settingsBox?.put('targetWeight', weight);
    } else {
      _settingsBox?.delete('targetWeight');
    }
    notifyListeners();
  }

  void toggleReminder() {
    _isReminderEnabled = !_isReminderEnabled;
    _settingsBox?.put('isReminderEnabled', _isReminderEnabled);
    
    if (_isReminderEnabled) {
      NotificationService().scheduleDailyReminder();
    } else {
      NotificationService().cancelReminder();
    }
    notifyListeners();
  }

  void addBMIRecord(BMIRecord record) {
    _bmiBox?.add(record);
    notifyListeners();
  }

  List<BMIRecord> getAllRecords() {
    if (_bmiBox == null) return [];
    return _bmiBox!.values.toList().reversed.toList();
  }

  void deleteRecord(int index) {
    _bmiBox?.deleteAt(index);
    notifyListeners();
  }

  void clearAllRecords() {
    _bmiBox?.clear();
    notifyListeners();
  }

  double? getAverageBMI() {
    final records = getAllRecords();
    if (records.isEmpty) return null;
    final sum = records.fold<double>(0, (prev, current) => prev + current.bmi);
    return sum / records.length;
  }

  BMIRecord? getLatestRecord() {
    final records = getAllRecords();
    return records.isNotEmpty ? records.first : null;
  }

  List<BMIRecord> getRecordsByCategory(String category) {
    return getAllRecords().where((record) => record.category == category).toList();
  }

  List<BMIRecord> getWeeklyRecords() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    return getAllRecords()
        .where((record) => record.dateTime.isAfter(weekAgo))
        .toList();
  }

  List<BMIRecord> getMonthlyRecords() {
    final now = DateTime.now();
    final monthAgo = now.subtract(Duration(days: 30));
    return getAllRecords()
        .where((record) => record.dateTime.isAfter(monthAgo))
        .toList();
  }
}
