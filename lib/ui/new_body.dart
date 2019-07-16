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
        body: GridView.builder(
          itemCount: cartoons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 166 / 117,
          ),
          // staggeredTileBuilder: (_index) => StaggeredTile.fit(2),
          // crossAxisCount: 4,
          //  mainAxisSpacing: 4.0,
//        crossAxisSpacing: 4.0,
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
        HtmlUtils.parseHome(_htmlStr, (_cartoons) {
          if (mounted)
            setState(() {
              cartoons = _cartoons;
              isHttpComplete = true;
            });
        });
      });
    });
  }

  Widget _buildGridItem(Cartoon cartoon) {
    return Container(
      // width: MediaQuery.of(context).size.width / 2 - 5,
      // height: 117 * (MediaQuery.of(context).size.width / 2 - 5) / 166,
      child: new GestureDetector(
        onTap: () {
          String json = jsonEncode(cartoon);
          json = json.replaceAll("/", "]");
          Application.router.navigateTo(context, '/play/$json');
        },
        child: Stack(
          children: <Widget>[
            new CachedNetworkImage(
              imageUrl: cartoon.picture,
              width: MediaQuery.of(context).size.width / 2 - 5,
              height: 117 * (MediaQuery.of(context).size.width / 2 - 5) / 166,
              fit: BoxFit.fill,
              // placeholder: (_, _s) => new Center(
              //   child: new CircularProgressIndicator(),
              // ),
              errorWidget: (_, _s, _o) => Center(
                child: Icon(Icons.error),
              ),
            ),
            Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Opacity(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    child: Center(
                      child: Text(
                        cartoon.name,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                  opacity: 0.5,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(2),
              child: Text(
                cartoon.episode,
                softWrap: true,
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.all(4.0),
    );
  }

  // TODO: implement wantKeepAlive
//  @override
//  bool get wantKeepAlive => true;
}
