import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:engage/def/textSytles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:engage/def/themes.dart';

import 'package:engage/widgets/itemCard.dart';

import 'package:engage/models/productModel.dart';
import 'package:transparent_image/transparent_image.dart';

import 'productDetailsPage.dart';

double itemCardWidth = ScreenUtil.instance.setWidth(420.0);
double itemCardHeight = ScreenUtil.instance.setHeight(230.0);

List<String> dealsImages = [
  "assets/images/IMG_20191031_200237.jpeg",
  "assets/images/IMG_20191031_200310.jpeg",
  "assets/images/IMG_20191031_200324.jpeg",
  "assets/images/IMG_20191031_200338.jpeg",
  "assets/images/IMG-20190318-WA0011.jpg",
  "assets/images/sabados mala mia.png",
];

class DealsPage extends StatefulWidget {
  final String title;

  DealsPage(this.title);

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CupertinoColors.extraLightBackgroundGray,
      ),
    );
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
      body: FutureBuilder(
        future: app.apiClientService.fetchPromotions().then((value) => value),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(Duration(milliseconds: 1500));
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemExtent: 250,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      left: index % 2 == 0 ? 10.0 : 125.0,
                      right: index % 2 != 0 ? 10.0 : 125.0,
                      bottom: 10.0,
                    ),
                    child: ItemCard(
                        snapshot.data[index], itemCardWidth, itemCardHeight),
                    /*ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        color: CupertinoColors.inactiveGray,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        snapshot.data[index])));
                          },
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: "https://lalorduy.dentotys.com/storage/" +
                                snapshot.data[index].imageURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),*/
                  ),
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
      ),
    );
  }

  _openImage(context, index) async {
    showDialog(
      context: context,
      builder: (a) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.black54,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(
                dealsImages[index],
              ),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
/*     showDialog(
      context: context,
      builder: (a) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.black54,
        content: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: "https://picsum.photos/id/$index/512",
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    ); */
  }
}
