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
            List<Cartoon> _cartoons = snapshot.data.reversed.toList();
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
                                    errorWidget: (_, _s, _o) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width - 80,
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

  @override
  void dispose() {
    DbHelper().close();
    super.dispose();
  }
}
