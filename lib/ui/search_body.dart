import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dilidili/utils/html_util.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/lib/library.dart';

class SearchBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SearchBodyState();
}

class SearchBodyState extends State<SearchBody> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  String _searchText = "";
  var _cartoons = <Cartoon>[];
  bool _isHttpCompelete = true;
  bool _isFailed = false;

  @override
  Widget build(BuildContext context) {
    if ((_isHttpCompelete && _cartoons.length == 0) || _isFailed) {
      return new Scaffold(
        body: new Column(
          children: <Widget>[
            _buildSearchView(),
            new Expanded(
              child: new Center(
                child: new Text(_isFailed ? "获取数据异常，请访问官网查看" : "抱歉，没有找到相关结果。"),
              ),
            )
          ],
        ),
      );
    }
    if (_isHttpCompelete && _cartoons.length != 0) {
      return new Scaffold(
        body: new Column(
          children: <Widget>[
            _buildSearchView(),
            new Expanded(
              child: new ListView.builder(
                  itemCount: _cartoons.length,
                  itemBuilder: (_, i) {
                    return new GestureDetector(
                      onTap: () {
                        String url = _cartoons[i].url.replaceAll("/", "[");
                        if (url.contains("watch")) {
                          String json = jsonEncode(_cartoons[i]);
                          json = json.replaceAll("/", "]");
                          json = json.replaceAll("?", "");
                          Application.router.navigateTo(context, '/play/$json');
                        } else
                          Application.router.navigateTo(context,
                              '/detail/$url/${_cartoons[i].name}/${_cartoons[i].picture}');
                      },
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(_cartoons[i].name),
                          ),
                          new Divider()
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    } else if (!_isHttpCompelete) {
      return new Scaffold(
        body: new Column(
          children: <Widget>[
            _buildSearchView(),
            new Expanded(
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            )
          ],
        ),
      );
    } else {
      return new Scaffold(
        body: new Column(
          children: <Widget>[
            _buildSearchView(),
          ],
        ),
      );
    }
  }

  Widget _buildSearchView() {
    return new Form(
      key: _formKey,
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextFormField(
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                filled: true,
                hintText: "请输入查找名称",
                labelText: '搜索',
              ),
              onSaved: (String value) {
                _searchText = value;
              },
            ),
//            new TextFormField(
//              decoration: new InputDecoration(hintText: "请输入查找名称"),
//              onSaved: (str) {
//                _searchText = str;
//              },
//            ),
          ),
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                final FormState form = _formKey.currentState;
                form.save();
                setState(() {
                  _isHttpCompelete = false;
                  _isFailed = false;
                });
                runZoned((){
                  http.htmlGetSearch((_html) {
                    try {
                      HtmlUtils.parseSearch(_html, (_cs) {
                        setState(() {
                          _cartoons = _cs;
                          _isHttpCompelete = true;
                        });
                      });
                    } catch (e) {
                      _isFailed = true;
                    }
                  }, _searchText);
                },onError: (_error, _stack){
                  setState(() {
                    _isFailed = true;
                  });
                });

              })
        ],
      ),
    );
  }
}
