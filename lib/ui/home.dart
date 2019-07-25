import 'package:dilidili/db/db_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_body.dart';
import 'category_body.dart';
import 'search_body.dart';
import 'history_body.dart';
import '../blocs/blocs.dart';

class HomePage extends StatelessWidget {
  final GlobalKey key;
  HomePage({this.key});

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
    ),
  ];

  Widget _buildBody(context,AppTab _state) {
    if (_state == AppTab.CATEGORY) {
      return CategoryBody();
    } else if (_state == AppTab.NEWEST) {
      return NewBody();
    } else if (_state == AppTab.SEARCH) {
      return SearchBody();
    } else if (_state == AppTab.HISTORY) {
      return HistoryBody(bloc: BlocProvider.of<HistoryBloc>(context),);
    }
    return CategoryBody();
  }

  @override
  Widget build(BuildContext context) {
    final _tabBloc = BlocProvider.of<TabBloc>(context);
    return BlocBuilder<TabEvent, AppTab>(
      bloc: _tabBloc,
      builder: (_context, _state) {
        return Scaffold(
          appBar: _state != AppTab.CATEGORY ? _buildAppBar(_context,_state) : null,
          body: _buildBody(_context,_state),
          bottomNavigationBar: BottomNavigationBar(
            items: items,
            currentIndex: AppTab.values.indexOf(_tabBloc.currentState),
            onTap: (index) {
              _tabBloc.dispatch(UpdateTab(AppTab.values[index]));
            },
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext _context, AppTab _state) {
    return AppBar(
      actions: <Widget>[
        _state == AppTab.HISTORY
            ? GestureDetector(
                child: Container(
                  child: Icon(Icons.delete_sweep),
                  padding: EdgeInsets.only(right: 10),
                ),
                onTap: () {
                  BlocProvider.of<HistoryBloc>(_context)..dispatch(HistoryClearEvent());
                  // DbHelper().clear();
                  // _historyKey.currentState.clearList();
                },
              )
            : Container(),
      ],
      centerTitle: true,
      title: titles[_state.index],
    );
  }
}
