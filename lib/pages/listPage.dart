import 'package:flutter/material.dart';
import 'package:engage/def/textSytles.dart';
import 'package:flutter/cupertino.dart';

List<String> listImages = [
  "assets/images/IMG_20191031_200640.jpeg",
  "assets/images/IMG_20191031_200728.jpeg",
  "assets/images/IMG-20190220-WA0049.jpg",
  "assets/images/IMG-20190314-WA0103.jpg",
  "assets/images/IMG-20190316-WA0137.jpg",
  "assets/images/IMG-20190318-WA0008.jpg",
  "assets/images/IMG-20191114-WA0020.jpg",
  "assets/images/IMG-20191114-WA0022.jpg",
  "assets/images/PicsArt_11-14-02.42.09.jpg",
  "assets/images/Tuca Kendall Sábado 20 de Octubre-35.jpg",
];

class ListPage extends StatefulWidget {
  final String title;

  final List<Widget> listItems;

  ListPage(this.title, this.listItems);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(Duration(milliseconds: 3000)),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemExtent: 250,
          itemCount: widget.listItems.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.lightBackgroundGray,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    widget.listItems[index],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
