import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

AuthService authService;
PaginationService paginationService;

TabController tabController;
int currentIndex = 0;

final _firstNameFocusNode = FocusNode();
final _lastNameFocusNode = FocusNode();
final _idFocusNode = FocusNode();
final _emailFocusNode = FocusNode();

final _formKey = GlobalKey<FormBuilderState>();

LoginData currentLoginData;
String _firstName, _lastName, _document, _email;

List<Slide> slides = [
  Slide(
    colorBegin: Color(0xFF68DC6E),
    colorEnd: CupertinoColors.darkBackgroundGray,
    title: "Cuéntanos un poco más de ti...",
    styleTitle: mainHintTextStyle.copyWith(
      color: CupertinoColors.extraLightBackgroundGray,
      fontWeight: FontWeight.bold,
    ),
    centerWidget: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                autofocus: true,
                focusNode: _firstNameFocusNode,
                validator: ValidationBuilder()
                    .regExp(
                        RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                        "Nombre inválido.")
                    .build(),
                onSaved: (firstName) => _firstName = firstName,
                onChanged: (value) => _formKey.currentState.validate()
                    ? _formKey.currentState.save()
                    : null,
                onFieldSubmitted: (value) => _formKey.currentState.validate()
                    ? _formKey.currentState.save()
                    : null,
                keyboardType: TextInputType.name,
                style: mainTextFieldStyle,
                cursorColor: appLightTheme.primaryColor,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  labelText: "¿Cuál es tu nombre?",
                  labelStyle: mainHintTextStyle,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                focusNode: _lastNameFocusNode,
                validator: ValidationBuilder()
                    .regExp(
                        RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                        "Apellido inválido.")
                    .build(),
                onSaved: (lastName) => _lastName = lastName,
                onChanged: (value) => _formKey.currentState.validate()
                    ? _formKey.currentState.save()
                    : null,
                onFieldSubmitted: (value) => _formKey.currentState.validate()
                    ? _formKey.currentState.save()
                    : null,
                keyboardType: TextInputType.name,
                style: mainTextFieldStyle,
                cursorColor: appLightTheme.primaryColor,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  labelText: "¿Y tu apellido?",
                  labelStyle: mainHintTextStyle,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
  Slide(
    colorBegin: Color(0xFF68DC6E),
    colorEnd: CupertinoColors.darkBackgroundGray,
    title: "¡Estemos en contacto!",
    styleTitle: mainHintTextStyle.copyWith(
      color: CupertinoColors.extraLightBackgroundGray,
      fontWeight: FontWeight.bold,
    ),
    centerWidget: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            focusNode: _emailFocusNode,
            validator: ValidationBuilder()
                .email("Correo electrónico inválido.")
                .build(),
            onSaved: (email) => _email = email,
            onChanged: (value) => _formKey.currentState.validate()
                ? _formKey.currentState.save()
                : null,
            onFieldSubmitted: (value) => _formKey.currentState.validate()
                ? _formKey.currentState.save()
                : null,
            keyboardType: TextInputType.emailAddress,
            style: mainTextFieldStyle,
            cursorColor: appLightTheme.primaryColor,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              labelText: "¿Cuál es tu correo electrónico?",
              labelStyle: mainHintTextStyle,
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    ),
  ),
  Slide(
    colorBegin: Color(0xFF68DC6E),
    colorEnd: CupertinoColors.darkBackgroundGray,
    title: "Por tu seguridad...",
    styleTitle: mainHintTextStyle.copyWith(
      color: CupertinoColors.extraLightBackgroundGray,
      fontWeight: FontWeight.bold,
    ),
    centerWidget: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            focusNode: _idFocusNode,
            validator: ValidationBuilder()
                .or(
                  (builder) => builder.regExp(
                      RegExp(r"(^[0-9]+-{1}[0-9]{1})"), "NIT inválido."),
                  (builder) => builder.regExp(
                      RegExp(r"\d{6,10}"), "Cédula de Ciudadanía inválida."),
                )
                .minLength(6)
                .maxLength(10)
                .build(),
            onSaved: (document) => document = document,
            onChanged: (value) => _formKey.currentState.validate()
                ? _formKey.currentState.save()
                : null,
            onFieldSubmitted: (value) => _formKey.currentState.validate()
                ? _formKey.currentState.save()
                : null,
            keyboardType: TextInputType.number,
            style: mainTextFieldStyle,
            cursorColor: appLightTheme.primaryColor,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              labelText: "¿Cuál es tu CC o NIT?",
              labelStyle: mainHintTextStyle,
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    ),
  ),
  Slide(
    colorBegin: Color(0xFF68DC6E),
    colorEnd: CupertinoColors.darkBackgroundGray,
    title: "¡ES TODO!",
    pathImage: "assets/images/Asset 2@2x.png",
    description:
        "¡Muchas gracias! Empieza a disfrutar de la mejor variedad de productos y servicios disponibles en tu localidad gracias a todos los aportantes en esta gran iniciativa de estudiantes de 10mo semestre de la Universidad del Norte.\n\nLA ESQUINITA APP",
    styleTitle: mainHintTextStyle.copyWith(
      color: CupertinoColors.extraLightBackgroundGray,
      fontWeight: FontWeight.bold,
    ),
    styleDescription:
        mainHintTextStyle.copyWith(color: CupertinoColors.lightBackgroundGray),
  ),
];

class AccountSetupPage extends StatefulWidget {
  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    authService = Provider.of<AuthService>(context);
    paginationService = Provider.of<PaginationService>(context);
    return FormBuilder(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: IntroSlider(
        isShowSkipBtn: false,
        isShowPrevBtn: true,
        isShowNextBtn: true,
        isScrollable: false,
        namePrevBtn: "Volver",
        nameNextBtn: "Siguiente",
        nameDoneBtn: "¡LISTO!",
        colorActiveDot: CupertinoColors.activeBlue,
        slides: slides,
        onDonePress: () {
          _formKey.currentState.validate()
              ? _formKey.currentState.save()
              : null;
          print(
              "First Name: $_firstName\nLast Name: $_lastName\nEmail: $_email\nDocument: $_document");
          authService.newAccount = false;
          authService
              .signUp(authService.userCredentials, _document, _firstName,
                  _lastName, _email)
              .then(
                (value) => value != null
                    ? Fluttertoast.showToast(
                        msg: "Error: $value",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: CupertinoColors.darkBackgroundGray,
                        textColor: Colors.white,
                        fontSize: 16.0)
                    : Navigator.pushReplacementNamed(context, "/mainPage"),
              );
        },
      ),
    );
  }

  void switchInputFields(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
    switch (currentIndex) {
      case 0:
        _firstNameFocusNode.requestFocus();
        break;
      case 1:
        _lastNameFocusNode.requestFocus();
        break;
      case 2:
        _idFocusNode.requestFocus();
        break;
      case 3:
        _emailFocusNode.requestFocus();
        break;
    }
  }

  void goToTab(index) {
    if (index >= 0 &&
        index < tabController.length &&
        index != tabController.index) {
      tabController.animateTo(index);
      currentIndex = index;
    }
  }

  void goToNextTab() {
    currentIndex + 1 < tabController.length ? goToTab(currentIndex + 1) : null;
  }

  void goToPrevTab() {
    currentIndex - 1 >= 0 ? goToTab(currentIndex - 1) : null;
  }
}
