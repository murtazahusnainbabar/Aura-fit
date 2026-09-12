import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProfile {
  final int age;
  final String gender;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String fitnessLevel;
  final String goal;
  final List<String> equipment;

  const OnboardingProfile({
    this.age = 28,
    this.gender = '',
    this.heightCm = 175,
    this.weightKg = 75,
    this.targetWeightKg = 72,
    this.fitnessLevel = '',
    this.goal = '',
    this.equipment = const [],
  });

  OnboardingProfile copyWith({
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    String? fitnessLevel,
    String? goal,
    List<String>? equipment,
  }) {
    return OnboardingProfile(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goal: goal ?? this.goal,
      equipment: equipment ?? this.equipment,
    );
  }

  Map<String, dynamic> toJson() => {
        'age': age,
        'gender': gender,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'fitnessLevel': fitnessLevel,
        'goal': goal,
        'equipment': equipment,
      };

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    return OnboardingProfile(
      age: json['age'] as int? ?? 28,
      gender: json['gender'] as String? ?? '',
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 75,
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 72,
      fitnessLevel: json['fitnessLevel'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      equipment: (json['equipment'] as List?)?.cast<String>() ?? const [],
    );
  }
}

class OnboardingProvider extends ChangeNotifier {
  static const _key = 'aurafit_onboarding';
  static const _completeKey = 'aurafit_onboarding_complete';
  static const _welcomeSeenKey = 'aurafit_welcome_seen';
  static const _permissionsKey = 'aurafit_permissions';
  static const _biometricKey = 'aurafit_biometric_enabled';

  OnboardingProfile _profile = const OnboardingProfile();
  bool _complete = false;
  bool _welcomeSeen = false;
  bool _notifications = false;
  bool _health = false;
  bool _camera = false;
  bool _microphone = false;
  bool _biometricUnlock = false;
  Future<void>? _init;

  OnboardingProfile get profile => _profile;
  bool get isComplete => _complete;
  bool get hasSeenWelcome => _welcomeSeen;
  bool get notificationsGranted => _notifications;
  bool get healthGranted => _health;
  bool get cameraGranted => _camera;
  bool get microphoneGranted => _microphone;
  bool get biometricUnlockEnabled => _biometricUnlock;

  Future<void> ensureInitialized() {
    _init ??= _load();
    return _init!;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      _profile = OnboardingProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    }
    _complete = prefs.getBool(_completeKey) ?? false;
    _welcomeSeen = prefs.getBool(_welcomeSeenKey) ?? false;
    final perm = prefs.getString(_permissionsKey);
    if (perm != null) {
      final map = jsonDecode(perm) as Map<String, dynamic>;
      _notifications = map['notifications'] == true;
      _health = map['health'] == true;
      _camera = map['camera'] == true;
      _microphone = map['microphone'] == true;
    }
    _biometricUnlock = prefs.getBool(_biometricKey) ?? false;
    notifyListeners();
  }

  Future<void> updateProfile(OnboardingProfile profile) async {
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<void> setPermission({
    bool? notifications,
    bool? health,
    bool? camera,
    bool? microphone,
  }) async {
    _notifications = notifications ?? _notifications;
    _health = health ?? _health;
    _camera = camera ?? _camera;
    _microphone = microphone ?? _microphone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _permissionsKey,
      jsonEncode({
        'notifications': _notifications,
        'health': _health,
        'camera': _camera,
        'microphone': _microphone,
      }),
    );
    notifyListeners();
  }

  Future<void> setBiometricUnlock(bool enabled) async {
    _biometricUnlock = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _complete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completeKey, true);
    notifyListeners();
  }

  Future<void> setSeenWelcome() async {
    _welcomeSeen = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_welcomeSeenKey, true);
    notifyListeners();
  }

  Future<void> resetForNewUser() async {
    _complete = false;
    _welcomeSeen = false;
    _profile = const OnboardingProfile();
    _notifications = false;
    _health = false;
    _camera = false;
    _microphone = false;
    _biometricUnlock = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.setBool(_completeKey, false);
    await prefs.setBool(_welcomeSeenKey, false);
    await prefs.remove(_permissionsKey);
    await prefs.setBool(_biometricKey, false);
    notifyListeners();
  }
}
