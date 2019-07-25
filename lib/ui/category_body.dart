import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_detail_body.dart';
import '../blocs/blocs.dart';

class CategoryBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CategoryBodyState();
}

class CategoryBodyState extends State<CategoryBody>
    with
        AutomaticKeepAliveClientMixin<CategoryBody>,
        TickerProviderStateMixin<CategoryBody> {
  static bool _keepAlive = false;
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final CategoryBloc _bloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryEvent, CategoryState>(
      bloc: _bloc..dispatch(CategoryLoadEvent()),
      builder: (_context, _state) {
        if (_state is CategoryLoaded) {
          _controller =
              TabController(length: _state.categorys.length, vsync: this);
          return Scaffold(
            appBar: AppBar(
              title: Text("首页"),
              centerTitle: true,
              bottom: TabBar(
                  controller: _controller,
                  isScrollable: true,
                  tabs: _state.categorys.map((category) {
                    return Tab(text: category.name);
                  }).toList()),
            ),
            body: TabBarView(
                controller: _controller,
                physics: ClampingScrollPhysics(),
                children: _state.categorys.map((category) {
                  return CategoryDetailBody(
                    url: category.url,
                    // isShow: !_controller.indexIsChanging,
                  );
                }).toList()),
          );
        } else if (_state is InitialCategoryState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => _keepAlive;
}
