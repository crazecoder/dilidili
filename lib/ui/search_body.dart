import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dilidili/utils/html_util.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/lib/library.dart';

class SearchBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchBodyState();
}

class SearchBodyState extends State<SearchBody> {
  final TextEditingController _editingController = TextEditingController();
  var _cartoons = <Cartoon>[];
  bool _isHttpCompelete;
  bool _isFailed = false;

  @override
  Widget build(BuildContext context) {
    if (_isHttpCompelete == null) return _buildInitializeBody();
    if (_isHttpCompelete && (_cartoons.length == 0 || _isFailed)) {
      return _buildEmptyOrErrorBody();
    }
    if (_isHttpCompelete && _cartoons.length != 0) {
      return _buildListBody();
    } else if (!_isHttpCompelete) {
      return _buildLoadingBody();
    } else {
      return _buildInitializeBody();
    }
  }

  Widget _buildInitializeBody() => Flex(
        children: <Widget>[_buildSearchView()],
        direction: Axis.vertical,
      );
  Widget _buildLoadingBody() => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      );
  Widget _buildEmptyOrErrorBody() => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(),
            Expanded(
              child: Center(
                child: Text(_isFailed ? "获取数据异常，请访问官网查看" : "抱歉，没有找到相关结果。"),
              ),
            )
          ],
        ),
      );
  Widget _buildSearchView() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 40,
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (_query) {
          setState(() {
            _isHttpCompelete = false;
            _isFailed = false;
          });
          runZoned(
            () {
              http.htmlGetSearch(
                (_html) {
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
                },
                _editingController.text,
              );
            },
            onError: (_error, _stack) {
              setState(
                () {
                  _isFailed = true;
                },
              );
            },
          );
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: GestureDetector(child: Icon(Icons.delete_sweep),onTap: (){
            _editingController.clear();
          },),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          hintText: "请输入查找名称",
        ),
        controller: _editingController,
      ),
    );
  }

  Widget _buildListBody() => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(),
            Expanded(
              child: ListView.builder(
                  itemCount: _cartoons.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(_cartoons[i].name),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
}
