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

import 'package:engage/models/productModel.dart';
import 'package:transparent_image/transparent_image.dart';

import 'productDetailsPage.dart';

double itemCardWidth = ScreenUtil.instance.setWidth(420.0);
double itemCardHeight = ScreenUtil.instance.setHeight(230.0);

List<String> memoriesImages = [
  "assets/images/IMG_20191031_200640.jpeg",
  "assets/images/IMG_20191031_200728.jpeg",
  "assets/images/IMG-20190220-WA0049.jpg",
  "assets/images/IMG-20190314-WA0103.jpg",
  "assets/images/IMG-20190316-WA0137.jpg",
  "assets/images/IMG-20190318-WA0008.jpg",
  "assets/images/IMG-20191114-WA0020.jpg",
  "assets/images/IMG-20191114-WA0022.jpg",
  "assets/images/PicsArt_11-14-02.42.09.jpg",
  "assets/images/Tuca Kendall Sábado 20 de Octubre-35.jpg",
];

class SuggestionsPage extends StatefulWidget {
  String title;

  SuggestionsPage(this.title);

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
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
        future: app.apiClientService
            .fetchSuggestions(app.authService.currentUserData)
            .then((value) => value),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(Duration(milliseconds: 1500));
                },
                child: snapshot.data == null
                    ? Center(
                        child: Text(
                          "Aún no tenemos sugerencias para ti.\n¡Busca lo que más te gusta, vuelve y sorpréndete! 😍✨",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemExtent: 250,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 10.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: CupertinoColors.inactiveGray,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsPage(
                                                  snapshot.data[index]))).then(
                                    (value) =>
                                        BlocProvider.of<ShoppingCartBloc>(
                                                context)
                                            .add(FetchShoppingCart()),
                                  );
                                },
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image:
                                      "https://lalorduy.dentotys.com/storage/" +
                                          snapshot.data[index].imageURL,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
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
                memoriesImages[index],
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
