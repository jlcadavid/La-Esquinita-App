import 'package:engage/pages/homePage/homePageBody.dart';
import 'package:engage/pages/homePage/homePageHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:engage/def/themes.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/categoryModel.dart';

import 'package:engage/app/engageApp.dart' as app;

List<Future<List<ProductModel>>> futureProducts;

List<List<ProductModel>> productsByCategory;

bool _isButtonVisible;

double _minHeaderHeight = 150.0;

class HomePage extends StatefulWidget {
  final List<String> locations;

  HomePage(this.locations);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    futureProducts = app.categories
        .map<Future<List<ProductModel>>>(
          (e) => app.apiClientService.fetchProducts(e.id, null),
        )
        .toList();
    super.initState();
    //print(futureProducts);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return FutureBuilder(
      future: Future.wait(futureProducts).then((value) => value),
      builder: (BuildContext context,
          AsyncSnapshot<List<List<ProductModel>>> snapshot) {
        productsByCategory = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return DefaultTabController(
              length: app.categories.length,
              child: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    HomePageHeader(
                      _isButtonVisible,
                      widget.locations,
                      innerBoxIsScrolled,
                    ),
                  ];
                },
                body: HomePageBody(),
              ),
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
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text('Result: ${snapshot.data}');
        }
      },
    );
  }
}
