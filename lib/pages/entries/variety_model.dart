import 'package:flutter/material.dart';

class VarietyModel extends ChangeNotifier {
  final Map<String, int> _varietyValue = {};

  int getValue(String variety) {
    return _varietyValue[variety] ?? 0;
  }

  void updateValue(String variety, int value) {
    _varietyValue[variety] = value;
    notifyListeners();
  }

  void deleteMap() {
    _varietyValue.clear();
    notifyListeners();
  }

  Map<String, int> getMap() {
    return _varietyValue;
  }
}
