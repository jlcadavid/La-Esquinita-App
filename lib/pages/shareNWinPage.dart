import 'package:engage/def/themes.dart';
import 'package:flutter/material.dart';
import 'package:engage/def/textSytles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_string/random_string.dart';

class ShareNWinPage extends StatefulWidget {
  ShareNWinPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShareNWinPageState createState() => _ShareNWinPageState();
}

class _ShareNWinPageState extends State<ShareNWinPage> {
  @override
  Widget build(BuildContext context) {
    final _width = ScreenUtil.screenWidthDp;
    final _height = ScreenUtil.screenHeightDp;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: _height / 12,
          ),
          CircleAvatar(
            radius: _width < _height ? _width / 4 : _height / 4,
            child: Icon(
              Icons.account_circle,
              size: 200.0,
            ),
            backgroundColor: Colors.black,
          ),
          SizedBox(
            height: _height / 25.0,
          ),
          Text(
            "${randomAlphaNumeric(10)}".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _width / 15,
              color: CupertinoColors.darkBackgroundGray,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _height / 30, left: _width / 8, right: _width / 8),
            child: Text(
              "¡Comparte tu código de referido y recibe múltiples beneficios con Mi Esquinita!",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: _width / 25,
                color: CupertinoColors.darkBackgroundGray,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: _height / 30,
            color: CupertinoColors.darkBackgroundGray,
          ),
          Row(
            children: <Widget>[
              rowCell(5, 'Referidos'),
              rowCell(20, 'Compartido'),
            ],
          ),
          Divider(
            height: _height / 30,
            color: CupertinoColors.darkBackgroundGray,
          ),
        ],
      ),
      bottomSheet: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: CupertinoColors.lightBackgroundGray,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: FloatingActionButton.extended(
              label: Text(
                "Compartir",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget rowCell(int count, String type) => new Expanded(
        child: new Column(
          children: <Widget>[
            new Text(
              '$count',
              style: new TextStyle(
                color: CupertinoColors.darkBackgroundGray,
              ),
            ),
            new Text(type,
                style: new TextStyle(
                    color: CupertinoColors.darkBackgroundGray,
                    fontWeight: FontWeight.normal))
          ],
        ),
      );
}
