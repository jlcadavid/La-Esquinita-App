import 'package:badges/badges.dart';
import 'package:engage/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:engage/def/textSytles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:engage/pages/productDetailsPage.dart';

import 'package:engage/def/themes.dart';

import 'package:engage/services/APIClientService.dart';

import 'package:provider/provider.dart';

int selectedGridIndex = 3;

List<String> gridOps = [
  "2",
  "3",
  "4",
];

List<String> exploreImages = [
  "assets/images/DB DJI_0899.jpg",
  "assets/images/IMG_20191031_200640.jpeg",
  "assets/images/IMG_20191031_200728.jpeg",
  "assets/images/IMG-20190220-WA0048.jpg",
  "assets/images/IMG-20190220-WA0049.jpg",
  "assets/images/IMG-20190314-WA0068.jpg",
  "assets/images/IMG-20190314-WA0069.jpg",
  "assets/images/IMG-20190314-WA0070.jpg",
  "assets/images/IMG-20190314-WA0103.jpg",
  "assets/images/IMG-20190314-WA0113.jpg",
  "assets/images/IMG-20190314-WA0114.jpg",
  "assets/images/IMG-20190316-WA0067.jpg",
  "assets/images/IMG-20190316-WA0118.jpg",
  "assets/images/IMG-20190316-WA0121.jpg",
  "assets/images/IMG-20190316-WA0122.jpg",
  "assets/images/IMG-20190316-WA0123.jpg",
  "assets/images/IMG-20190316-WA0124.jpg",
  "assets/images/IMG-20190316-WA0125.jpg",
  "assets/images/IMG-20190316-WA0126.jpg",
  "assets/images/IMG-20190316-WA0127.jpg",
  "assets/images/IMG-20190316-WA0129.jpg",
  "assets/images/IMG-20190316-WA0134.jpg",
  "assets/images/IMG-20190316-WA0135.jpg",
  "assets/images/IMG-20190316-WA0137.jpg",
  "assets/images/IMG-20190318-WA0008.jpg",
  "assets/images/IMG-20191016-WA0023.jpg",
  "assets/images/IMG-20191016-WA0024.jpg",
  "assets/images/IMG-20191114-WA0009.jpg",
  "assets/images/IMG-20191114-WA0010.jpg",
  "assets/images/IMG-20191114-WA0011.jpg",
  "assets/images/IMG-20191114-WA0012.jpg",
  "assets/images/IMG-20191114-WA0013.jpg",
  "assets/images/IMG-20191114-WA0014.jpg",
  "assets/images/IMG-20191114-WA0015.jpg",
  "assets/images/IMG-20191114-WA0016.jpg",
  "assets/images/IMG-20191114-WA0017.jpg",
  "assets/images/IMG-20191114-WA0018.jpg",
  "assets/images/IMG-20191114-WA0019.jpg",
  "assets/images/IMG-20191114-WA0020.jpg",
  "assets/images/IMG-20191114-WA0021.jpg",
  "assets/images/IMG-20191114-WA0022.jpg",
  "assets/images/IMG-20191114-WA0023.jpg",
  "assets/images/IMG-20191114-WA0024.jpg",
  "assets/images/IMG-20191114-WA0025.jpg",
  "assets/images/IMG-20191114-WA0026.jpg",
  "assets/images/IMG-20191114-WA0027.jpg",
  "assets/images/IMG-20191114-WA0028.jpg",
  "assets/images/PicsArt_10-25-03.38.44.jpg",
  "assets/images/PicsArt_11-14-02.42.09.jpg",
  "assets/images/Screen Shot 2017-11-18 at 12.29.52 PM.png",
  "assets/images/TuCa Kendall 26 de Ene-49.jpg",
  "assets/images/TuCa Kendall Sábado 19 de Enero-15.jpg",
  "assets/images/Tuca Kendall Sábado 20 de Octubre-28.jpg",
  "assets/images/Tuca Kendall Sábado 20 de Octubre-35.jpg",
];

class ExplorePage extends StatefulWidget {
  final String title;

  ExplorePage(this.title);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (index) {
                  setState(() {
                    selectedGridIndex = index + 2;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Columns: " + gridOps[selectedGridIndex - 2],
                        style: dropDownLabelStyle),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => List.generate(
                  gridOps.length,
                  (int index) {
                    return PopupMenuItem(
                      child: Text(
                        gridOps[index],
                        style: dropDownMenuStyle,
                      ),
                      value: index,
                    );
                  },
                ),
              ),
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
            backgroundColor: CupertinoColors.extraLightBackgroundGray,
          ),
        ];
      },
      body: FutureBuilder(
        future: app.apiClientService.fetchExplore().catchError((e, s) =>
            Fluttertoast.showToast(
                msg: "No fue posible cargar el explorar. Error: $e",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: CupertinoColors.darkBackgroundGray,
                textColor: Colors.white,
                fontSize: 16.0)),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(Duration(milliseconds: 1500));
                },
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: selectedGridIndex,
                  children: snapshot.data
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
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
                                              ProductDetailsPage(e))).then(
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
                                          e.imageURL,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
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

  _openImage(BuildContext context, ProductModel product) async {
    showDialog(
      context: context,
      builder: (a) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.black54,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: FadeInImage.memoryNetwork(
                image:
                    "https://lalorduy.dentotys.com/storage/" + product.imageURL,
                placeholder: kTransparentImage,
              ).image,
              fit: BoxFit.cover,
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
  }
}
