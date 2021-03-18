import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:engage/app/engageApp.dart' as app;
import 'package:transparent_image/transparent_image.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/categoryModel.dart';
import 'package:engage/services/apiClientService.dart';
import 'package:provider/provider.dart';

import 'package:badges/badges.dart';

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TabController _tabController;

var selectedLocationIndex = 0;
var selectedTabIndex = 0;

int currentImageIndex = 0;

double headerHeight = ScreenUtil.instance.setHeight(420.0);

class HomePageHeader extends StatefulWidget {
  final List<String> locations;

  final List<Widget> carouselImages = [
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200338.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/sabados mala mia.png'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200237.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200254.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200310.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200324.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191031_200351.jpeg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG_20191115_035255.png'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/IMG-20190318-WA0011.jpg'),
      fit: BoxFit.cover,
    ),
    FadeInImage(
      placeholder: AssetImage('assets/images/Spinner-1s-200px.gif'),
      image: AssetImage('assets/images/TuCa Kendall 26 de Ene-49.jpg'),
      fit: BoxFit.cover,
    ),
  ];

  final bool innerBoxScrolled;
  final bool isExpanded;

  HomePageHeader(
    this.isExpanded,
    this.locations,
    this.innerBoxScrolled,
  );

  static get headerHeight => 0;

  static set imageIndex(int index) => currentImageIndex = index;

  @override
  _HomePageHeaderState createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  List<Widget> _tabBarItems() {
    return app.categories.map((tab) {
      return Tab(
        text: tab.name,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return SliverAppBar(
      floating: true,
      pinned: true,
      forceElevated: widget.innerBoxScrolled,
      expandedHeight: headerHeight,
      backgroundColor: Colors.black87,
      elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (index) {
            setState(() {
              selectedLocationIndex = index;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.locations[selectedLocationIndex],
                style: dropDownLabelStyle.copyWith(color: Colors.white),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
          itemBuilder: (BuildContext context) => List.generate(
            widget.locations.length,
            (int index) {
              return PopupMenuItem(
                child: Text(
                  widget.locations[index],
                  style: dropDownMenuStyle,
                ),
                value: index,
              );
            },
          ),
        ),
        Badge(
          showBadge:
              app.authService.currentUserData.shoppingCart.cartItems.length > 0
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
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: "titleTag",
          child: Text(
            "La Esquinita",
            style: pageTitleStyle.copyWith(
              color: appLightTheme.primaryColor,
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: 420,
                  color: CupertinoColors.black,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 60.0),
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: FutureBuilder(
                        future:
                            Future.wait([app.apiClientService.fetchCarousel()]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<List<ProductModel>>> snapshot) {
                          if (/*snapshot.connectionState ==
                              ConnectionState.done*/
                              true) {
                            if (/*!snapshot.hasError &&
                                snapshot.hasData &&
                                snapshot.data != null*/
                                true) {
                              return CarouselSlider(
                                initialPage: currentImageIndex,
                                height: ScreenUtil.instance.setHeight(450.0),
                                viewportFraction: 1.0,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 7),
                                pauseAutoPlayOnTouch: Duration(seconds: 5),
                                onPageChanged: (index) {
                                  setState(() {
                                    currentImageIndex = index;
                                  });
                                },
                                items: widget.carouselImages
                                    .map(
                                      (e) => Container(
                                        width: ScreenUtil.screenWidth,
                                        child: e,
                                      ),
                                    )
                                    .toList(),
                                /*snapshot.data
                                    .map(
                                      (product) => Container(
                                        width: ScreenUtil.screenWidth,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              "https://lalorduy.dentotys.com/storage/" +
                                                  product.imageURL,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                    .toList(),*/
                              );
                            } else
                              return Container(
                                color: CupertinoColors.extraLightBackgroundGray,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: appLightTheme.primaryColor,
                                    strokeWidth: 5,
                                  ),
                                ),
                              );
                          } else
                            return Container(
                              color: CupertinoColors.extraLightBackgroundGray,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: appLightTheme.primaryColor,
                                  strokeWidth: 5,
                                ),
                              ),
                            );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 290.0),
                    child: Container(
                      width: ScreenUtil.screenWidth,
                      height: ScreenUtil.instance.setHeight(160.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            CupertinoColors.lightBackgroundGray,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 335.0,
                        bottom: 55.0,
                        left: 40.0,
                        right: 40.0,
                      ),
                      child: Container(
                        width: ScreenUtil.instance.setWidth(450.0),
                        height: ScreenUtil.instance.setHeight(100.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FormBuilderTextField(
                              attribute: 'searchKeyword',
                              style: mainTextFieldStyle,
                              cursorColor: appLightTheme.primaryColor,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 30.0),
                                hintText: "¿Qué deseas?",
                                hintStyle: mainHintTextStyle,
                                suffixIcon: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.search,
                                    color: appLightTheme.accentColor,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  Positioned(
                    top: 385.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.carouselImages.map((i) {
                        int imgIndex = widget.carouselImages.indexOf(i);
                        return Container(
                          width: ScreenUtil.instance.setWidth(
                              currentImageIndex == imgIndex ? 15.0 : 9.0),
                          height: ScreenUtil.instance.setHeight(
                              currentImageIndex == imgIndex ? 5.0 : 3.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 3.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: currentImageIndex == imgIndex
                                  ? appLightTheme.primaryColor
                                  : CupertinoColors.extraLightBackgroundGray),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        tabs: _tabBarItems(),
        isScrollable: true,
        labelStyle: tabBarSelectedItemStyle,
        unselectedLabelStyle: tabBarUnselectecItemStyle,
        controller: _tabController,
      ),
    );
  }
}
