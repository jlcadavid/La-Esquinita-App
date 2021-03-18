import 'package:badges/badges.dart';
import 'package:engage/def/themes.dart';
import 'package:flutter/material.dart';
import 'package:engage/def/textSytles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  final String title;

  UserProfilePage(this.title);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CupertinoColors.extraLightBackgroundGray,
      ),
    );
    final _width = ScreenUtil.screenWidthDp;
    final _height = ScreenUtil.screenHeightDp;
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            brightness: Brightness.light,
            iconTheme: IconThemeData(
              color: CupertinoColors.darkBackgroundGray,
            ),
            automaticallyImplyLeading: true,
            forceElevated: innerBoxIsScrolled,
            floating: true,
            snap: true,
            title: Text(
              widget.title,
              style: pageTitleStyle,
            ),
            backgroundColor: CupertinoColors.extraLightBackgroundGray,
            actions: [
              Badge(
                showBadge: app.authService.currentUserData.shoppingCart
                            .cartItems.length >
                        0
                    ? true
                    : false,
                position: BadgePosition.topEnd(
                  top: 2.5,
                  end: 2.5,
                ),
                badgeContent: Text(
                  "${app.authService.currentUserData.shoppingCart.cartItems.length}",
                  style: TextStyle(color: Colors.white),
                ),
                badgeColor: appLightTheme.accentColor,
                animationType: BadgeAnimationType.fade,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/shoppingCartPage",
                    ).then(
                      (value) => BlocProvider.of<ShoppingCartBloc>(context)
                          .add(FetchShoppingCart()),
                    );
                  },
                ),
              ),
            ],
          ),
        ];
      },
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
            "${app.authService.currentUserData.firstName}\n${app.authService.currentUserData.lastName}",
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
              "Información del usuario:",
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
              rowCell(app.authService.currentUserData.userCommerceList.length, 'Esquinitas'),
              rowCell(0, 'Promos Activas'),
              rowCell(0, 'Notificaciones'),
            ],
          ),
          Divider(
            height: _height / 30,
            color: CupertinoColors.darkBackgroundGray,
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 8, right: _width / 8),
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/engageBusinessPage"),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.store, color: Colors.white),
                    SizedBox(
                      width: _width / 30,
                    ),
                    Text('Mis Esquinitas',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
          ),
        ],
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
