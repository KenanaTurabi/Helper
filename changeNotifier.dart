import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PageControllerProvider extends ChangeNotifier {
  late PageController _pageController;

  PageControllerProvider() {
    _pageController = PageController(initialPage: 0);
  }

  PageController get pageController => _pageController;

  void setPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    notifyListeners();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
