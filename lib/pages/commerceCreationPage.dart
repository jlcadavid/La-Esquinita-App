import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:engage/models/commerceModel.dart';
import 'package:engage/services/authService.dart';

import 'package:provider/provider.dart';

AuthService authService;

CommerceModel newCommerce;

MediaQueryData queryData;

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class CommerceCreationPage extends StatefulWidget {
  final String title = "¡Crea tu Esquinita!";
  CommerceCreationPage();

  @override
  _CommerceCreationPageState createState() => _CommerceCreationPageState();
}

class _CommerceCreationPageState extends State<CommerceCreationPage> {
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
          'active': true,
          'accept_terms': false,
          'rating': 0.0,
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              FormBuilderImagePicker(
                attribute: "commerceImage",
                decoration: InputDecoration(labelText: "¡Muestranos tu idea!"),
                validators: [],
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.name,
                autocorrect: false,
                autofocus: true,
                attribute: "name",
                decoration:
                    InputDecoration(labelText: "Nombre de Tu Esquinita"),
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
                decoration: InputDecoration(labelText: "Describe tu idea..."),
                validators: [
                  FormBuilderValidators.max(420),
                ],
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.streetAddress,
                autocorrect: false,
                attribute: "address",
                decoration: InputDecoration(
                    labelText:
                        "¿Dónde queda Tu Esquinita? (solo por mensajería)"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                  FormBuilderValidators.max(100),
                ],
              ),
              FormBuilderDateTimePicker(
                inputType: InputType.time,
                attribute: "startTime",
                decoration:
                    InputDecoration(labelText: "¿A qué hora empezarás?"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                  FormBuilderValidators.max(100),
                ],
              ),
              FormBuilderDateTimePicker(
                inputType: InputType.time,
                attribute: "endTime",
                decoration: InputDecoration(labelText: "¿Y finalizarás?"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Este campo es requerido."),
                  FormBuilderValidators.max(100),
                ],
              ),
              FormBuilderSwitch(
                attribute: "additionalInfo",
                label: Text(
                    "¿Deseas recibir información de emprendimiento, crecimiento empresarial y estadísticas para Tu Esquinita?"),
              ),
              FormBuilderCheckbox(
                attribute: 'accept_terms',
                label: Text(
                    "He leído y acepto los Términos y Condiciones de uso y la Política de Privacidad de Datos."),
                validators: [
                  FormBuilderValidators.requiredTrue(
                    errorText: "Debes verificar el campo para continuar.",
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: FloatingActionButton.extended(
                    label: Text(
                      "Crear Esquinita",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.store,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                        authService
                            .registerCommerce(
                              CommerceModel(
                                authService.currentUserData.userID,
                                _fbKey.currentState.value['name'],
                                _fbKey.currentState.value['address'],
                              ),
                            )
                            .then(
                              (value) => Fluttertoast.showToast(
                                  msg: "$value",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor:
                                      CupertinoColors.darkBackgroundGray,
                                  textColor: Colors.white,
                                  fontSize: 16.0),
                            )
                            .then((value) => Navigator.pop(
                                  context,
                                  authService.currentUserCommerceList,
                                ))
                            .catchError(
                              (e) => Fluttertoast.showToast(
                                  msg: "${e.toString()}",
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
