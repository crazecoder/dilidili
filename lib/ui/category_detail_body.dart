import 'dart:async';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/utils/html_util.dart';
import 'package:dilidili/utils/my_print.dart';
import 'package:flutter/foundation.dart';

class CategoryDetailBody extends StatefulWidget {
  final String url;
  final bool isShow;

  CategoryDetailBody({this.url, this.isShow = true});

  @override
  State<StatefulWidget> createState() => new CategoryDetailBodyState();
}

class CategoryDetailBodyState
    extends State<CategoryDetailBody>
    with AutomaticKeepAliveClientMixin
{
  static bool _keepAlive = false;
  bool isHttpComplete = false;
  var cartoons = <Cartoon>[];
  var gridItem = <Widget>[];

  @override
  Widget build(BuildContext context) {
    if (isHttpComplete && widget.isShow) {
      return new GridView.builder(
        itemCount: cartoons.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//        mainAxisSpacing: 4.0,
//        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(4.0),
//        childAspectRatio: 1.3,
        itemBuilder: (_, i) {
          return _buildGridItem(cartoons[i]);
        },
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  Widget _buildGridItem(Cartoon cartoon) {
    return new GestureDetector(
      onTap: () {
        String url = cartoon.url.replaceAll("/", "[");
        String picture = cartoon.picture.replaceAll("/", "[");
        Application.router.navigateTo(context, '/detail/$url/${cartoon.name}/$picture');
      },
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new CachedNetworkImage(
                imageUrl: cartoon.picture,
                placeholder: Center(child: CircularProgressIndicator(),) ,
                errorWidget: new Icon(Icons.error),
              ),
            ),
            new Text(
              cartoon.name,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    http.htmlGetCategoryDetail(widget.url, sfn:(_cs) {
      if (mounted)
        setState(() {
          cartoons = _cs;
          isHttpComplete = true;
        });
    },);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _keepAlive = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _keepAlive;
}
