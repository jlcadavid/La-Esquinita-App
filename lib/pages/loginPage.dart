import 'package:engage/services/authService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';

AuthService authService;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    ScreenUtil.instance = ScreenUtil(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      allowFontScaling: true,
    )..init(context);
    authService = Provider.of<AuthService>(context);
    return FlutterLogin(
      theme: LoginTheme(
        pageColorLight: CupertinoColors.darkBackgroundGray,
      ),
      title: "La Esquinita",
      logo: 'assets/images/Asset 2@2x.png',
      emailValidator: ValidationBuilder()
          .phone("Número de teléfono inválido.")
          .minLength(7)
          .maxLength(10)
          .build(),
      passwordValidator: ValidationBuilder()
          .regExp(RegExp(r'^(?=.*?[A-Za-z0-9]).{6,}$'),
              "Contraseña inválida.")
          .build(),
      messages: LoginMessages(
          usernameHint: "Número de teléfono",
          passwordHint: "Contraseña",
          confirmPasswordHint: "Repite la contraseña",
          loginButton: "Iniciar sesión",
          signupButton: "Crear cuenta",
          forgotPasswordButton: "¿Olvidaste tu contraseña?",
          recoverPasswordIntro: "Reestablece tu contraseña",
          recoverPasswordDescription:
              "Enviaremos un mensaje de texto (SMS) a tu número de teléfono con un link de recuperación.",
          recoverPasswordButton: "Enviar",
          recoverPasswordSuccess:
              "Mensaje de texto de recuperación enviado exitosamente.",
          confirmPasswordError: "Contraseña incorrecta, intenta nuevamente.",
          goBackButton: "Volver"),
      onLogin: (_) => authService.logIn(_),
      onSignup: (_) {
        authService.newAccount = true;
        authService.loginData = _;
        return null;
      },
      onRecoverPassword: (_) => authService.recoverPassword(_),
      onSubmitAnimationCompleted: () => authService.newAccount
          ? Navigator.pushReplacementNamed(context, "/accountSetupPage")
          : Navigator.pushReplacementNamed(context, "/mainPage"),
    );
  }
}
