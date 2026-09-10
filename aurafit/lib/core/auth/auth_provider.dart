import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String id;
  final String name;
  final String email;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
  });

  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? name : parts.first;
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return 'AF';
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters;
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'aurafit_users';
  static const _sessionKey = 'aurafit_session_email';

  static const demoEmail = 'alex@aurafit.app';
  static const demoPassword = 'AuraFit123!';

  bool _ready = false;
  AuthUser? _user;
  final Map<String, _StoredAccount> _accounts = {};
  final Map<String, _ResetChallenge> _resetCodes = {};
  Future<void>? _initFuture;

  bool get isReady => _ready;
  bool get isLoggedIn => _user != null;
  AuthUser? get user => _user;

  Future<void> ensureInitialized() {
    _initFuture ??= _initialize();
    return _initFuture!;
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        final account = _StoredAccount.fromJson(item);
        _accounts[account.email] = account;
      }
    }
    if (!_accounts.containsKey(demoEmail)) {
      _accounts[demoEmail] = _StoredAccount(
        id: 'u1',
        name: 'Alex Chen',
        email: demoEmail,
        password: demoPassword,
      );
      await _persistUsers(prefs);
    }

    final sessionEmail = prefs.getString(_sessionKey);
    if (sessionEmail != null && _accounts.containsKey(sessionEmail)) {
      _user = _accounts[sessionEmail]!.toUser();
    }

    _ready = true;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final key = _normalizeEmail(email);
    final account = _accounts[key];
    if (account == null || account.password != password) {
      throw const AuthException('Email or password is incorrect.');
    }
    _user = account.toUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, key);
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final key = _normalizeEmail(email);
    if (_accounts.containsKey(key)) {
      throw const AuthException(
        'An account with this email already exists. Try signing in.',
      );
    }
    final account = _StoredAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: key,
      password: password,
    );
    _accounts[key] = account;
    final prefs = await SharedPreferences.getInstance();
    await _persistUsers(prefs);
    _user = account.toUser();
    await prefs.setString(_sessionKey, key);
    notifyListeners();
  }

  Future<void> sendResetCode(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final key = _normalizeEmail(email);
    if (!_accounts.containsKey(key)) {
      throw const AuthException('We couldn\'t find an account with that email.');
    }
    final code = '123456';
    _resetCodes[key] = _ResetChallenge(
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  String? peekDemoResetCode(String email) {
    return _resetCodes[_normalizeEmail(email)]?.code;
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _requireValidCode(email, code);
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final key = _normalizeEmail(email);
    _requireValidCode(email, code);
    final account = _accounts[key];
    if (account == null) {
      throw const AuthException('We couldn\'t find an account with that email.');
    }
    _accounts[key] = account.copyWith(password: newPassword);
    _resetCodes.remove(key);
    final prefs = await SharedPreferences.getInstance();
    await _persistUsers(prefs);
  }

  Future<void> loginWithSocial(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    await login(email: demoEmail, password: demoPassword);
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }

  void _requireValidCode(String email, String code) {
    final key = _normalizeEmail(email);
    final challenge = _resetCodes[key];
    if (challenge == null) {
      throw const AuthException('Request a new code and try again.');
    }
    if (DateTime.now().isAfter(challenge.expiresAt)) {
      _resetCodes.remove(key);
      throw const AuthException('That code expired. Request a new one.');
    }
    if (challenge.code != code.trim()) {
      throw const AuthException('That code doesn\'t match. Check it and try again.');
    }
  }

  Future<void> _persistUsers(SharedPreferences prefs) async {
    final list = _accounts.values.map((a) => a.toJson()).toList();
    await prefs.setString(_usersKey, jsonEncode(list));
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();
}

class _StoredAccount {
  final String id;
  final String name;
  final String email;
  final String password;

  const _StoredAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  AuthUser toUser() => AuthUser(id: id, name: name, email: email);

  _StoredAccount copyWith({String? password}) {
    return _StoredAccount(
      id: id,
      name: name,
      email: email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };

  factory _StoredAccount.fromJson(Map<String, dynamic> json) {
    return _StoredAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}

class _ResetChallenge {
  final String code;
  final DateTime expiresAt;

  const _ResetChallenge({required this.code, required this.expiresAt});
}
