import 'package:flutter/foundation.dart';

class AppStatusProvider extends ChangeNotifier {
  bool _offline = false;
  bool _lastActionFailed = false;

  bool get isOffline => _offline;
  bool get lastActionFailed => _lastActionFailed;

  void setOffline(bool value) {
    _offline = value;
    notifyListeners();
  }

  void setLastActionFailed(bool value) {
    _lastActionFailed = value;
    notifyListeners();
  }
}
