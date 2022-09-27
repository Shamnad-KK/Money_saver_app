import 'package:flutter/foundation.dart';

class BottomNavController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
