import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/bean/bean.dart';
import 'package:dilidili/blocs/blocs.dart';
import 'package:dilidili/blocs/category/category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';

import '../application.dart';

class CategoryDetailBody extends StatelessWidget {
  final String url;
  final CategoryDetailBloc bloc;

  CategoryDetailBody({this.url, this.bloc});

  bool _isFirst = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryDetailEvent, CategoryDetailState>(
      bloc: bloc,
      builder: (_context, _state) {
        if (_state is CategoryDetailLoaded) {
          _isFirst = false;
          return Scrollbar(
            child: GridView.builder(
              itemCount: _state.cartoons?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 11 / 16,
              ),
              itemBuilder: (_, i) {
                return _buildGridItem(_context, _state.cartoons[i]);
              },
            ),
          );
        } else {
          if (_isFirst) bloc.dispatch(CategoryDetailLoadEvent(url));
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildGridItem(context, Cartoon cartoon) {
    return GestureDetector(
      onTap: () {
        String url = cartoon.url.replaceAll("/", "[");
        String picture = cartoon.picture.replaceAll("/", "[");
        Application.router
            .navigateTo(context, '/detail/$url/${cartoon.name}/$picture');
      },
      child: buildGridItem(context, cartoon),
    );
  }

  Widget buildGridItem(context, Cartoon cartoon) => Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width / 2 - 5,
              height: 16 * (MediaQuery.of(context).size.width / 2 - 5) / 11,
              fit: BoxFit.fill,
              imageUrl: cartoon.picture,
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
}
