import 'dart:convert';
import 'dart:io';

import 'package:engage/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:engage/pages/mainPage.dart';
import 'package:engage/pages/shoppingCartPage.dart';
import 'package:engage/pages/historyPage.dart';
import 'package:engage/pages/couponsPage.dart';
import 'package:engage/pages/shareNWinPage.dart';
import 'package:engage/pages/engageBusinessPage.dart';
import 'package:engage/pages/settingsPage.dart';
import 'package:engage/pages/accountSetupPage.dart';
import 'package:engage/pages/dealsPage.dart';
import 'package:engage/pages/explorePage.dart';
import 'package:engage/pages/homePage/homePage.dart';
import 'package:engage/pages/productCreationPage.dart';
import 'package:engage/pages/loginPage.dart';
import 'package:engage/pages/suggestionsPage.dart';
import 'package:engage/pages/userProfilePage.dart';

import 'package:engage/def/themes.dart';

import 'package:engage/models/userModel.dart';
import 'package:engage/models/categoryModel.dart';
import 'package:engage/models/productModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'package:engage/services/authService.dart';
import 'package:engage/services/apiClientService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:provider/provider.dart';

//import 'package:firebase_auth/firebase_auth.dart';

AuthService authService;
APIClientService apiClientService = new APIClientService();

final appTitle = "La Esquinita";

final List<String> locations = [
  "Barranquilla (BAQ)",
  "Bogotá (BOG)",
  "Cartagena (CTG)",
  "Medellín (MED)",
  "Santa Marta (STM)",
  "Valledupar (VUP)",
];

final List<String> navDrawerPages = [
  "/shoppingCartPage",
  "/historyPage",
  "/couponsPage",
  "/shareNWinPage",
  "/engageBusinessPage",
];

final List<Widget> bottomNavBarPages = [
  HomePage(locations),
  ExplorePage("Explora"),
  DealsPage("Promos"),
  SuggestionsPage("Sugeridos"),
  UserProfilePage("Perfil"),
];

final List<String> navDrawerTitles = [
  "Carrito de Compras",
  "Historial",
  "Cupones",
  "Comparte & Gana!",
  "Mis Esquinitas",
];

final List<IconData> navDrawerIcons = [
  Icons.shopping_cart,
  Icons.receipt,
  Icons.local_activity,
  Icons.record_voice_over,
  Icons.store,
];

final bottomNavBarItems = [
  TitledNavigationBarItem(title: "Inicio", icon: Icons.home),
  TitledNavigationBarItem(title: "Explora", icon: Icons.explore),
  TitledNavigationBarItem(title: "Promos", icon: Icons.loyalty),
  TitledNavigationBarItem(title: "Sugeridos", icon: Icons.favorite),
  TitledNavigationBarItem(title: "Perfil", icon: Icons.account_circle)
];

List<CategoryModel> categories = [];

Map<CategoryModel, List<ProductModel>> productsByCategory =
    new Map<CategoryModel, List<ProductModel>>();

bool isLoading;

class EngageApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (BuildContext context) => AuthService(),
        ),
        ChangeNotifierProvider<PaginationService>(
          create: (BuildContext context) =>
              PaginationService(bottomNavBarPages),
        ),
      ],
      child: Title(
        title: appTitle,
        color: CupertinoColors.extraLightBackgroundGray,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          theme: appLightTheme,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', null),
            const Locale('es', null),
          ],
          home: FutureBuilder(
            future: FlutterSession().get('_'),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  //print(snapshot.data);
                  authService = Provider.of<AuthService>(context);
                  snapshot.data != null
                      ? authService.currentUserData =
                          UserModel.fromJson(snapshot.data)
                      : authService.logOut();
                  authService.currentUserData != null
                      ? print(authService.currentUserData)
                      : authService.logOut();
                  return snapshot.hasData &&
                          snapshot.data != null &&
                          authService.currentUserData != null
                      ? FutureBuilder(
                              future: Future.wait(
                                      [apiClientService.fetchCategories()])
                                  .then((value) => value),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<List<CategoryModel>>>
                                      snapshot_2) {
                                switch (snapshot_2.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot_2.hasData &&
                                        snapshot_2.data != null) {
                                      categories = snapshot_2.data[0];
                                      return MainPage(
                                        navDrawerTitles,
                                        navDrawerIcons,
                                        bottomNavBarItems,
                                        navDrawerPages,
                                        bottomNavBarPages,
                                      );
                                    } else
                                      return Container(
                                        color: CupertinoColors
                                            .extraLightBackgroundGray,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                appLightTheme.primaryColor,
                                            strokeWidth: 5,
                                          ),
                                        ),
                                      );
                                    break;

                                  case ConnectionState.waiting:
                                    return Container(
                                      color: CupertinoColors
                                          .extraLightBackgroundGray,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              appLightTheme.primaryColor,
                                          strokeWidth: 5,
                                        ),
                                      ),
                                    );

                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    else
                                      return new Text(
                                          'Result: ${snapshot.data}');
                                }
                              })
                      : LoginPage();

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
          ),
          routes: {
            "/loginPage": (context) => LoginPage(),
            "/accountSetupPage": (context) => AccountSetupPage(),
            "/mainPage": (context) => MainPage(
                  navDrawerTitles,
                  navDrawerIcons,
                  bottomNavBarItems,
                  navDrawerPages,
                  bottomNavBarPages,
                ),
            "/shoppingCartPage": (context) =>
                ShoppingCartPage(title: navDrawerTitles[0]),
            "/historyPage": (context) => HistoryPage(title: navDrawerTitles[1]),
            "/couponsPage": (context) => CouponsPage(title: navDrawerTitles[2]),
            "/shareNWinPage": (context) =>
                ShareNWinPage(title: navDrawerTitles[3]),
            "/engageBusinessPage": (context) =>
                EngageBusinessPage(title: navDrawerTitles[4]),
            "/settingsPage": (context) => SettingsPage(),
          },
        ),
      ),
    );
  }
}
