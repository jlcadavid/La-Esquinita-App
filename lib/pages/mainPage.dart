import 'package:engage/bloc/bloc.dart';
import 'package:engage/def/textSytles.dart';
import 'package:engage/def/themes.dart';
import 'package:engage/pages/homePage/homePage.dart';
import 'package:engage/pages/homePage/homePageHeader.dart';
import 'package:engage/pages/searchPage.dart';
import 'package:engage/services/authService.dart';
import 'package:engage/services/paginationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/categoryModel.dart';

import 'package:engage/app/engageApp.dart' as app;

MediaQueryData queryData;

AuthService authService;
PaginationService paginationService;

SharedPreferences prefs;

class MainPage extends StatefulWidget {
  final String title;

  final List navDrawerTitles;
  final List navDrawerIcons;
  final List bottomNavBarItems;

  final List navDrawerPages;
  final List bottomNavBarPages;

  MainPage(this.navDrawerTitles, this.navDrawerIcons, this.bottomNavBarItems,
      this.navDrawerPages, this.bottomNavBarPages,
      {Key key, this.title})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    ScreenUtil.instance = ScreenUtil(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      allowFontScaling: true,
    )..init(context);
    authService = Provider.of<AuthService>(context);
    paginationService = Provider.of<PaginationService>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShoppingCartBloc>(
          create: (BuildContext context) =>
              ShoppingCartBloc(authService.currentUserData),
        ),
      ],
      child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
        builder: (BuildContext context, state) {
          print(state.toString());
          if (state is ShoppingCartEmpty) {
            BlocProvider.of<ShoppingCartBloc>(context).add(FetchShoppingCart());
          }
          if (state is ShoppingCartLoaded) {
            app.authService.currentUserData.userShoppingCart =
                state.props.first;
            return SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                backgroundColor: CupertinoColors.lightBackgroundGray,
                body: IndexedStack(
                  index: paginationService.currentIndex,
                  children: widget.bottomNavBarPages,
                ),
                bottomNavigationBar: TitledBottomNavigationBar(
                  items: widget.bottomNavBarItems,
                  //reverse: true,
                  currentIndex: paginationService.currentIndex,
                  indicatorColor: appLightTheme.primaryColor,
                  inactiveStripColor: CupertinoColors.darkBackgroundGray,
                  onTap: (index) {
                    setState(() {
                      paginationService.currentIndex = index;
                    });
                  },
                ),
                drawer: Drawer(
                  child: Container(
                    color: CupertinoColors.extraLightBackgroundGray,
                    child: Column(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                              size: 60.0,
                            ),
                          ),
                          accountName: Text(
                              "Hola, ${authService.currentUserData.firstName} 👋"),
                          accountEmail:
                              Text("${authService.currentUserData.email}"),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context,
                                    int index) =>
                                Divider(color: CupertinoColors.inactiveGray),
                            itemCount: widget.navDrawerTitles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Hero(
                                tag: "opNav#$index",
                                child: ListTile(
                                  title: Text(
                                    widget.navDrawerTitles[index],
                                    style: navigationDrawerTextStyle,
                                  ),
                                  trailing: Icon(
                                    widget.navDrawerIcons[index],
                                    color: appLightTheme.accentColor,
                                  ),
                                  onTap: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      widget.navDrawerPages[index],
                                    ).then((value) {
                                      return index == 0
                                          ? BlocProvider.of<ShoppingCartBloc>(
                                                  context)
                                              .add(FetchShoppingCart())
                                          : null;
                                    });
                                  },
                                ),
                              );
                            },
                            // Important: Remove any padding from the ListView.
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Divider(
                            color: CupertinoColors.inactiveGray, thickness: 2),
                        Hero(
                          tag: "opNavSettings",
                          child: ListTile(
                            title: Text(
                              "Ajustes",
                              style: navigationDrawerTextStyle,
                            ),
                            trailing: Icon(
                              Icons.settings,
                              color: appLightTheme.accentColor,
                            ),
                            onTap: () {
                              Navigator.popAndPushNamed(
                                  context, "/settingsPage");
                            },
                          ),
                        ),
                        Divider(color: CupertinoColors.lightBackgroundGray),
                        Hero(
                          tag: "opNavSignOut",
                          child: ListTile(
                            title: Text(
                              "Cerrar sesión",
                              style: navigationDrawerTextStyle,
                            ),
                            trailing: Icon(
                              Icons.lock,
                              color: appLightTheme.accentColor,
                            ),
                            onTap: () {
                              HomePageHeader.imageIndex = 0;
                              authService.logOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/loginPage",
                                  (Route<dynamic> route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: Visibility(
                  visible: paginationService.currentIndex != 4 ? true : false,
                  child: FloatingActionButton.extended(
                    label: Text("¿Qué deseas?",
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        )).then(
                      (value) => BlocProvider.of<ShoppingCartBloc>(context)
                          .add(FetchShoppingCart()),
                    ),
                  ),
                ),
              ),
            );
          }
          if (state is ShoppingCartError) {
            BlocProvider.of<ShoppingCartBloc>(context).add(FetchShoppingCart());
          }
          return Container(
            color: CupertinoColors.extraLightBackgroundGray,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: appLightTheme.primaryColor,
                strokeWidth: 5,
              ),
            ),
          );
        },
      ),
    );
  }
}
