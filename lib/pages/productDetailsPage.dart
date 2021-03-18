import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:engage/pages/productCreationPage.dart';

import 'package:engage/widgets/itemCard.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/cartItemModel.dart';

import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';

import 'package:engage/services/authService.dart';

import 'package:engage/app/engageApp.dart' as app;

import 'package:engage/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:math';

AuthService authService;

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;
  ProductDetailsPage(this.product, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    itemDiscountedPrice = product.price * ((100 - product.discount) / 100);
    authService = Provider.of<AuthService>(context);

    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: product.stock.toDouble(),
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final commercePremium = Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "Precio: ${NumberFormat.simpleCurrency().format(itemDiscountedPrice)}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 50.0),
        Icon(
          Icons.whatshot,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 150.0,
          child: new Divider(
            color: Colors.green,
            thickness: 1.5,
          ),
        ),
        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Visibility(
                  visible: product.discount == 0 ? false : true,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "¡Tiene ${product.discount}% de descuento!",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )),
            Expanded(flex: 1, child: commercePremium)
          ],
        ),
      ],
    );

    final topContent = FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        product.name,
        style: pageTitleStyle.copyWith(
            fontSize: 20, color: CupertinoColors.extraLightBackgroundGray),
      ),
      background: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.5,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  "https://lalorduy.dentotys.com/storage/" + product.imageURL,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.all(40.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .8)),
            child: Center(
              child: topContentText,
            ),
          ),
        ],
      ),
    );

    final bottomContentText = Text(
      "",
      style: TextStyle(fontSize: 18.0),
    );

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("COMPRA AQUÍ!", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = ListView(
      padding: EdgeInsets.all(25.0),
      children: <Widget>[bottomContentText, readButton],
    );

    return FutureBuilder(
      future: Future.wait([app.apiClientService.fetchProductInfo(product)])
          .then((value) => value.first),
      builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxScrolled) => <Widget>[
                  SliverAppBar(
                    primary: true,
                    pinned: true,
                    forceElevated: innerBoxScrolled,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: topContent,
                  ),
                ],
                body: FormBuilder(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'commerceGroup': "",
                    'discount': 0,
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Disponibles: ${product.stock}",
                                style: itemCardTitleStyle.copyWith(
                                    color: Colors.black),
                                softWrap: true),
                            Text("ID de producto: ${product.productID}",
                                style: itemCardSubtitleStyle.copyWith(
                                    color: Colors.black),
                                softWrap: true),
                            Container(
                              height: ScreenUtil.instance.setHeight(1.0),
                              width: ScreenUtil.instance.setWidth(150.0),
                              color: Colors.white70,
                            ),
                            Text("Exp Date: ${DateTime.now()}",
                                style: itemCardExpDateStyle.copyWith(
                                    color: Colors.blueGrey),
                                softWrap: true),
                          ],
                        ),
                        FormBuilderTextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          maxLength: 420,
                          autocorrect: false,
                          attribute: "additional_details",
                          decoration: InputDecoration(
                              labelText: "Detalles adicionales"),
                          validators: [
                            FormBuilderValidators.max(420),
                          ],
                        ),
                        /*FormBuilderTextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    attribute: "discount_code",
                    decoration: InputDecoration(
                        labelText:
                            "¿Tienes un código de descuento? ¡Úsalo aquí!"),
                    validators: [
                      FormBuilderValidators.max(100),
                    ],
                  ),*/
                        FormBuilderTouchSpin(
                          decoration: InputDecoration(
                              labelText: "¿Cuántos deseas comprar?"),
                          attribute: "quantity",
                          initialValue: 1,
                          min: 1,
                          max: product.stock,
                          step: 1,
                        ),
                        /*FormBuilderDateTimePicker(
                  enabled:
                      _fbKey.currentState.fields['discount'].currentState.value >
                              0.0
                          ? true
                          : false,
                  attribute: "discountDate",
                  inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd"),
                  decoration:
                      InputDecoration(labelText: "Fecha límite de Descuento"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Este campo es requerido."),
                  ],
                ),*/
                        /*FormBuilderDateTimePicker(
                  attribute: "date",
                  inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(labelText: "Appointment Time"),
                ),
                FormBuilderSlider(
                  attribute: "slider",
                  validators: [FormBuilderValidators.min(6)],
                  min: 0.0,
                  max: 10.0,
                  initialValue: 1.0,
                  divisions: 20,
                  decoration: InputDecoration(labelText: "Number of things"),
                ),
                FormBuilderCheckbox(
                  attribute: 'accept_terms',
                  label:
                      Text("I have read and agree to the terms and conditions"),
                  validators: [
                    FormBuilderValidators.requiredTrue(
                      errorText:
                          "You must accept terms and conditions to continue",
                    ),
                  ],
                ),
                FormBuilderDropdown(
                  attribute: "gender",
                  decoration: InputDecoration(labelText: "Gender"),
                  // initialValue: 'Male',
                  hint: Text('Select Gender'),
                  validators: [FormBuilderValidators.required()],
                  items: ['Male', 'Female', 'Other']
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text("$gender")))
                      .toList(),
                ),
                FormBuilderTextField(
                  attribute: "age",
                  decoration: InputDecoration(labelText: "Age"),
                  validators: [
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.max(70),
                  ],
                ),
                FormBuilderSegmentedControl(
                  decoration: InputDecoration(labelText: "Movie Rating (Archer)"),
                  attribute: "movie_rating",
                  options: List.generate(5, (i) => i + 1)
                      .map((number) => FormBuilderFieldOption(value: number))
                      .toList(),
                ),
                FormBuilderSwitch(
                  label: Text('I Accept the tems and conditions'),
                  attribute: "accept_terms_switch",
                  initialValue: true,
                ),
                FormBuilderTouchSpin(
                  decoration: InputDecoration(labelText: "Stepper"),
                  attribute: "stepper",
                  initialValue: 10,
                  step: 1,
                ),
                FormBuilderRate(
                  decoration: InputDecoration(labelText: "Rate this form"),
                  attribute: "rate",
                  iconSize: 32.0,
                  initialValue: 1,
                  max: 5,
                ),
                FormBuilderCheckboxList(
                  decoration:
                      InputDecoration(labelText: "The language of my people"),
                  attribute: "languages",
                  initialValue: ["Dart"],
                  options: [
                    FormBuilderFieldOption(value: "Dart"),
                    FormBuilderFieldOption(value: "Kotlin"),
                    FormBuilderFieldOption(value: "Java"),
                    FormBuilderFieldOption(value: "Swift"),
                    FormBuilderFieldOption(value: "Objective-C"),
                  ],
                ),
                FormBuilderFilterChip(
                  attribute: "pets",
                  options: [
                    FormBuilderFieldOption(child: Text("Cats"), value: "cats"),
                    FormBuilderFieldOption(child: Text("Dogs"), value: "dogs"),
                    FormBuilderFieldOption(
                        child: Text("Rodents"), value: "rodents"),
                    FormBuilderFieldOption(child: Text("Birds"), value: "birds"),
                  ],
                ),
                FormBuilderSignaturePad(
                  decoration: InputDecoration(labelText: "Signature"),
                  attribute: "signature",
                  height: 300,
                ),*/
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    if (product.stock == 0) {
                      Fluttertoast.showToast(
                          msg:
                              "No existen productos en inventario. Regresa pronto e intenta de nuevo",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      print(_fbKey.currentState.value);
                      app.apiClientService
                          .addProductToShoppingCart(
                              app.authService.currentUserData,
                              product,
                              _fbKey.currentState.value['quantity'])
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "¡Producto agregado  al carrito exitosamente!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: CupertinoColors.darkBackgroundGray,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return Navigator.pop(context);
                      });
                    }
                  } else
                    Fluttertoast.showToast(
                        msg:
                            "Los datos son requeridos para crear Tu Esquinita.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: CupertinoColors.darkBackgroundGray,
                        textColor: Colors.white,
                        fontSize: 16.0);
                },
                label: Text("Agregar al Carrito",
                    style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.shopping_cart, color: Colors.white),
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
