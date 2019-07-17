import 'package:dilidili/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:dilidili/application.dart';
import 'ui/new_body.dart';
import 'ui/category_body.dart';
import 'ui/search_body.dart';
import 'ui/history_body.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  int _index = 0;
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  static final GlobalKey<HistoryBodyState> _historyKey = new GlobalKey();

  static var titles = <Text>[
    new Text("首页"),
    new Text("追番"),
    new Text("搜索"),
    new Text("我的"),
  ];
  var items = <BottomNavigationBarItem>[
    new BottomNavigationBarItem(icon: new Icon(Icons.home), title: titles[0]),
    new BottomNavigationBarItem(icon: new Icon(Icons.toc), title: titles[1]),
    new BottomNavigationBarItem(icon: new Icon(Icons.search), title: titles[2]),
    new BottomNavigationBarItem(icon: new Icon(Icons.person), title: titles[3]),
  ];
  var bodys = <Widget>[
    new CategoryBody(),
    new NewBody(),
    new SearchBody(),
    new HistoryBody(
      key: _historyKey,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: items.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Application.key = _scaffoldKey;

    if (_index != 0)
      return new Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: new BottomNavigationBar(
          items: items,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
              _controller.index = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
        appBar: _buildAppBar(),
        body: new TabBarView(
          children: bodys,
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    else
      return new Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: new BottomNavigationBar(
          items: items,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
              _controller.index = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
        body: new TabBarView(
          children: bodys,
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        _index == 3
            ? GestureDetector(
                child: Container(
                  child: Icon(Icons.delete_sweep),
                  padding: EdgeInsets.only(right: 10),
                ),
                onTap: () {
                  DbHelper().clear();
                  _historyKey.currentState.clearList();
                },
              )
            : Container(),
      ],
      centerTitle: true,
      title: titles[_index],
    );
  }
}
