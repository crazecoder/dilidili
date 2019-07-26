import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_detail_body.dart';
import '../blocs/blocs.dart';

class CategoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoryBloc _bloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryEvent, CategoryState>(
      bloc: _bloc..dispatch(CategoryLoadEvent()),
      builder: (_context, _state) {
        if (_state is CategoryLoaded) {
          return DefaultTabController(
            length: _state.categorys.length,
            child: Scaffold(
              appBar: PreferredSize(
                child: AppBar(
                  // title: Text("首页"),
                  // centerTitle: true,
                  bottom: TabBar(
                      isScrollable: true,
                      tabs: _state.categorys.map((category) {
                        return Tab(text: category.name);
                      }).toList()),
                ),
                preferredSize: Size.fromHeight(48.0),
              ),
              body: TabBarView(
                  physics: ClampingScrollPhysics(),
                  children: _state.categorys.map((category) {
                    CategoryDetailBloc bloc =CategoryDetailBloc();
                    return BlocProvider<CategoryDetailBloc>(
                      builder: (context) => CategoryDetailBloc(),
                      child: CategoryDetailBody(
                        url: category.url,
                        bloc: bloc,
                        // isShow: !_controller.indexIsChanging,
                      ),
                    );
                    // return CategoryDetailBody(
                    //   url: category.url,
                    //   // isShow: !_controller.indexIsChanging,
                    // );
                  }).toList()),
            ),
          );
        } else if (_state is InitialCategoryState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
