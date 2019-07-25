import 'dart:convert';

import 'package:dilidili/bean/bean.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../application.dart';

class HistoryBody extends StatelessWidget {
  final HistoryBloc bloc;

  HistoryBody({this.bloc});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryEvent, HistoryState>(
      bloc:bloc..dispatch(HistoryLoadEvent()),
      builder: (_, _state) {
         if (_state is InitialHistoryState){
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
          if(_state is HistoryLoadedState) {
            List<Cartoon> _cartoons = _state.cartoons.reversed.toList();
            return new Scaffold(
              body: ListView.builder(
                  itemCount: _cartoons.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        String json = jsonEncode(_cartoons[i]);
                        json = json.replaceAll("/", "]");
                        Application.router.navigateTo(context, '/play/$json');
                      },
                      child: Row(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            width: 80.0,
                            height: 80,
                            child: _cartoons[i].picture == null ||
                                    _cartoons[i].picture.isEmpty
                                ? Center(
                                    child: Icon(Icons.error),
                                  )
                                : CachedNetworkImage(
                                    width: 80.0,
                                    height: 80,
                                    imageUrl: _cartoons[i].picture,
                                    errorWidget: (_, _s, _o) => Center(
                                      child: Icon(Icons.error),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(_cartoons[i].name),
                                new Text(_cartoons[i].episode == null
                                    ? ""
                                    : _cartoons[i].episode),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } 
          if(_state is HistoryEmptyState) {
            return new Center(
              child: new Text("暂无记录"),
            );
          }
      },
    );
  }
}

