import 'package:intl/intl.dart';

import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/models/productModel.dart';
import 'package:engage/models/shoppingCartModel.dart';
import 'package:engage/models/couponModel.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

int couponItemsCount = 0;

class CouponsPage extends StatefulWidget {
  CouponsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
              future: app.apiClientService
                  .fetchCoupons(app.authService.currentUserData)
                  .then((value) => value),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CouponModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Column(
                      children:
                          snapshot.data.length > 0 && snapshot.data != null
                              ? snapshot.data
                                  .map(
                                    (e) => ListTile(
                                      leading: Icon(Icons.loyalty),
                                      title: Text(e.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        "Valor mínimo de compra: ${NumberFormat.simpleCurrency().format(e.minShopping)}",
                                      ),
                                      trailing: Text(
                                        "Valor: ${NumberFormat.simpleCurrency().format(e.value)}",
                                      ),
                                      tileColor: Colors.transparent,
                                      isThreeLine: true,
                                      onTap: () {},
                                    ),
                                  )
                                  .toList()
                              : Center(
                                  child: Text(
                                    'De momento no posees cupones activos.\nVuelve pronto y descubre todo lo que tenemos para ti. 💗',
                                  ),
                                ),
                    );
                    break;

                  case ConnectionState.waiting:
                    return CircularProgressIndicator(
                      backgroundColor: appLightTheme.primaryColor,
                      strokeWidth: 5,
                    );
                    break;

                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return new Text('Result: ${snapshot.data}');
                    break;
                }
              },
            ),
    );
  }
}
