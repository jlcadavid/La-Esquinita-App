//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:engage/models/commerceModel.dart';
import 'package:engage/models/productModel.dart';
import 'package:engage/models/userModel.dart';
import 'package:engage/services/APIClientService.dart';
import 'package:engage/pages/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';

APIClientService apiClientService = new APIClientService();

LoginData currentLoginData;
UserModel currentUser;

bool isNewAccount = false;

class AuthService with ChangeNotifier {
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // wrapping the firebase calls
  /*Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }*/

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  /*Future<User> loginUser(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let'phone notify the listeners...
      notifyListeners();
      return result.user;
    }  catch (e) {
      // throw the Firebase AuthException that we caught
      throw new Exception(e);
    }
  }*/

  //TODO: API Auth Endpoint communication
  Future<String> logIn(LoginData data) async {
    print('Phone: ${data.name}, Password: ${data.password}');
    return Future.delayed(Duration(milliseconds: 1500))
        .then((value) async =>
            await apiClientService.fetchUser(data.name, data.password))
        .then((value) async {
      if (value == null) {
        return 'Número de teléfono o contraseña incorrecta.';
      }
      currentUser = value;
      await FlutterSession().set('_', currentUser);
      //print(await FlutterSession().get('_'));
      currentLoginData = null;
      //notifyListeners();
      return null;
    }).catchError((e, s) {
      print("Error: ${e.toString()}, Stacktrace: ${s.toString()}");
      return e.toString();
    });
  }

  Future<String> signUp(LoginData data, String document, String firstName,
      String lastName, String email) async {
    print('Phone: ${data.name}, Password: ${data.password}');
    return Future.delayed(Duration(milliseconds: 1500))
        .then(
      (value) async => await apiClientService.createUser(
          document, firstName, lastName, data.name, email, data.password),
    )
        .then((value) async {
      if (value == null) {
        return 'No fue posible crear el usuario. Intenta de nuevo.';
      }
      currentUser = value;
      await FlutterSession().set('_', currentUser);
      //print(await FlutterSession().get('_'));
      currentLoginData = null;
      //notifyListeners();
      return null;
    }).catchError((e, s) {
      print("Error: ${e.toString()}\nStacktrace: ${s.toString()}");
      return e.toString();
    });
  }

  Future<String> recoverPassword(String phone) async {
    /*print('Phone: $phone');
    return Future.delayed(Duration(milliseconds: 3000)).then((_) {
      if (!users.containsKey(phone)) {
        return 'Número de teléfono incorrecto.';
      }
      //notifyListeners();
      return null;
    });*/
  }

  Future<String> registerCommerce(CommerceModel newCommerce) async {
    print(newCommerce.toJson());
    return Future.delayed(Duration(milliseconds: 1500)).then(
      (value) async => await apiClientService
          .createCommerce(newCommerce)
          .then((value) async {
        if (value == null) {
          return 'No fue posible crear Tu Esquinita. Intenta de nuevo.';
        }
        currentUser.userCommerceList.add(value);
        await FlutterSession().set('_', currentUser);
        //notifyListeners();
        return '¡Esquinita creada exitosamente!';
      }),
    );
  }

  Future<String> registerProduct(ProductModel newProduct) async {
    print(newProduct.toJson());
    return Future.delayed(Duration(milliseconds: 1500)).then(
      (value) async =>
          await apiClientService.createProduct(newProduct).then((value) async {
        if (value == null) {
          return 'No fue posible agregar tu producto. Intenta de nuevo.';
        }
        //notifyListeners();
        return '¡Producto agregado exitosamente!';
      }),
    );
  }

  Future<void> logOut() async {
    await _initSharedPrefs();
    currentUser = null;
    prefs.remove('_');
    //notifyListeners();
  }

  Future<void> _initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get newAccount => isNewAccount;

  set newAccount(bool value) => isNewAccount = value;

  LoginData get userCredentials => currentLoginData;

  set loginData(LoginData data) => currentLoginData = data;

  UserModel get currentUserData => currentUser;

  set currentUserData(UserModel user) => currentUser = user;

  List<CommerceModel> get currentUserCommerceList => currentUserData.commerceList;
}
