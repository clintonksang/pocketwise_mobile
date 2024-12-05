import 'package:flutter/foundation.dart';

class CategoryProvider extends ChangeNotifier {
  String _selectedCategory = 'needs';  
  String get selectedCategory => _selectedCategory;

  void updateCategory(String newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();  
  }
}
