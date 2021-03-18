import 'package:engage/pages/listPage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:engage/def/textSytles.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

double itemCardWidth = ScreenUtil.instance.setWidth(450.0);
double itemCardHeight = ScreenUtil.instance.setHeight(250.0);
double itemCardPadding = ScreenUtil.instance.setHeight(2.5);

class RowList extends StatefulWidget {
  final String title;
  final List<Widget> items;

  RowList(this.title, this.items);

  @override
  _RowListState createState() => _RowListState();
}

class _RowListState extends State<RowList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: rowItemListTitleStyle,
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          "VER TODOS (${widget.items.length})",
                          style: rowItemListViewAllStyle,
                        ),
                      ),
                      splashColor: Colors.white54,
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        setState(
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPage(
                                  widget.title,
                                  widget.items,
                                ),
                                settings: RouteSettings(
                                  name: widget.title,
                                  arguments: widget.items,
                                ),
                                maintainState: true,
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Container(
              height: itemCardHeight + itemCardPadding,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: widget.items,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
