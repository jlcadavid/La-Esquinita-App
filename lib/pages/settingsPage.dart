import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key});

  final String title = "Ajustes";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
