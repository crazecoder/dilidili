import 'package:flutter/material.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/db/db_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class HistoryBody extends StatefulWidget {
  final GlobalKey<HistoryBodyState> key;

  HistoryBody({this.key});
  @override
  State<StatefulWidget> createState() => new HistoryBodyState();
}

class HistoryBodyState extends State<HistoryBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Application.key = _scaffoldKey;
    return FutureBuilder(
        future: DbHelper().getCartoon(),
        builder: (_, AsyncSnapshot<List<Cartoon>> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data.length > 0) {
            List<Cartoon> _cartoons = snapshot.data.reversed.toList();
            return new Scaffold(
              key: _scaffoldKey,
              body: ListView.builder(
                  itemCount: _cartoons.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        String json = jsonEncode(_cartoons[i]);
                        json = json.replaceAll("/", "]");
                        Application.router.navigateTo(context, '/play/$json');
                      },
                      child: Row(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            width: 80.0,
                            height: 80,
                            child: _cartoons[i].picture == null ||
                                    _cartoons[i].picture.isEmpty
                                ? Center(
                                    child: Icon(Icons.error),
                                  )
                                : CachedNetworkImage(
                                    width: 80.0,
                                    height: 80,
                                    imageUrl: _cartoons[i].picture,
                                    errorWidget: (_, _s, _o) => Center(
                                      child: Icon(Icons.error),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(_cartoons[i].name),
                                new Text(_cartoons[i].episode == null
                                    ? ""
                                    : _cartoons[i].episode),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return new Center(
              child: new Text("暂无记录"),
            );
          }
        });
  }

  void clearList() {
    setState(() {});
  }

  @override
  void dispose() {
    DbHelper().close();
    super.dispose();
  }
}
