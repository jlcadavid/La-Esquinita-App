import 'package:flutter/material.dart';

class MainFloatingActionButton extends StatefulWidget {
  bool isVisible;

  MainFloatingActionButton(this.isVisible);

  @override
  _MainFloatingActionButtonState createState() =>
      _MainFloatingActionButtonState();
}

class _MainFloatingActionButtonState extends State<MainFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.search,
          color: Colors.red,
        ),
        backgroundColor: Colors.white,
      ),
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
    );
  }
}
