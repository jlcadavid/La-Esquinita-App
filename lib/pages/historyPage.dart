import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

int historyItemsCount = 0;

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.title});

  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: historyItemsCount == 0
          ? Center(
              child: Text(
                "No hay elementos en tu historial.\n¡Realiza algunas compras y las encontrarás aquí!",
                textAlign: TextAlign.center,
              ),
            )
          : FutureBuilder(
              builder: (context, snapshot) => Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: historyItemsCount,
                  itemBuilder: (BuildContext context, int index) => Hero(
                    tag: "historyItem#$index",
                    child: ListTile(title: snapshot.data),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                ),
              ),
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
                "¿Necesitas ayuda?",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.help,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
