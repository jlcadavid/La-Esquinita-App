import 'dart:math';

import 'package:engage/def/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

import 'package:engage/def/textSytles.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/pages/productDetailsPage.dart';

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double itemDiscountedPrice;

class ItemCard extends StatelessWidget {
  final ProductModel product;

  final double cardWidth;
  final double cardHeight;

  ItemCard(this.product, this.cardWidth, this.cardHeight);

  @override
  Widget build(BuildContext context) {
    itemDiscountedPrice = product.price * ((100 - product.discount) / 100);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
        ),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product))).then(
              (value) => BlocProvider.of<ShoppingCartBloc>(context)
                  .add(FetchShoppingCart()),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: cardWidth,
                    height: cardHeight - 35.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: "https://lalorduy.dentotys.com/storage/" +
                            product.imageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: cardWidth,
                    height: cardHeight - 50.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                          colors: [
                            CupertinoColors.darkBackgroundGray.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: product.discount == 0 ? false : true,
                    child: Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Material(
                        elevation: 5.0,
                        color: appLightTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Transform.rotate(
                            angle: pi / 8,
                            child: Text(
                              "-${product.discount}%",
                              style: itemCardDiscountStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Container(
                      height: ScreenUtil.instance.setHeight(60.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(product.name,
                              style: itemCardTitleStyle, softWrap: true),
                          Text("Disponibles: ${product.stock}",
                              style: itemCardSubtitleStyle, softWrap: true),
                          Container(
                            height: ScreenUtil.instance.setHeight(1.0),
                            width: ScreenUtil.instance.setWidth(150.0),
                            color: Colors.white70,
                          ),
                          Text("Exp Date: ${DateTime.now()}",
                              style: itemCardExpDateStyle, softWrap: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: product.discount == 0 ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            "${NumberFormat.simpleCurrency().format(product.price)}",
                            style: itemCardFullPriceStyle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "${NumberFormat.simpleCurrency().format(itemDiscountedPrice)}",
                          style: itemCardDiscountedPriceStyle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
