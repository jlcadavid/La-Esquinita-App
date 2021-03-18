import 'package:engage/app/engageApp.dart' as app;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/models/productModel.dart';
import 'package:engage/models/commerceModel.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

AuthService authService;

MediaQueryData queryData;

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class ProductCreationPage extends StatefulWidget {
  final String title = "Agrega un Producto";
  final CommerceModel commerce;
  ProductCreationPage(this.commerce);

  @override
  _ProductCreationPageState createState() => _ProductCreationPageState();
}

class _ProductCreationPageState extends State<ProductCreationPage> {
  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
              FormBuilderImagePicker(
                imageQuality: 50,
                attribute: "productImage",
                decoration:
                    InputDecoration(labelText: "¡Muestranos tu producto!"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido.")
                ],
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.name,
                autocorrect: false,
                autofocus: true,
                attribute: "name",
                decoration: InputDecoration(labelText: "Nombre del producto"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                  FormBuilderValidators.max(100),
                ],
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                maxLength: 420,
                autocorrect: false,
                attribute: "description",
                decoration:
                    InputDecoration(labelText: "Descripción del producto"),
                validators: [
                  FormBuilderValidators.max(420),
                ],
              ),
              FormBuilderChoiceChip(
                attribute: "category_id",
                decoration: InputDecoration(
                    labelText: "¿En qué categoria queda mejor tu producto?"),
                options: app.categories
                    .map(
                      (e) => FormBuilderFieldOption(
                        child: Text(e.name),
                        value: e.id,
                      ),
                    )
                    .toList(),
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.numberWithOptions(),
                autocorrect: false,
                attribute: "price",
                decoration:
                    InputDecoration(labelText: "Precio del producto (COP)"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                  FormBuilderValidators.numeric(
                      errorText: "El valor debe ser un número."),
                ],
              ),
              FormBuilderTouchSpin(
                decoration: InputDecoration(labelText: "Cantidad"),
                attribute: "stock",
                initialValue: 0,
                min: 0,
                step: 1,
              ),
              FormBuilderSlider(
                attribute: "discount",
                min: 0,
                max: 100,
                initialValue: 0,
                divisions: 100,
                decoration: InputDecoration(labelText: "Descuento (%)"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                ],
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
              FormBuilderSwitch(
                attribute: "couponSelected",
                label: Text(
                    "¿Deseas incluir el producto como candidato para promociones y cupones?"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: FloatingActionButton.extended(
                    label: Text(
                      "Agregar Producto",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.new_releases,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                        authService
                            .registerProduct(ProductModel(
                              _fbKey.currentState.value['name'],
                              int.parse(_fbKey.currentState.value['category_id']
                                  .toString()),
                              int.parse(_fbKey.currentState.value['price']),
                              _fbKey.currentState.value['stock'],
                              widget.commerce.commerceID,
                              discount:
                                  _fbKey.currentState.value['discount'].toInt(),
                              imageLocation:
                                  _fbKey.currentState.value['productImage'],
                            ))
                            .then(
                              (value) => Fluttertoast.showToast(
                                  msg: "$value",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor:
                                      CupertinoColors.darkBackgroundGray,
                                  textColor: Colors.white,
                                  fontSize: 16.0),
                            );
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
                  ),
                ),
              ),
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
    );
  }
}
