import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:engage/pages/productCreationPage.dart';

import 'package:engage/widgets/itemCard.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/commerceModel.dart';
import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';

import 'package:engage/services/authService.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:math';

AuthService authService;

Random rnd;

double itemCardWidth = ScreenUtil.instance.setWidth(420.0);
double itemCardHeight = ScreenUtil.instance.setHeight(230.0);

dynamic backgroundImages = [
  "assets/images/fondo1.jpg",
  "assets/images/fondo2.jpg",
  "assets/images/fondo3.jpg",
];

class CommerceDetailsPage extends StatelessWidget {
  final CommerceModel commerce;
  CommerceDetailsPage(this.commerce, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    rnd = new Random();
    int min = 0;
    int max = backgroundImages.length - 1;

    int r = min + rnd.nextInt(max - min);

    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: commerce.rating,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final commercePremium = Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        commerce.isPremium == 1 ? "Esquinita Premium 🌟" : "Esquinita Basic",
        style: TextStyle(
            color: Colors.white,
            fontWeight:
                commerce.isPremium == 1 ? FontWeight.bold : FontWeight.normal),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 50.0),
        Icon(
          Icons.store,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 150.0,
          child: new Divider(
            color: Colors.green,
            thickness: 1.5,
          ),
        ),
        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      commerce.address,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            Expanded(flex: 1, child: commercePremium)
          ],
        ),
      ],
    );

    final topContent = FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        commerce.title,
        style: pageTitleStyle.copyWith(
            fontSize: 20, color: CupertinoColors.extraLightBackgroundGray),
      ),
      background: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(backgroundImages[r].toString()),
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.all(40.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .8)),
            child: Center(
              child: topContentText,
            ),
          ),
        ],
      ),
    );

    final bottomContentText = Text(
      commerce.description,
      style: TextStyle(fontSize: 18.0),
    );

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("COMPRA AQUÍ!", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = ListView(
      padding: EdgeInsets.all(25.0),
      children: <Widget>[bottomContentText, readButton],
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) =>
            <Widget>[
          SliverAppBar(
            primary: true,
            pinned: true,
            forceElevated: innerBoxScrolled,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: topContent,
          ),
        ],
        body: FutureBuilder(
          future: Future.wait([
            app.apiClientService.fetchProducts(null, commerce.commerceID)
          ]).then((value) => value.first),
          builder: (BuildContext context,
              AsyncSnapshot<List<ProductModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return snapshot.data.length == 0
                    ? Center(
                        child: Text(
                          "Aún no hay productos en esta Esquinita.\n¡Regresa pronto y sorpréndete! 😲",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Column(
                          children: snapshot.data
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 20.0,
                                  ),
                                  child: ItemCard(
                                      e, itemCardWidth, itemCardHeight),
                                ),
                              )
                              .toList(),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: CupertinoColors.lightBackgroundGray),
                      );
                break;
              case ConnectionState.waiting:
                return Container(
                  color: CupertinoColors.extraLightBackgroundGray,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: appLightTheme.primaryColor,
                      strokeWidth: 5,
                    ),
                  ),
                );
                break;
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new Text('Result: ${snapshot.data}');
            }
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: authService.currentUserData.userID == commerce.ownerID,
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductCreationPage(commerce),
              )).then((value) => null),
          label:
              Text("Agregar Productos", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
  }
}
