import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryDetailBody extends StatefulWidget {
  final String url;
  final bool isShow;

  CategoryDetailBody({this.url, this.isShow = true});

  @override
  State<StatefulWidget> createState() => new CategoryDetailBodyState();
}

class CategoryDetailBodyState extends State<CategoryDetailBody>
    with AutomaticKeepAliveClientMixin {
  static bool _keepAlive = true;
  bool isHttpComplete = false;
  var cartoons = <Cartoon>[];
  var gridItem = <Widget>[];

  @override
  Widget build(BuildContext context) {
    if (isHttpComplete && widget.isShow) {
      return new StaggeredGridView.countBuilder(
        itemCount: cartoons.length,
        crossAxisCount: 4,
        staggeredTileBuilder: (_index) => StaggeredTile.fit(2),
//        mainAxisSpacing: 4.0,
//        crossAxisSpacing: 4.0,
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
        Application.router
            .navigateTo(context, '/detail/$url/${cartoon.name}/$picture');
      },
      child: buildGridItem(cartoon),
//      new Card(
//        child: new Column(
//          children: <Widget>[
//            new Expanded(
//              child: new CachedNetworkImage(
//                imageUrl: cartoon.picture,
//                placeholder: (context, str) => Center(
//                  child: CircularProgressIndicator(),
//                ),
//                errorWidget: (_, _s, _o) => new Icon(Icons.error),
//              ),
//            ),
//            new Text(
//              cartoon.name,
//              softWrap: true,
//            ),
//          ],
//        ),
//      ),
    );
  }

  Widget buildGridItem(Cartoon cartoon) => Container(
        width: MediaQuery.of(context).size.width / 2 - 5,
        height: 16 * (MediaQuery.of(context).size.width / 2 - 5) / 11,
        margin: EdgeInsets.all(5),
//        padding: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width / 2 - 5,
              height: 16 * (MediaQuery.of(context).size.width / 2 - 5) / 11,
              fit: BoxFit.fill,
              imageUrl: cartoon.picture,
              placeholder: (context, str) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (_, _s, _o) => new Icon(Icons.error),
            ),
            Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Opacity(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 2 - 5,
                    child: Center(
                      child: new Text(
                        cartoon.name,
                        maxLines: 1,
//                            softWrap: true,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                  opacity: 0.5,
                ),
              ],
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    http.htmlGetCategoryDetail(
      widget.url,
      sfn: (_cs) {
        if (mounted)
          setState(() {
            cartoons = _cs;
            isHttpComplete = true;
          });
      },
    );
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
