import 'package:dilidili/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../application.dart';

class DetailHome extends StatelessWidget {
  final String url;
  final String name;
  final String picture;

  DetailHome({this.url, this.name, this.picture});

  @override
  Widget build(BuildContext context) {
    final DetailBloc _bloc = BlocProvider.of<DetailBloc>(context);
    return BlocBuilder<DetailEvent, DetailState>(
      bloc: _bloc..dispatch(DetailLoadEvent(url: url,picture: picture)),
      builder: (_context, _state) {
        // if(_state is InitialDetailState){
        //   _bloc.dispatch(DetailLoadEvent(url: url,picture: picture));
        // }
        return Scaffold(
          appBar: _state is DetailLoadFailedState
              ? AppBar(
                  title: Text(name),
                  centerTitle: true,
                )
              : null,
          body: _buildHome(_context,_state),
        );
      },
    );
  }

  Widget _buildHome(BuildContext _context ,DetailState _state) {
    if (_state is DetailLoadFailedState) {
      return new Center(
        child: new Text("获取数据异常，请访问官网观看"),
      );
    }
    if (_state is DetailLoadedState)
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(_context).size.width * 3 / 4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
              background: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    width: MediaQuery.of(_context).size.width,
                    height: MediaQuery.of(_context).size.width * 3 / 4,
                    fit: BoxFit.fitWidth,
                    imageUrl: _state.picture,
                    // placeholder: (_, s) => new Center(
                    //   child: new CircularProgressIndicator(),
                    // ),
                    errorWidget: (_, _s, _o) => new Icon(Icons.error),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // begin: Alignment(0.0, -1),
                        // end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
                fit: StackFit.expand,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(getListWidget(_context,_state)),
          )
        ],
      );
    else
      return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Center(
          child: new CircularProgressIndicator(),
        ),
      );
  }

  List<Widget> getListWidget(BuildContext _context,DetailLoadedState _state) {
    var _widgets = <Widget>[];
    _state.cartoons.forEach((_cartoon) => _widgets.add(GestureDetector(
          onTap: () {
            String json = jsonEncode(_cartoon);
            json = json.replaceAll("/", "]");
            json = json.replaceAll("?", "");
            Application.router.navigateTo(_context, '/play/$json');
          },
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: MediaQuery.of(_context).size.width,
                padding: new EdgeInsets.all(10.0),
                child: new Text(
                  _cartoon.name,
                  maxLines: 1,
                ),
              ),
              new Divider(),
            ],
          ),
        )));
    return _widgets;
  }
}

// class DetailHomeState extends State<DetailHome> {
//   var _cartoons = <Cartoon>[];
//   bool isCompelete = false;
//   bool isFailed = false;
//   var _picture;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     Application.key = _scaffoldKey;
//     return new Scaffold(
//       key: _scaffoldKey,
//       appBar: isFailed
//           ? new AppBar(
//               title: new Text(widget.name),
//               centerTitle: true,
//             )
//           : null,
//       body: _buildHome(),
//     );
//   }

//   Widget _buildHome() {
//     if (isFailed) {
//       return new Center(
//         child: new Text("获取数据异常，请访问官网观看"),
//       );
//     }
//     if (isCompelete)
//       return CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             expandedHeight: MediaQuery.of(context).size.width * 3 / 4,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 widget.name,
//                 style: TextStyle(fontSize: 16),
//               ),
//               background: Stack(
//                 children: <Widget>[
//                   CachedNetworkImage(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.width * 3 / 4,
//                     fit: BoxFit.fitWidth,
//                     imageUrl: _picture,
//                     // placeholder: (_, s) => new Center(
//                     //   child: new CircularProgressIndicator(),
//                     // ),
//                     errorWidget: (_, _s, _o) => new Icon(Icons.error),
//                   ),
//                   DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         // begin: Alignment(0.0, -1),
//                         // end: Alignment(0.0, -0.4),
//                         colors: <Color>[Color(0x60000000), Color(0x00000000)],
//                       ),
//                     ),
//                   ),
//                 ],
//                 fit: StackFit.expand,
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(getListWidget()),
//           )
//         ],
//       );
//     else
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.name),
//         ),
//         body: Center(
//           child: new CircularProgressIndicator(),
//         ),
//       );
//   }

//   List<Widget> getListWidget() {
//     var _widgets = <Widget>[];
//     _cartoons.forEach((_cartoon) => _widgets.add(GestureDetector(
//           onTap: () {
//             String json = jsonEncode(_cartoon);
//             json = json.replaceAll("/", "]");
//             json = json.replaceAll("?", "");
//             Application.router.navigateTo(context, '/play/$json');
//           },
//           child: new Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               new Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: new EdgeInsets.all(10.0),
//                 child: new Text(
//                   _cartoon.name,
//                   maxLines: 1,
//                 ),
//               ),
//               new Divider(),
//             ],
//           ),
//         )));
//     return _widgets;
//   }

//   @override
//   void initState() {
//     super.initState();
//     String url = widget.url.replaceAll("[", "/");
//     _picture = widget.picture?.replaceAll("[", "/");
//     http.htmlGetCategoryDetailHome(url, sfn: (List<Cartoon> _cs) {
//       if (mounted)
//         setState(() {
//           if (widget.picture == null ||
//               widget.picture.isEmpty ||
//               widget.picture == "null") {
//             _picture = _cs[0].picture;
//           }
//           _cartoons = _cs;
//           isCompelete = true;
//         });
//     }, ffn: () {
//       if (mounted)
//         setState(() {
//           isFailed = true;
//         });
//     });
//   }
// }
