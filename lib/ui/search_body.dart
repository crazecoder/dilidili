import 'dart:convert';

import 'package:dilidili/bean/bean.dart';
import 'package:flutter/material.dart';
import 'package:dilidili/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';

class SearchBody extends StatelessWidget {
  final TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final SearchBloc _bloc = BlocProvider.of<SearchBloc>(context);
    return BlocBuilder<SearchEvent, SearchState>(
      bloc: _bloc,
      builder: (_context, _state) {
        // if(_state is InitialSearchState){
        // }else
        if (_state is SearchEmptyState) {
          return _buildEmptyOrErrorBody(_bloc);
        } else if (_state is SearchingState) {
          return _buildLoadingBody(_bloc);
        } else if (_state is SearchSuccessState) {
          return _buildListBody(_context,_bloc);
        }
        return _buildInitializeBody(_bloc);
      },
    );
  }

  Widget _buildInitializeBody(_bloc) => Flex(
        children: <Widget>[_buildSearchView(_bloc)],
        direction: Axis.vertical,
      );
  Widget _buildLoadingBody(_bloc) => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(_bloc),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      );
  Widget _buildEmptyOrErrorBody(SearchBloc _bloc) => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(_bloc),
            Expanded(
              child: Center(
                child: Text(_bloc.currentState is SearchFailedState ? "获取数据异常，请访问官网查看" : "抱歉，没有找到相关结果。"),
              ),
            )
          ],
        ),
      );
  Widget _buildSearchView(SearchBloc _bloc) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 40,
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (_query) {
          _bloc.dispatch(SearchClickEvent(_query));
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: GestureDetector(
            child: Icon(Icons.delete_sweep),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => _editingController.clear());
            },
          ),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          hintText: "请输入查找名称",
        ),
        controller: _editingController,
      ),
    );
  }

  Widget _buildListBody(context,SearchBloc _bloc) => Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchView(_bloc),
            Expanded(
              child: ListView.builder(
                  itemCount: (_bloc.currentState as SearchSuccessState).cartoons.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        String url = (_bloc.currentState as SearchSuccessState).cartoons[i].url.replaceAll("/", "[");
                        if (url.contains("watch")) {
                          String json = jsonEncode((_bloc.currentState as SearchSuccessState).cartoons[i]);
                          json = json.replaceAll("/", "]");
                          json = json.replaceAll("?", "");
                          Application.router.navigateTo(context, '/play/$json');
                        } else
                          Application.router.navigateTo(context,
                              '/detail/$url/${(_bloc.currentState as SearchSuccessState).cartoons[i].name}/${(_bloc.currentState as SearchSuccessState).cartoons[i].picture}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10.0),
                            child: Text((_bloc.currentState as SearchSuccessState).cartoons[i].name),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
}
