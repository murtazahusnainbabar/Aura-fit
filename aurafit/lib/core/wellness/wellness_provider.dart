import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WellnessProvider extends ChangeNotifier {
  static const _waterKey = 'aurafit_water';
  static const _sleepKey = 'aurafit_sleep';
  static const _weightKey = 'aurafit_weight';
  static const _moodKey = 'aurafit_mood';

  double _waterLiters = 1.8;
  double _sleepHours = 7.2;
  double _weightKg = 74.2;
  String _mood = 'Energized';
  final List<String> _meals = ['Oats & berries', 'Grilled chicken bowl'];
  Future<void>? _init;

  double get waterLiters => _waterLiters;
  double get sleepHours => _sleepHours;
  double get weightKg => _weightKg;
  String get mood => _mood;
  List<String> get meals => List.unmodifiable(_meals);

  Future<void> ensureInitialized() {
    _init ??= _load();
    return _init!;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _waterLiters = prefs.getDouble(_waterKey) ?? 1.8;
    _sleepHours = prefs.getDouble(_sleepKey) ?? 7.2;
    _weightKg = prefs.getDouble(_weightKey) ?? 74.2;
    _mood = prefs.getString(_moodKey) ?? 'Energized';
    notifyListeners();
  }

  Future<void> addWater(double liters) async {
    _waterLiters = (_waterLiters + liters).clamp(0, 6);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_waterKey, _waterLiters);
    notifyListeners();
  }

  Future<void> setSleep(double hours) async {
    _sleepHours = hours.clamp(0, 14);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sleepKey, _sleepHours);
    notifyListeners();
  }

  Future<void> setWeight(double kg) async {
    _weightKg = kg;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_weightKey, kg);
    notifyListeners();
  }

  Future<void> setMood(String mood) async {
    _mood = mood;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_moodKey, mood);
    notifyListeners();
  }

  void addMeal(String meal) {
    if (meal.trim().isEmpty) return;
    _meals.insert(0, meal.trim());
    notifyListeners();
  }
}
