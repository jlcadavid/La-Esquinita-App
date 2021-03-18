import 'package:engage/def/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle tabBarSelectedItemStyle = TextStyle(
  color: Colors.red,
  fontSize: ScreenUtil.instance.setSp(24.0),
  fontFamily: "Oxygen",
  fontWeight: FontWeight.w700,
);

TextStyle tabBarUnselectecItemStyle = TextStyle(
  color: Colors.blueGrey,
  fontSize: ScreenUtil.instance.setSp(14.0),
  fontFamily: "Oxygen",
  fontWeight: FontWeight.w700,
);

TextStyle itemCardFullPriceStyle = TextStyle(
    color: Colors.redAccent,
    decoration: TextDecoration.lineThrough,
    fontSize: ScreenUtil.instance.setSp(12.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.normal);

TextStyle itemCardDiscountedPriceStyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil.instance.setSp(18.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle itemCardDiscountStyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil.instance.setSp(16.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle itemCardExpDateStyle = TextStyle(
    color: Colors.yellow,
    fontSize: ScreenUtil.instance.setSp(12.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.normal);

TextStyle itemCardSubtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil.instance.setSp(16.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.normal);

TextStyle itemCardTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil.instance.setSp(20.0),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle rowItemListViewAllStyle = TextStyle(
  color: Colors.orange,
  fontSize: ScreenUtil.instance.setSp(14.0),
  fontWeight: FontWeight.bold,
);

TextStyle rowItemListTitleStyle = TextStyle(
    color: CupertinoColors.darkBackgroundGray,
    fontSize: ScreenUtil.instance.setSp(22.0),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold);

TextStyle chipChoiceStyle = TextStyle(
  color: Colors.white,
  fontSize: ScreenUtil.instance.setSp(14.0),
);

TextStyle dropDownLabelStyle = TextStyle(
  color: CupertinoColors.darkBackgroundGray,
  fontSize: ScreenUtil.instance.setSp(14.0),
);

TextStyle dropDownMenuStyle = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil.instance.setSp(14.0),
);

TextStyle mainTextFieldStyle = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil.instance.setSp(20.0),
);

TextStyle mainHintTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: ScreenUtil.instance.setSp(20.0),
);

TextStyle navigationDrawerTextStyle = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil.instance.setSp(14.0),
);

TextStyle pageTitleStyle = TextStyle(
    color: appLightTheme.accentColor,
    fontSize: ScreenUtil.instance.setSp(30.0),
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold);
