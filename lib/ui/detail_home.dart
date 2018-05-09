import 'package:flutter/material.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/utils/html_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class DetailHome extends StatefulWidget {
  final String url;
  final String name;

  DetailHome({this.url, this.name});

  @override
  State<StatefulWidget> createState() => new DetailHomeState();
}

class DetailHomeState extends State<DetailHome> {
  var _cartoons = <Cartoon>[];
  bool isCompelete = false;
  bool isFailed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Application.key = _scaffoldKey;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.name),
        centerTitle: true,
      ),
      body: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (isFailed) {
      return new Center(
        child: new Text("获取数据异常，请访问官网观看"),
      );
    }
    if (isCompelete)
      return new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Flexible(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.topLeft,
                    child: new CachedNetworkImage(
                      imageUrl: _cartoons[0].picture,
                      placeholder: new Center(
                        child: new CircularProgressIndicator(),
                      ),
                      errorWidget: new Icon(Icons.error),
                    ),
                  )),
              new Flexible(
                  flex: 4,
                  child: new Container(
                    padding: new EdgeInsets.only(left: 10.0),
                    child: new Text(_cartoons[0].intro),
                  ))
            ],
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: _cartoons.length,
              itemBuilder: (_, i) {
                return new GestureDetector(
                    onTap: () {
                      String json = jsonEncode(_cartoons[i]);
                      json = json.replaceAll("/", "]");
                      Application.router.navigateTo(context, '/play/$json');
                    },
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(10.0),
                          child: new Text(_cartoons[i].name),
                        ),
                        new Divider(),
                      ],
                    ));
              },
            ),
          ),
        ],
      );
    else
      return new Center(
        child: new CircularProgressIndicator(),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String url = widget.url.replaceAll("[", "/");
    http.htmlGetCategoryDetail(url, sfn: (_cs) {
      setState(() {
        _cartoons = _cs;
        isCompelete = true;
      });
    }, ffn: () {
      setState(() {
        isFailed = true;
      });
    });
//    http.htmlGetCategoryDetail((_h) {
//        try {
//          HtmlUtils.parseDetailList(_h,(_cs){
//            setState(() {
//              _cartoons = _cs;
//              isCompelete = true;
//            });
//          });
//        } catch (e) {
//          isFailed = true;
//        }
//    }, url);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
