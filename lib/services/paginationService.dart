import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaginationService with ChangeNotifier {

  PaginationService(this.bottomNavBarPages);

  List bottomNavBarPages;

  int _currentIndex = 0;
  Widget _currentPage;

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  get currentIndex => _currentIndex;

  get currentPage => _currentPage == null ? bottomNavBarPages.elementAt(_currentIndex) : _currentPage;

  set currentIndex(int index) {
    _currentIndex = index;
    _currentPage = bottomNavBarPages.elementAt(_currentIndex);
    notifyListeners();
  }
}