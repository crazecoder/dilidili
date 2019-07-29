import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_body.dart';
import 'category_body.dart';
import 'search_body.dart';
import 'history_body.dart';
import '../blocs/blocs.dart';

class HomePage extends StatelessWidget {
  static var titles = <Text>[
    Text("首页"),
    Text("追番"),
    Text("搜索"),
    Text("我的"),
  ];
  var items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), title: titles[0]),
    BottomNavigationBarItem(icon: Icon(Icons.toc), title: titles[1]),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: titles[2]),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: titles[3]),
  ];

  Widget _buildBody(context, AppTab _state) {
    if (_state == AppTab.CATEGORY) {
      // return CategoryBody(key: PageStorageKey("category"),);
      return CategoryBody();
    } else if (_state == AppTab.NEWEST) {
      return NewBody(key: PageStorageKey("new"),);
    } else if (_state == AppTab.SEARCH) {
      return SearchBody();
    } else if (_state == AppTab.HISTORY) {
      return HistoryBody(
        bloc: BlocProvider.of<HistoryBloc>(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _tabBloc = BlocProvider.of<TabBloc>(context);

    return BlocBuilder<TabEvent, AppTab>(
      bloc: _tabBloc,
      builder: (_context, _state) {
        return Scaffold(
          appBar: _buildAppBar(_context, _state),
          body: _buildBody(_context, _state),
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
                  BlocProvider.of<HistoryBloc>(_context)
                    ..dispatch(HistoryClearEvent());
                },
              )
            : Container(),
      ],
      elevation: _state != AppTab.CATEGORY ? 3 : 0,
      centerTitle: true,
      title: titles[_state.index],
    );
  }
}
