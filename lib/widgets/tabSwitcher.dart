import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

int _currentIndex = 0;
bool _isSelected;

class TabSwitcher extends StatefulWidget {
  final List<String> tabs;
  int tabIndex;

  TabSwitcher({@required this.tabs, this.tabIndex});

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  List<Widget> _buildTabs() {
    return widget.tabs.map((tab) {
      var index = widget.tabs.indexOf(tab);
      _isSelected = _currentIndex == index;
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _currentIndex = widget.tabIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                tab,
                style: TextStyle(
                  color: _isSelected ? Colors.red : Colors.blueGrey,
                  fontSize: _isSelected ? 28 : 16,
                  fontFamily: "Oxygen",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        flex: 0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      child: Row(
        children: _buildTabs(),
      ),
    );
  }
}
