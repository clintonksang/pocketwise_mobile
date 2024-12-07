import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  String? _selectedValue;

  String? get selectedValue => _selectedValue;

  void setSelectedValue(String? newValue) {
    _selectedValue = newValue;
    notifyListeners();  
  }
}
