import 'package:flutter/material.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/db/db_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class HistoryBody extends StatefulWidget {
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
    return new FutureBuilder(
        future: DbHelper().getCartoon(),
        builder: (_, AsyncSnapshot<List<Cartoon>> snapshot) {
          if (snapshot.hasData) {
            List<Cartoon> _cartoons = snapshot.data;
            return new Scaffold(
              key: _scaffoldKey,
              body: new ListView.builder(
                  itemCount: _cartoons.length,
                  itemBuilder: (_, i) {
                    return new GestureDetector(
                      onTap: () {
                        String json = jsonEncode(_cartoons[i]);
                        json = json.replaceAll("/", "]");
                        Application.router.navigateTo(context, '/play/$json');
                      },
                      child: new Row(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            width: 80.0,
                            child: _cartoons[i].picture == null ||
                                    _cartoons[i].picture.isEmpty
                                ? Container()
                                : CachedNetworkImage(
                                    imageUrl: _cartoons[i].picture,
                                  ),
                          ),
                          new Expanded(
                              child: new Column(
                            children: <Widget>[
                              new Text(_cartoons[i].name),
                              new Text(_cartoons[i].episode == null
                                  ? ""
                                  : _cartoons[i].episode),
                            ],
                          ))
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

  @override
  void dispose() {
    DbHelper().close();
    super.dispose();
  }
}
