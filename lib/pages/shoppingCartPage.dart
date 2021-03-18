import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/shoppingCartModel.dart';
import 'package:engage/models/couponModel.dart';

import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:engage/pages/productDetailsPage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

double totalValue = 0;

ShoppingCartModel userShoppingCart;

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return FutureBuilder(
      future: Future.wait([
        app.apiClientService.fetchShoppingCart(app.authService.currentUserData)
      ]).then<ShoppingCartModel>((value) => value.first),
      builder:
          (BuildContext context, AsyncSnapshot<ShoppingCartModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            userShoppingCart = snapshot.data;
            totalValue = 0;
            userShoppingCart.cartItems.forEach((element) {
              totalValue += element.price *
                  ((100 - element.cartProducts.first.discount) / 100) *
                  element.quantity;
            });
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(widget.title),
                actions: [
                  Visibility(
                    visible:
                        userShoppingCart.cartItems.length > 0 ? true : false,
                    child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Alert(
                              context: _scaffoldKey.currentContext,
                              type: AlertType.warning,
                              title: "¿Deseas eliminar tu carrito?",
                              desc: "Si aceptas, tu carrito quedará vacío. 😞",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Eliminar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    app.authService.currentUserData
                                            .userShoppingCart =
                                        await app.apiClientService
                                            .deleteShoppingCart(
                                                app.authService.currentUserData)
                                            .then((value) => value);
                                    setState(() {});
                                    return Navigator.pop(
                                        _scaffoldKey.currentContext);
                                  },
                                  color: CupertinoColors.destructiveRed,
                                ),
                                DialogButton(
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(
                                      _scaffoldKey.currentContext),
                                  color: CupertinoColors.inactiveGray,
                                ),
                              ],
                            ).show();
                          },
                          child: Icon(Icons.delete),
                        )),
                  ),
                ],
              ),
              body: userShoppingCart.cartItems.length == 0
                  ? Center(
                      child: Text(
                        "No hay elementos en tu carrito. 🛒\n¡Agrega algunos y los verás aquí!",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: userShoppingCart.cartItems.length,
                      itemBuilder: (context, index) => Hero(
                        tag: "opShoppingCart#$index",
                        child: ListTile(
                          leading: SizedBox(
                            width: 70,
                            height: 70,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: "https://lalorduy.dentotys.com/storage/" +
                                  userShoppingCart.cartItems[index].cartProducts
                                      .first.imageURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(userShoppingCart.cartItems[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "Cantidad: ${userShoppingCart.cartItems[index].quantity}"),
                          trailing: Text(
                              "${NumberFormat.simpleCurrency().format(userShoppingCart.cartItems[index].price * ((100 - userShoppingCart.cartItems[index].cartProducts.first.discount) / 100) * userShoppingCart.cartItems[index].quantity)}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          isThreeLine: true,
                          onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                          snapshot.data.cartItems[index]
                                              .cartProducts.first)))
                              .then((value) => setState(() {})),
                          onLongPress: () => Alert(
                            context: _scaffoldKey.currentContext,
                            type: AlertType.warning,
                            title: "¿Deseas eliminar el elemento del carrito?",
                            desc:
                                "Si aceptas, tendrás que volver a agregar el producto.",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  app.authService.currentUserData
                                          .userShoppingCart =
                                      await app.apiClientService
                                          .deleteProductFromShoppingCart(
                                              app.authService.currentUserData,
                                              userShoppingCart.cartItems[index])
                                          .then((value) => value);
                                  setState(() {});
                                  return Navigator.pop(
                                      _scaffoldKey.currentContext);
                                },
                                color: CupertinoColors.destructiveRed,
                              ),
                              DialogButton(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () =>
                                    Navigator.pop(_scaffoldKey.currentContext),
                                color: CupertinoColors.inactiveGray,
                              ),
                            ],
                          ).show(),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(color: CupertinoColors.inactiveGray),
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
                    leading: Text(
                      "Total:",
                      style: mainTextFieldStyle.copyWith(
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    title: Text(
                      "${NumberFormat.simpleCurrency().format(totalValue)}",
                      style: mainTextFieldStyle,
                      textAlign: TextAlign.end,
                    ),
                    trailing: FloatingActionButton.extended(
                      label: Text(
                        "¡Comprar!",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      onPressed: () => userShoppingCart.cartItems.isEmpty ||
                              userShoppingCart == null
                          ? Fluttertoast.showToast(
                              msg: "No hay elementos en tu carrito.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor:
                                  CupertinoColors.darkBackgroundGray,
                              textColor: Colors.white,
                              fontSize: 16.0)
                          : Alert(
                              context: context,
                              title: "¿Deseas usar un cupón? 💖",
                              content: FutureBuilder(
                                future: app.apiClientService
                                    .fetchCoupons(
                                        app.authService.currentUserData)
                                    .then((value) => value),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<CouponModel>> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      return Column(
                                        children: snapshot.data.length > 0 &&
                                                snapshot.data != null
                                            ? snapshot.data
                                                .map(
                                                  (e) => ListTile(
                                                    leading:
                                                        Icon(Icons.loyalty),
                                                    title: Text(e.name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    subtitle: Text(
                                                      "Valor mínimo: ${NumberFormat.simpleCurrency().format(e.minShopping)}",
                                                    ),
                                                    trailing: Text(
                                                      "${NumberFormat.simpleCurrency().format(e.value)}",
                                                    ),
                                                    tileColor:
                                                        Colors.transparent,
                                                    isThreeLine: true,
                                                    onTap: () async {
                                                      Navigator.pop(_scaffoldKey
                                                          .currentContext);
                                                      bool couponValidity =
                                                          await app
                                                              .apiClientService
                                                              .validateCoupon(
                                                                app.authService
                                                                    .currentUserData,
                                                                e,
                                                              )
                                                              .then((value) =>
                                                                  value)
                                                              .catchError(
                                                                  (e, s) =>
                                                                      false);
                                                      if (couponValidity) {
                                                        bool orderCheck =
                                                            await app
                                                                .apiClientService
                                                                .createOrder(
                                                                  app.authService
                                                                      .currentUserData,
                                                                  userShoppingCart,
                                                                  appliedCoupon:
                                                                      e,
                                                                )
                                                                .then((value) =>
                                                                    value)
                                                                .catchError(
                                                                    (e, s) =>
                                                                        false);
                                                        if (orderCheck) {
                                                          Alert(
                                                            context: _scaffoldKey
                                                                .currentContext,
                                                            type: AlertType
                                                                .success,
                                                            title:
                                                                "¡Tu orden ha sido creada!.",
                                                            desc:
                                                                "¡Felicidades, tu orden fué aceptada! 🤗\nPronto podrás disfrutar de tus productos.",
                                                            buttons: [
                                                              DialogButton(
                                                                color: appLightTheme
                                                                    .accentColor,
                                                                child: Text(
                                                                  "Gracias",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      _scaffoldKey
                                                                          .currentContext);
                                                                  Navigator.popAndPushNamed(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      '/shareNWinPage');
                                                                },
                                                              ),
                                                            ],
                                                          ).show();
                                                        } else {
                                                          Alert(
                                                            context: _scaffoldKey
                                                                .currentContext,
                                                            type:
                                                                AlertType.error,
                                                            title:
                                                                "¡Lo sentimos!.",
                                                            desc:
                                                                "Hubo un error con tu orden. 😓\nEspera un poco e intenta nuevamente.",
                                                            buttons: [
                                                              DialogButton(
                                                                child: Text(
                                                                  "Esta bien",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                color: CupertinoColors
                                                                    .inactiveGray,
                                                              ),
                                                            ],
                                                          ).show();
                                                        }
                                                      } else {
                                                        Alert(
                                                          context: _scaffoldKey
                                                              .currentContext,
                                                          type: AlertType.error,
                                                          title:
                                                              "Tu cupón no fué aceptado.",
                                                          desc:
                                                              "Lo sentimos, tu cupón no fué aceptado. 😤\nVerifica los requerimientos e intenta de nuevo.",
                                                          buttons: [
                                                            DialogButton(
                                                              child: Text(
                                                                "Esta bien",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              color: CupertinoColors
                                                                  .inactiveGray,
                                                            ),
                                                          ],
                                                        ).show();
                                                      }
                                                    },
                                                  ),
                                                )
                                                .toList()
                                            : Center(
                                                child: Text(
                                                  'De momento no posees cupones activos.',
                                                ),
                                              ),
                                      );
                                      break;

                                    case ConnectionState.waiting:
                                      return CircularProgressIndicator(
                                        backgroundColor:
                                            appLightTheme.primaryColor,
                                        strokeWidth: 5,
                                      );
                                      break;

                                    default:
                                      if (snapshot.hasError)
                                        return new Text(
                                            'Error: ${snapshot.error}');
                                      else
                                        return new Text(
                                            'Result: ${snapshot.data}');
                                      break;
                                  }
                                },
                              ),
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Seguir sin cupón",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    bool orderCheck = await app.apiClientService
                                        .createOrder(
                                          app.authService.currentUserData,
                                          userShoppingCart,
                                        )
                                        .then((value) => value)
                                        .catchError((e, s) => false);
                                    if (orderCheck) {
                                      Alert(
                                        context: _scaffoldKey.currentContext,
                                        type: AlertType.success,
                                        title: "¡Tu orden ha sido creada!.",
                                        desc:
                                            "¡Felicidades, tu orden fué aceptada! 🤗\nPronto podrás disfrutar de tus productos.",
                                        buttons: [
                                          DialogButton(
                                            color: appLightTheme.accentColor,
                                            child: Text(
                                              "Gracias",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(
                                                  _scaffoldKey.currentContext);
                                              Navigator.popAndPushNamed(
                                                  _scaffoldKey.currentContext,
                                                  '/shareNWinPage');
                                            },
                                          ),
                                        ],
                                      ).show();
                                    } else {
                                      Alert(
                                        context: _scaffoldKey.currentContext,
                                        type: AlertType.error,
                                        title: "¡Lo sentimos!.",
                                        desc:
                                            "Hubo un error con tu orden. 😓\nEspera un poco e intenta nuevamente.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Esta bien",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: CupertinoColors.inactiveGray,
                                          ),
                                        ],
                                      ).show();
                                    }
                                  },
                                  color: appLightTheme.accentColor,
                                ),
                              ],
                            ).show(),
                    ),
                  ),
                ),
              ),
            );

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
