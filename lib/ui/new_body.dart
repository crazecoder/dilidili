import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/http.dart' as http;
import 'package:dilidili/utils/html_util.dart';
import 'package:dilidili/bean/video.dart';
import 'dart:convert';

//最近更新
class NewBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewBodyState();
}

class NewBodyState extends State<NewBody>
//    with AutomaticKeepAliveClientMixin
{
  bool isHttpComplete = false;
  var cartoons = <Cartoon>[];
  var gridItem = <Widget>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Application.key = _scaffoldKey;
    if (isHttpComplete) {
      return new Scaffold(
        key: _scaffoldKey,
        body: new GridView.builder(
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
        ),
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      http.htmlGetHome((_htmlStr) {
          HtmlUtils.parseHome(_htmlStr,(_cartoons){
            setState(() {
              cartoons = _cartoons;
              isHttpComplete = true;
            });
          });
      });
    });
  }

  Widget _buildGridItem(Cartoon cartoon) {
    return new GestureDetector(
      onTap: () {
        String json = jsonEncode(cartoon);
        json = json.replaceAll("/", "]");
        Application.router.navigateTo(context, '/play/$json');
      },
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new CachedNetworkImage(
                imageUrl: cartoon.picture,
                placeholder: new Center(
                  child: new CircularProgressIndicator(),
                ),
                errorWidget: new Icon(Icons.error),
              ),
            ),
            new Text(
              cartoon.name,
              softWrap: true,
            ),
            new Text(
              cartoon.episode,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  // TODO: implement wantKeepAlive
//  @override
//  bool get wantKeepAlive => true;
}
