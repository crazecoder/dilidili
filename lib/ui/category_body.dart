import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/utils/html_util.dart';
import 'category_detail_body.dart';

class CategoryBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CategoryBodyState();
}

class CategoryBodyState
    extends State<CategoryBody> with AutomaticKeepAliveClientMixin<CategoryBody>,TickerProviderStateMixin<CategoryBody>
{
  static bool _keepAlive = false;
  bool isHttpComplete = false;
  var categorys = <Category>[];
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    if (isHttpComplete) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("首页"),
          centerTitle: true,
          bottom: new TabBar(
              controller: _controller,
              isScrollable: true,
              tabs: categorys.map((category) {
                return new Tab(text: category.name);
              }).toList()),
        ),
        body: new TabBarView(
            controller: _controller,
            physics: ClampingScrollPhysics(),
            children: categorys.map((category) {
              return new CategoryDetailBody(
                url: category.url,
                isShow: !_controller.indexIsChanging,
              );
            }).toList()),
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    http.htmlGetCategory((_html) {
      HtmlUtils.parseCategory(_html, (_categorys) {
        setState(() {
          categorys = _categorys;
          // var category = new Category(name: "肉番", url: "/roufan/");
          // categorys.add(category);
          isHttpComplete = true;
          _controller  = new TabController(length: categorys.length, vsync: this);
        });
      });
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {

      setState(() {
        _keepAlive = true;
      });
    });
  }

// TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => _keepAlive;
}
