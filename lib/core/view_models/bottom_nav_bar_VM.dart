import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomNavBarVM extends ChangeNotifier {

  int _currentPageIndex = 0;
  int _homePageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  int get homePageIndex => _homePageIndex;

  bool _isVisible = true;
  bool get isVisible => _isVisible;

  PageController homePageViewController = PageController();

  List<Widget> get screens => const [
    Scaffold(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
  ];

  List<Widget> get homePageScreens => const [
    Scaffold(),
  ];

  void updateCurrentPageIndex(int page){
    _currentPageIndex = page;
    notifyListeners();
  }

  void updateNavBarVisibility(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  void onHomePageChange(int index) {
    _homePageIndex = index;
    notifyListeners();
  }

  void animateToIndex(int pageIndex) {
    homePageViewController.animateToPage(pageIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _homePageIndex = pageIndex;
    notifyListeners();
  }

}
