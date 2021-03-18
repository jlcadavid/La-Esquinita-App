import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/commerceModel.dart';

import 'package:engage/widgets/itemCard.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

double itemCardWidth = ScreenUtil.instance.setWidth(420.0);
double itemCardHeight = ScreenUtil.instance.setHeight(200.0);

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<ProductModel>(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            hintText: "¿Qué deseas?",
            minimumChars: 2,
            debounceDuration: Duration(microseconds: 1000),
            placeHolder: Center(
              child: Text("¡Busca lo que quieras! 🔍😃"),
            ),
            emptyWidget: Center(
              child: Text("No se encontraron resultados. 😞"),
            ),
            onItemFound: (item, int index) =>
                ItemCard(item, itemCardWidth, itemCardHeight),
            onSearch: (String text) =>
                app.apiClientService.searchProducts(text),
          ),
        ),
      ),
    );
  }
}
