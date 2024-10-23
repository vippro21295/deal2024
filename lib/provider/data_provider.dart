import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CountAlert extends ChangeNotifier{
  int _countAlert = 0;
  int get count => _countAlert;

  void updateCount(int newValue) {
    _countAlert = newValue;
    notifyListeners(); // Thông báo các màn hình khác
  }
}
