import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppReminder {
  final String id;
  final String title;
  final String type;
  final int hour;
  final int minute;
  final bool enabled;

  const AppReminder({
    required this.id,
    required this.title,
    required this.type,
    required this.hour,
    required this.minute,
    this.enabled = true,
  });

  String get timeLabel {
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $suffix';
  }

  AppReminder copyWith({bool? enabled, int? hour, int? minute, String? title}) {
    return AppReminder(
      id: id,
      title: title ?? this.title,
      type: type,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'hour': hour,
        'minute': minute,
        'enabled': enabled,
      };

  factory AppReminder.fromJson(Map<String, dynamic> json) {
    return AppReminder(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

class ReminderProvider extends ChangeNotifier {
  static const _key = 'aurafit_reminders';
  List<AppReminder> _reminders = [
    const AppReminder(
      id: 'r1',
      title: 'Morning workout',
      type: 'Workout',
      hour: 7,
      minute: 0,
    ),
    const AppReminder(
      id: 'r2',
      title: 'Hydration check-in',
      type: 'Hydration',
      hour: 11,
      minute: 0,
    ),
    const AppReminder(
      id: 'r3',
      title: 'Bedtime wind-down',
      type: 'Sleep',
      hour: 22,
      minute: 30,
    ),
  ];
  Future<void>? _init;

  List<AppReminder> get reminders => List.unmodifiable(_reminders);

  Future<void> ensureInitialized() {
    _init ??= _load();
    return _init!;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      _reminders = (jsonDecode(raw) as List)
          .cast<Map<String, dynamic>>()
          .map(AppReminder.fromJson)
          .toList();
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_reminders.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> add(AppReminder reminder) async {
    _reminders = [..._reminders, reminder];
    await _persist();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    _reminders = _reminders
        .map((r) => r.id == id ? r.copyWith(enabled: !r.enabled) : r)
        .toList();
    await _persist();
    notifyListeners();
  }

  Future<void> update(AppReminder reminder) async {
    _reminders =
        _reminders.map((r) => r.id == reminder.id ? reminder : r).toList();
    await _persist();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _reminders = _reminders.where((r) => r.id != id).toList();
    await _persist();
    notifyListeners();
  }
}
