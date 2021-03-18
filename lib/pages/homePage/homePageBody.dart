import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:engage/widgets/itemCard.dart';

import 'package:engage/pages/homePage/homePage.dart' as homePage;

import 'package:engage/widgets/rowList.dart';

double itemCardWidth = ScreenUtil.instance.setWidth(420.0);
double itemCardHeight = ScreenUtil.instance.setHeight(230.0);

/*List<Widget> rowListItems = [
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://mir-s3-cdn-cf.behance.net/projects/404/f7632e33201771.Y3JvcCw1NjQsNDQxLDIsNDM.jpg",
        "Porthos",
        "Restaurant & Pub",
        DateTime.now(),
        325.00,
        20,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://media-cdn.tripadvisor.com/media/photo-s/0f/a9/5e/75/baq-burger-house.jpg",
        "BAQ Burger House",
        "Restaurant",
        DateTime.now(),
        250.00,
        15,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://urbancomunicacion.com/wp-content/uploads/2017/04/Mcdonaldslogo-urban-comunicacion-845x684.png",
        "McDonald's",
        "Restaurant",
        DateTime.now(),
        420.00,
        50,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://urbancomunicacion.com/wp-content/uploads/2018/05/Curiosa-historia-del-logo-de-Dominos-Pizza.png",
        "Domino's Pizza",
        "Restaurant",
        DateTime.now(),
        300.00,
        45,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://ccplazacentral.com/wp-content/uploads/2018/02/Plantilla-Logo-Web.006.jpeg",
        "Bogotá Beer Company",
        "Pub",
        DateTime.now(),
        180.00,
        30,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://cdn-az.allevents.in/banners/156cf74fc0ea50c2f9887787f96d4dcd",
        "Díscolo",
        "Disco",
        DateTime.now(),
        200.00,
        25,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "http://www.latroja.org/wp-content/uploads/2014/10/10322441_255704017950226_8281760482427040850_n.jpg",
        "La Troja",
        "Disco",
        DateTime.now(),
        150.00,
        20,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "http://www.periodicoelpunto.com/wp-content/uploads/2017/08/La-Fabrica.jpg",
        "La Fabrica",
        "Disco",
        DateTime.now(),
        300.00,
        10,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://campanariopopayan.com/wp-content/uploads/2018/09/logo-zero-gravity.png",
        "Zero Gravity",
        "Kids Place",
        DateTime.now(),
        100.00,
        10,
        itemCardWidth,
        itemCardHeight),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ItemCard(
        "https://www.guiamultimedia.com.co/Media/532/ban.jpg",
        "TuCandela Bar",
        "Disco",
        DateTime.now(),
        1000.00,
        75,
        itemCardWidth,
        itemCardHeight),
  ),
];*/

class HomePageBody extends StatefulWidget {
  final List<Widget> tabViewItems = homePage.productsByCategory
      .map(
        (e) => Column(
          children: e
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ItemCard(e, itemCardWidth, itemCardHeight),
                ),
              )
              .toList(),
        ),
      )
      .toList();

  HomePageBody();

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: widget.tabViewItems.map(
        (item) {
          return SafeArea(
            top: false,
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () {
                setState(() {});
                return Future.delayed(Duration(milliseconds: 1500));
              },
              child: CustomScrollView(
                key: PageStorageKey<Widget>(item),
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return item;
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
