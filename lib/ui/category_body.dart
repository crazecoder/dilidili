import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_detail_body.dart';
import '../blocs/blocs.dart';

class CategoryBody extends StatefulWidget {
  CategoryBody({Key key}) : super(key: key);

  _CategoryBodyState createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody>
    with SingleTickerProviderStateMixin<CategoryBody> {
  @override
  Widget build(BuildContext context) {
    final CategoryBloc _bloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryEvent, CategoryState>(
      bloc: _bloc,
      builder: (_context, _state) {
        if (_state is CategoryLoaded) {
          final TabController _controller =
              TabController(vsync: this, length: _state.categorys.length);
          return BlocListener<TabEvent, AppTab>(
            bloc: BlocProvider.of<TabBloc>(context),
            listener: (context, state) {
              if (state != AppTab.CATEGORY) {
                _bloc
                    .dispatch(CategoryChangeEvent(position: _controller.index));
              }
            },
            child: Scaffold(
              appBar: PreferredSize(
                child: AppBar(
                  bottom: TabBar(
                    controller: _controller..index = _bloc.prePosition,
                    // indicator: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.redAccent),
                    isScrollable: true,
                    tabs: _state.categorys.map((category) {
                      return Tab(text: category.name);
                    }).toList(),
                  ),
                ),
                preferredSize: Size.fromHeight(48.0),
              ),
              body: TabBarView(
                controller: _controller
                  ..addListener(() {
                    _bloc.dispatch(
                        CategoryChangeEvent(position: _controller.index));
                  }),
                physics: ClampingScrollPhysics(),
                children: _state.categorys.map((category) {
                  // final CategoryDetailBloc bloc = CategoryDetailBloc()..dispatch(CategoryDetailLoadEvent(category.url));
                  return CategoryDetailBody(
                    key: PageStorageKey(category.url),
                    url: category.url,
                    bloc: _state.map[category.url],
                  );
                }).toList(),
              ),
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

// class CategoryBody extends StatelessWidget {
//   const CategoryBody({PageStorageKey key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final CategoryBloc _bloc = BlocProvider.of<CategoryBloc>(context);
//     return BlocBuilder<CategoryEvent, CategoryState>(
//       bloc: _bloc,
//       builder: (_context, _state) {
//         if (_state is CategoryLoaded) {
//           return BlocListener<TabEvent, AppTab>(
//             bloc: BlocProvider.of<TabBloc>(context),
//             listener: (context, state) {
//               if (state != AppTab.CATEGORY) {
//                 print("object");
//               }
//             },
//             child: DefaultTabController(
//               length: _state.categorys.length,
//               child: Scaffold(
//                 appBar: PreferredSize(
//                   child: AppBar(
//                     bottom: TabBar(
//                       // indicator: BoxDecoration(
//                       //     borderRadius: BorderRadius.circular(10),
//                       //     color: Colors.redAccent),
//                       isScrollable: true,
//                       tabs: _state.categorys.map((category) {
//                         return Tab(text: category.name);
//                       }).toList(),
//                     ),
//                   ),
//                   preferredSize: Size.fromHeight(48.0),
//                 ),
//                 body: TabBarView(
//                   physics: ClampingScrollPhysics(),
//                   children: _state.categorys.map((category) {
//                     // final CategoryDetailBloc bloc = CategoryDetailBloc()..dispatch(CategoryDetailLoadEvent(category.url));
//                     return CategoryDetailBody(
//                       key: PageStorageKey(category.url),
//                       url: category.url,
//                       bloc: _state.map[category.url],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           );
//         } else if (_state is InitialCategoryState) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
