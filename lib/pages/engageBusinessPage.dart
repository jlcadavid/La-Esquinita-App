import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:engage/pages/commerceDetailsPage.dart';
import 'package:engage/pages/commerceCreationPage.dart';
import 'package:engage/models/commerceModel.dart';

import 'package:provider/provider.dart';

AuthService authService;

List<CommerceModel> userCommerceList;

class EngageBusinessPage extends StatefulWidget {
  EngageBusinessPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EngageBusinessPageState createState() => _EngageBusinessPageState();
}

class _EngageBusinessPageState extends State<EngageBusinessPage> {
  MediaQueryData queryData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: authService.currentUserCommerceList.length == 0
          ? Center(
              child: Text(
                "Aún no posees esquinitas.\n¡Crea una y empieza a ganar!\n💸🤑💸",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 50.0, left: 8.0, right: 8.0),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: authService.currentUserCommerceList.length,
              itemBuilder: (BuildContext context, int index) =>
                  makeCard(authService.currentUserCommerceList[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: CupertinoColors.lightBackgroundGray),
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
                "Añadir Esquinita",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommerceCreationPage(),
                  )).then((value) => setState(() => userCommerceList = value)),
            ),
          ),
        ),
      ),
    );
  }

  Card makeCard(CommerceModel commerce) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(commerce),
        ),
      );

  ListTile makeListTile(CommerceModel commerce) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.store, color: Colors.white),
        ),
        title: Text(
          commerce.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: commerce.commerceRating,
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(commerce.address,
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommerceDetailsPage(commerce)));
        },
      );
}
