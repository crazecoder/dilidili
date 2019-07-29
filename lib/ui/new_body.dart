import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/blocs/newest/newest.dart';
import 'package:flutter/material.dart';
import 'package:dilidili/bean/video.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../application.dart';

//最近更新
class NewBody extends StatelessWidget {
  const NewBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewestBloc _bloc = BlocProvider.of<NewestBloc>(context);
    return BlocBuilder<NewestEvent, NewestState>(
      bloc: _bloc,
      builder: (_context, _state) {
        if (_state is NewestLoadedState) {
          return Scaffold(
            body: GridView.builder(
              itemCount: _state.cartoons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 166 / 117,
              ),
              itemBuilder: (_, i) {
                return _buildGridItem(_context, _state.cartoons[i]);
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildGridItem(BuildContext context, Cartoon cartoon) {
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
}
